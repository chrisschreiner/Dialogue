//
//  DT2.swift
//  Dialogue
//

import XCTest


class DT2: XCTestCase {
    var i: Interactor_MAIN!
    //    var w: Wireframe_MAIN!
    var p: Presenter_MAIN!
    var config: Config_P!

    override func setUp() {
        super.setUp()

        config = Config() //mock?

        i = Interactor_MAIN()
        i.config = config

        p = Presenter_MAIN(config: config)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAssertDefaultGistIsGitHub() {
        XCTAssert(config.activeGistService == GistService.GitHub)
    }

    func testPostGist() {
        func mockedSession() -> NSURLSession {
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(["html_url": "whatever", "id": "12345678", ], options: NSJSONWritingOptions.PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api.app.net/posts/stream/global")!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)

            return MockSession()
        }

        let sampleURL = NSURL(string: "http://sample.url")!

        i.pastebufferGateway = PastebufferGatewayMock {
            return GistData(data: "packet")
        }

		i.apiDatamanager = MockedApiForGist(session: mockedSession()) {
			//nop
			return sampleURL
        }

        let e = expectationWithDescription("Post")

        i.postGist().on(next: {
            url in XCTAssertEqual(url, sampleURL) //errors here, but its okay now
            e.fulfill()
        })
        .start()

        waitForExpectationsWithTimeout(3, handler: { _ in })
    }
}