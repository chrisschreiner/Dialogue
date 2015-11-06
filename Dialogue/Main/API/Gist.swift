import Foundation
import Result
import SwiftyJSON
import ReactiveCocoa


class API_MAIN: Gist_API_P {
	var session: NSURLSession!
	
	func postGist___(content: GistData, config: Config_P) -> GistSignalProducer {
		return SignalProducer {
			o, d in
			
			let g = GistRequestData()
			if self.session == nil {
				self.session = NSURLSession.sharedSession()
			}
			
			self.performWebRequest(self.session, request: g, completion: {
				result in switch result {
				case .Success(let response):
					o.sendNext(response)
					o.sendCompleted()
					
				case .Failure(let reason):
					o.sendFailed(reason)
				}
			})
		}
	}

	func postGist(content: GistData, config: Config_P) -> GistSignalProducer {
		let g = GistRequestData()
		if self.session == nil {
			self.session = NSURLSession.sharedSession()
		}
		
		return self.performWebRequest(self.session, request: g)
	}

	private struct GistRequestData {
		var authorized: Bool = false
		var gistID: String = ""
		let connectionURL = NSURL(string: "https://api.github.com/gists")
		let header: (filename:String, description:String) = ("filename.ext", "standard description")
		var updateGist: Bool = false
		var isPublic: Bool = false
		var content: String = "123"
	}
	
	
	private func gistHTTPBody(gr: GistRequestData) -> NSData {
		return try! JSON(["description": "\(gr.header.description)", "public": gr.isPublic, "files": [gr.header.filename: ["content": gr.content]], ]).rawData()
	}
	
	
	private func createURLRequest(gr: GistRequestData) -> NSMutableURLRequest {
		var request = NSMutableURLRequest()
		if gr.updateGist {
			let updateURL = gr.connectionURL!.URLByAppendingPathComponent(gr.gistID)
			request = NSMutableURLRequest(URL: updateURL)
			request.HTTPMethod = "PATCH"
		} else {
			request = NSMutableURLRequest(URL: gr.connectionURL!)
			request.HTTPMethod = "POST"
		}
		
		request.HTTPBody = gistHTTPBody(gr)
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
						print(response) //TODO:Decide which file to capture
						
						completion(.Success((url: gistURL, gid: gistID)))
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
	
	private func performWebRequest(session: NSURLSession, request dataForRequest: GistRequestData) -> SignalProducer<SuccessResponse,GistRequestReason> {
		return SignalProducer { o, d in
			let request = self.createURLRequest(dataForRequest)
			let task = session.dataTaskWithRequest(request) {
				data, response, error in
				// let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
				if let r = response as? NSHTTPURLResponse {
					switch r.statusCode {
					case 200 ..< 300:
						let jsonData = JSON(data: data!)
						if let gistURL = jsonData["html_url"].URL, gistID = jsonData["id"].string {
							print(response) //TODO:Decide which file to capture
							
							o.sendNext((url: gistURL, gid: gistID))
							o.sendCompleted()
						} else {
							o.sendFailed(.ErrorResponse("Response-json had an unexpected format, missing fields: html_url or id, statuscode=\(r.statusCode)"))
						}
						
					default:
						o.sendFailed(.OtherErrorResponse(r.statusCode))
					}
				} else {
					o.sendFailed(.ErrorResponse("response was nil (?)"))
				}
			}
			task.resume()
		}
	}
}