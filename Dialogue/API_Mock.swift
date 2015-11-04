import ReactiveCocoa
import Foundation


//TODO: Generify this


class MockedApiForGist: API_MAIN {
//    private let _callback: () -> NSURL
	
//    func postGist(content: GistData, config: Config_P) -> SignalProducer<NSURL, GistRequestReason> {
//        return SignalProducer {
//            o, d in
//
//            o.sendNext(self._callback())
//            o.sendCompleted()
//        }
//    }

	init(session: NSURLSession, _callback: () -> NSURL) {
		super.init()
		self.session = session //MockSession.sharedSession()
//        self._callback = _callback
    }
}


class MockSession: NSURLSession {
    var completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?

    static var mockResponse: (data:NSData?, urlResponse:NSURLResponse?, error:NSError?) = (data: nil, urlResponse: nil, error: nil)

    override class func sharedSession() -> NSURLSession {
        return MockSession()
    }

    override func dataTaskWithURL(url: NSURL, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) -> NSURLSessionDataTask {
        self.completionHandler = completionHandler
        return MockTask(response: MockSession.mockResponse, completionHandler: completionHandler)
    }

    override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        self.completionHandler = completionHandler
        return MockTask(response: MockSession.mockResponse, completionHandler: completionHandler)
    }


    class MockTask: NSURLSessionDataTask {
        typealias Response = (data:NSData?, urlResponse:NSURLResponse?, error:NSError?)
        var mockResponse: Response
        let completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?

        init(response: Response, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
            self.mockResponse = response
            self.completionHandler = completionHandler
        }

        override func resume() {
            completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
    }


}