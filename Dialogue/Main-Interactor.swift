import Cocoa
import Result
import SwiftyJSON
import ReactiveCocoa


class Interactor_MAIN {
    //var localDatamanager: LocalDatamanager_P?
    var apiDatamanager: APIDatamanager_MAIN_P?
    var output: InteractorOutput_MAIN?
}


extension Interactor_MAIN: InteractorInput_MAIN {
    //TODO:Decide if getPasteboardItems should be a free function or not
    func submitToGistService(dataMan: LocalDatamanager_P) {
        let condition = {
            (item: PBItem) -> Bool in switch item {
            case .Text(_ ):
                return true
            default:
                return false
            }
        }

        guard let first = getPasteboardItems().filter(condition).first else {
            return
        }

        let dataContents = GistData(item: first)

        submitToGistService(dataMan, dataContents: dataContents)
    }

    func submitToGistService(dataMan: LocalDatamanager_P, dataContents: GistData) -> SignalProducer<NSURL, ProcessError> {
        return SignalProducer {
            observer, disposable in let gistService = dataMan.activeGistService
            _ = dataMan.activeShortenService
            let userCredentials = UserCredential()

            if let strategy: Strategy = GistServiceFactory.makeStrategy(gistService, userCredentials) {
                switch strategy.processIt(dataContents) {
                case .Failure(_ ):
                    observer.sendFailed(.NotImplementedYet)

                case .Success(let url):
                    observer.sendNext(url)
                    observer.sendCompleted()
                }
            }
            // ?> apiDatamanager?.processIt(dataMan)
        }
    }

    func countRecentFiles(dataMan: LocalDatamanager_P) -> Int {
        return dataMan.countRecentFiles()
    }

    func recentFileEntry(dataMan: LocalDatamanager_P, index: Int) -> Sample {
        if let recentFile = dataMan.getRecentFile(index) {
            let a = recentFile.filename
            let b = recentFile.url.characters.count

            let s = Sample(a: a, b: b)
            return s
        }
        preconditionFailure()
    }

    func clearRecentFiles(dataMan: LocalDatamanager_P) {
        dataMan.clearRecentFiles()
    }

    func createStringOfOptions(dataMan: LocalDatamanager_P) -> String {
        let gist = GistService(rawValue: dataMan.activeGistServiceIndex ?? 0)!
        let shorten = ShortenService(rawValue: dataMan.activeShortenServiceIndex ?? 0)!
        let secret = dataMan.secretGists ?? true
        let recentCount = dataMan.countRecentFiles()

        //let s = (localDatamanager!.secretGists ? "Secret" : "Public") + "\n" + "\(localDatamanager!.activeGistService)"

        return "\(gist)\n\(shorten)\n\(secret ? "Secret" : "public")\nRecent count \(recentCount)"
    }
}


protocol APIDatamanager_MAIN_P {
    func processIt(dataManager: LocalDatamanager_P)

    func sendGist()
}


class APIDatamanager_MAIN: APIDatamanager_MAIN_P {
    func processIt(dataManager: LocalDatamanager_P) {

        //?How do I access the Preferences-Module.LocalDataManager instance ?
        //!Turn the LocalDataManager into a GlobalDatamanager by narrow protocols

        let gist = GistService(rawValue: dataManager.activeGistServiceIndex ?? 0)!
        let shorten = ShortenService(rawValue: dataManager.activeShortenServiceIndex ?? 0)!
        let secret = dataManager.secretGists ?? true

        print("processed the gist with: \(gist) \(shorten) \(secret)")
        //TODO:Fix this as well

        let recentFileCount = dataManager.countRecentFiles()

        let recentFileFilename: String?
        if recentFileCount > 0 {
            recentFileFilename = dataManager.getRecentFile(recentFileCount - 1)?.filename
        } else {
            recentFileFilename = ""
        }

        print("Total recent: \(recentFileCount) where the last one was: \(recentFileFilename)")
        print(getPasteboardItems())
    }


    // ===================================================================================================================


    private typealias ResultType = Result<(NSURL, String), GistRequestReason> -> Void


    private enum GistRequestReason: ErrorType {
        case JustBecause
        case BadMood
        case ErrorResponse(String)
        case OtherErrorResponse(Int)
        case NoContent
    }


    private struct GistRequestData {
        var authorized: Bool = false
        var serviceType: Int = 0
        //default
        var gistID: String? = nil
        let connectionURL = NSURL(string: "https://api.github.com/gists")
        let header: (filename:String, description:String) = ("filename.ext", "standard description")
        var updateGist: Bool = false
        var isPublic: Bool = false
        var content: String = "123"
    }


    private func gistHTTPBody(gr: GistRequestData) -> [String:AnyObject] {
        return ["description": "\(gr.header.description)", "public": gr.isPublic, "files": [gr.header.filename: ["content": gr.content]], ]
    }


    private func createURLRequest(gr: GistRequestData) -> NSMutableURLRequest {
        var request = NSMutableURLRequest()
        if gr.updateGist {
            let updateURL = gr.connectionURL!.URLByAppendingPathComponent(gr.gistID!)
            request = NSMutableURLRequest(URL: updateURL)
            request.HTTPMethod = "PATCH"
        } else {
            request = NSMutableURLRequest(URL: gr.connectionURL!)
            request.HTTPMethod = "POSTp"
        }

        let data = try! JSON(gistHTTPBody(gr)).rawData()
        request.HTTPBody = data
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        //	if let token = oauth.getToken() {
        //		request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        //	}

        return request
    }


    private func performWebRequest(session: NSURLSession, request dataForRequest: GistRequestData, completion: ResultType) {
        let request = createURLRequest(dataForRequest)
        let task = session.dataTaskWithRequest(request) {
            data, response, error in //		let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            let r = response as! NSHTTPURLResponse

            switch r.statusCode {
            case 200 ..< 300:
                let jsonData = JSON(data: data!)
                if let gistURL = jsonData["html_url"].URL, gistID = jsonData["id"].string {
                    completion(.Success(gistURL, gistID))
                } else {
                    completion(.Failure(.ErrorResponse("Response-json had an unexpected format, missing fields: html_url or id, statuscode=\(r.statusCode)")))
                }

            default:
                completion(.Failure(.OtherErrorResponse(r.statusCode)))
            }
        }
        task.resume()
    }


    func sendGist() {
        var g = GistRequestData()
        let session = NSURLSession.sharedSession()

        performWebRequest(session, request: g, completion: {
            result in switch result {
            case .Success(let value, let ugh):
                print("Success: \(value) \(ugh)")

            case .Failure(let reason):
                switch reason {
                case .BadMood:
                    print("failed because of bad mood")
                case .JustBecause:
                    print("failed just because")
                case .ErrorResponse(let i):
                    print("ErrorResponse: \(i)")
                default:
                    print(reason)
                }
            }
        })
    }
}