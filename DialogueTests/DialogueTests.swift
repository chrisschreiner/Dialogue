//
//  DialogueTests.swift
//  DialogueTests
//
//  Created by Chris Patrick Schreiner on 29/10/15.
//  Copyright © 2015 Chris Patrick Schreiner. All rights reserved.
//

import XCTest
import Dialogue
import ReactiveCocoa


class DialogueTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {


        class LocalDatamanager_Mock: Config {
            override func getRecentFile(index: Int) -> RecentFile? {
                return nil
            }
        }


        let i = Interactor_MAIN()
        i.apiDatamanager = APIDatamanager_MAIN()
        let dataMan = LocalDatamanager_Mock()

        XCTAssertNil(dataMan.getRecentFile(123))
    }
}


class SomeTests: XCTestCase {
    var i: Interactor_MAIN?
    var p: Presenter_MAIN?


    class Mocked_APIDatamanager: APIDatamanager_MAIN {
        //anything you do here
    }


    class Mocked_View: View_MAIN {
        var _result: String?
        override func updateConstantOutput(s: String) {
            _result = s
        }
    }


    class Mocked_LocalDatamanager: Config {
        override var activeGistServiceIndex: Int {
            get {
                return 0
            }
            set {
            }
        }
    }


    override func setUp() {
        super.setUp()

        let i = Interactor_MAIN()
        i.apiDatamanager = Mocked_APIDatamanager()

        p = Presenter_MAIN(config: Mocked_LocalDatamanager())
        p?.interactor = i
        p?.view = Mocked_View()

        XCTAssertNotNil(p)
    }

    //TODO: Useless
    func testUpdateConstantOptionsField() {
        let i = Interactor_MAIN()
        p?.interactor = i
        p?.config = Config()

        XCTAssertNotNil(p?.view)
        p?.updateConstantOptionsField() //mock the view to test
        XCTAssert((p?.view as! Mocked_View)._result == "NoPaste\nIsgd\npublic\nRecent count 0")
    }

    //TODO: Fails when configuration changes, reason; dependent of values in NSUserDefaults
    func testDefaultConfiguration() {
        let i = Interactor_MAIN()
        if let x = p?.config.configurationRecord {
            XCTAssertEqual(x.gistService, GistService.NoPaste)
            XCTAssertEqual(x.shortenService, ShortenService.Isgd)
            XCTAssertTrue(x.secretGists)
        }
    }

    func testPublishGistFromPastebuffer() {
        //select whats in the pasteboard (mock it)
        //send it to the active GistService:
        //a. build a request for the active service
        //b. perform the request
        //c. store returned url
        //capture the url and add that to the recentFiles (todo: name-change)
        let x = getPasteboardItems()
        print(x.count)
    }

    func testLastStuff() {
        let e = expectationWithDescription("whatever")
        let i = Interactor_MAIN()

        let dummyData = GistData(data: "Hello world")
        i.submitToGistService(p!.config, content: dummyData)
        .on(failed: { err in e.fulfill() })
        .start()

        waitForExpectationsWithTimeout(1) {
            error in }
    }

    func testNamingISVeryHard() {
        let e = expectationWithDescription("whatever")
        let i = Interactor_MAIN()

        let data = GistData(data: "Some text to share")
        let closure: (data:NSURL) -> Void = {
            data in print(data.absoluteString); e.fulfill()
        }
        let producer = i.submitToGistService(p!.config, content: data)

        producer.on(next: closure).start()

        /*
                dataMan.addRecentFile(RecentFile(url: url))
                //open url in a browser-window
                NSWorkspace.sharedWorkspace().openURL(url)
        */

        waitForExpectationsWithTimeout(3) {
            error in }
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


func mockedSession() -> NSURLSession {
    let jsonData = try! NSJSONSerialization.dataWithJSONObject(["html_url": "whatever", "id": "12345678", ], options: NSJSONWritingOptions.PrettyPrinted)
    let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api.app.net/posts/stream/global")!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

    MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)

    return MockSession()
}