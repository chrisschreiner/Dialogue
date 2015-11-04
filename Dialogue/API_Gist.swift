import Foundation
import Result
import SwiftyJSON
import ReactiveCocoa


class API_MAIN: API_MAIN_P {
	var session: NSURLSession!
	
    func postGist(content: GistData, config: Config_P) -> SignalProducer<NSURL, GistRequestReason> {
        return SignalProducer { o, d in
			
			let g = GistRequestData()
            //let session = NSURLSession.sharedSession()

            self.performWebRequest(self.session, request: g, completion: {result in
				switch result {
                case .Success(let value, _):
					print(value)
                    o.sendNext(value)
                    o.sendCompleted()

                case .Failure(let reason):
                    o.sendFailed(reason)
                }
            })
        }
    }


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
            request.HTTPMethod = "POST"
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
			if let r = response as? NSHTTPURLResponse {

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
			} else {
				completion(.Failure(.ErrorResponse("response was nil (?)")))
			}
        }
        task.resume()
    }
}