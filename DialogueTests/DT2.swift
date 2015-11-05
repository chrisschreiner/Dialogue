import XCTest
import SwiftyJSON


func mockGistAPI(statusCode statusCode: Int = 0, responseFile: String = "http://jalla.file") -> API_MAIN {
    return MockedApiForGist {
        //let sampleURL = NSURL(string: "http://sample.url")!
        let jsonData = JSON(["html_url": responseFile, "id": "12345678", ])
        let urlResponse = NSHTTPURLResponse(URL: NSURL(), statusCode: statusCode, HTTPVersion: nil, headerFields: nil)

        MockSession.mockResponse = (try! jsonData.rawData(), urlResponse: urlResponse, error: nil)
        return MockSession()
    }
}

func mockPastebufferAPI(pasteContent: String = "") -> Pastebuffer_API_P {
    return PastebufferGatewayMock {
        return GistData(data: pasteContent)
    }
}


class PresenterInteractorTests: XCTestCase {

    let kSampleFile = "filename.ext"
    var i: Interactor_MAIN!
    var presenter: MAIN_Presenter_Input!

    override func setUp() {
        super.setUp()

        i = Interactor_MAIN()
        i.config = Config()
        i.pastebufferGateway = mockPastebufferAPI("default paste content")
        i.apiDatamanager = mockGistAPI(statusCode: 200)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBasic() {
        i.postGist().start()
        XCTAssertEqual(i.recentFiles.count, 1)
    }

    func testWith1RecentFile() {
        i.apiDatamanager = mockGistAPI(statusCode: 200, responseFile: kSampleFile)
        let sp = i.postGist().start()

        XCTAssertEqual(i.recentFiles.count, 1)
        XCTAssertEqual(i.recentFiles.last, kSampleFile)
    }

    func testWith2RecentFiles() {
        i.apiDatamanager = mockGistAPI(statusCode: 200, responseFile: kSampleFile + "1")
        i.postGist().start()

        XCTAssertEqual(i.recentFiles.count, 1)
        XCTAssertEqual(i.recentFiles.last, kSampleFile + "1")

        i.apiDatamanager = mockGistAPI(statusCode: 200, responseFile: kSampleFile + "2")
        i.postGist().start()

        XCTAssertEqual(i.recentFiles.count, 2)
        XCTAssertEqual(i.recentFiles.last, kSampleFile + "2")
    }
}


class DT2: XCTestCase {
    var i: Interactor_MAIN!
    var config: Config_P!
    let sampleURL = NSURL(string: "http://sample.url")!
    let dummyURL = NSURL(string: "http://sample.url")!

    override func setUp() {
        super.setUp()

        config = Config() //mock?

        i = Interactor_MAIN()
        i.config = config
        i.pastebufferGateway = PastebufferGatewayMock {
            return GistData(data: "packet")
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAssertDefaultGistIsGitHub() {
        XCTAssert(config.activeGistService == GistService.GitHub)
    }

    func testPostGist() {
        i.apiDatamanager = MockedApiForGist {
            let jsonData = JSON(["html_url": self.sampleURL.absoluteString, "id": "12345678", ])
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api.app.net/posts/stream/global")!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

            MockSession.mockResponse = (try! jsonData.rawData(), urlResponse: urlResponse, error: nil)
            return MockSession()
        }

        let e = expectationWithDescription("...")

        i.postGist().on(next: {
            (response: SuccessResponse) in XCTAssertEqual(response.url, self.sampleURL) //errors here, but its okay now
            e.fulfill()
        })
        .start()

        waitForExpectationsWithTimeout(3, handler: nil)
    }

    func testPostGistWithFailure() {
        i.apiDatamanager = MockedApiForGist {
            let jsonData = JSON([])
            let urlResponse = NSHTTPURLResponse(URL: NSURL(), statusCode: 400, HTTPVersion: nil, headerFields: nil)

            MockSession.mockResponse = (try! jsonData.rawData(), urlResponse: urlResponse, error: nil)
            return MockSession()
        }

        let e = expectationWithDescription("...")

        i.postGist()
        .on(failed: {
            error in if case GistRequestReason.OtherErrorResponse(400 ..< 500) = error {
                e.fulfill()
            }
        })
        .start()

        waitForExpectationsWithTimeout(3, handler: nil)
    }

    func testPostGistWithIncompleteFields() {
        i.apiDatamanager = MockedApiForGist {
            let jsonData = JSON(["wrong_field_name": "", "id": "12345678", ])
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api.app.net/posts/stream/global")!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

            MockSession.mockResponse = (try! jsonData.rawData(), urlResponse: urlResponse, error: nil)
            return MockSession()
        }

        let e = expectationWithDescription("...")

        i.postGist()
        .on(failed: {
            error in if case GistRequestReason.ErrorResponse(let s) = error {
                print(s)
                e.fulfill()
            }
        })
        .start()

        waitForExpectationsWithTimeout(3, handler: nil)
    }

    func testPostGistStatusCode999() {
        i.apiDatamanager = MockedApiForGist {
            let jsonData = JSON([])
            let urlResponse = NSHTTPURLResponse(URL: NSURL(), statusCode: 999, HTTPVersion: nil, headerFields: nil)

            MockSession.mockResponse = (try! jsonData.rawData(), urlResponse: urlResponse, error: nil)
            return MockSession()
        }

        let e = expectationWithDescription("...")

        i.postGist()
        .on(failed: {
            error in if case GistRequestReason.OtherErrorResponse(let statusCode) = error {
                print(statusCode)
                e.fulfill()
            }
        })
        .start()

        waitForExpectationsWithTimeout(3, handler: nil)
    }
}
