import Foundation
import Result
import SwiftyJSON
import ReactiveCocoa


class API_MAIN: API_MAIN_P {
	
	func postGist(content:GistData, config:Config_P) -> SignalProducer<NSURL, ProcessError> {
		return SignalProducer { _ in }
	}
	
	
    func sendGist(data: GistData) {
        preconditionFailure("not implemented \(data)")
    }
    /*    func processIt(config: Config_P) {

    let gist = GistService(rawValue: config.activeGistServiceIndex ?? 0)!
    let shorten = ShortenService(rawValue: config.activeShortenServiceIndex ?? 0)!
    let secret = config.secretGists ?? true

    print("processed the gist with: \(gist) \(shorten) \(secret)")
    //TODO:Fix this as well

    let recentFileCount = config.countRecentFiles()

    let recentFileFilename: String?
    if recentFileCount > 0 {
    recentFileFilename = config.getRecentFile(recentFileCount - 1)?.filename
    } else {
    recentFileFilename = ""
    }

    print("Total recent: \(recentFileCount) where the last one was: \(recentFileFilename)")
    print(getPasteboardItems())
    }*/


    // ===================================================================================================================


	
	
	
    private typealias ResultType = Result<(NSURL, String), GistRequestReason> -> Void



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
        let g = GistRequestData()
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