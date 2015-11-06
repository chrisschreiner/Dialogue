import XCTest
import SwiftyJSON

//Helper function for testing
func mockGistAPI(statusCode statusCode: Int = 0, responseFile: String = "http://jalla.file", var jsonData:JSON? = nil) -> API_MAIN {
    return MockedApiForGist {
		if jsonData  == nil {
			jsonData = JSON(["html_url": responseFile, "id": "12345678", ])
		}
        let urlResponse = NSHTTPURLResponse(URL: NSURL(), statusCode: statusCode, HTTPVersion: nil, headerFields: nil)

        MockSession.mockResponse = (try! jsonData!.rawData(), urlResponse: urlResponse, error: nil)
        return MockSession()
    }
}

//Helper function for testing
func mockPastebufferAPI(pasteContent: String = "") -> Pastebuffer_API_P {
    return PastebufferGatewayMock {
        return GistData(data: pasteContent)
    }
}


let kSampleFile = "filename.ext"


class InteractorPostTests: XCTestCase {
    var i: MAIN_Interactor!

    override func setUp() {
        super.setUp()

        i = MAIN_Interactor()
        i.config = Config()
        i.pastebufferGateway = mockPastebufferAPI("default paste content")
        i.apiGist = mockGistAPI(statusCode: 200)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBasic() {
        i.postGist().start()
        XCTAssertEqual(i.recentFiles.count, 1)
    }

    func testWith1RecentFile() {
        i.apiGist = mockGistAPI(statusCode: 200, responseFile: kSampleFile)
        i.postGist().start()

        XCTAssertEqual(i.recentFiles.count, 1)
        XCTAssertEqual(i.recentFiles.last, kSampleFile)
    }

    func testWith2RecentFiles() {
        i.pastebufferGateway = mockPastebufferAPI("default paste content")
		
        i.apiGist = mockGistAPI(statusCode: 200, responseFile: kSampleFile + "1")
        i.postGist().start()

        XCTAssertEqual(i.recentFiles.count, 1)
        XCTAssertEqual(i.recentFiles.last, kSampleFile + "1")

        i.apiGist = mockGistAPI(statusCode: 200, responseFile: kSampleFile + "2")
        i.postGist().start()

        XCTAssertEqual(i.recentFiles.count, 2)
        XCTAssertEqual(i.recentFiles.last, kSampleFile + "2")
    }
}


class DT2: XCTestCase {
    var i: MAIN_Interactor!
    var config: Config_P!

    override func setUp() {
        super.setUp()

        config = Config() //mock?

        i = MAIN_Interactor()
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
		i.apiGist = mockGistAPI(statusCode: 201, responseFile: kSampleFile, jsonData:JSON(["html_url": kSampleFile, "id": "12345678", ]))

        let e = expectationWithDescription("...")

        i.postGist().on(next: {
            (response: SuccessResponse) in XCTAssertEqual(response.url.absoluteString, kSampleFile) //errors here, but its okay now
            e.fulfill()
        })
        .start()

        waitForExpectationsWithTimeout(3, handler: nil)
    }

    func testPostGistWithFailure() {
		i.apiGist = mockGistAPI(statusCode: 400)

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
		i.apiGist = mockGistAPI(statusCode: 201, responseFile: kSampleFile, jsonData:JSON(["wrong_field_name": kSampleFile]))

        let e = expectationWithDescription("...")

        i.postGist()
        .on(failed: {
            error in if case GistRequestReason.ErrorResponse(_) = error {
                e.fulfill()
            }
        })
        .start()

        waitForExpectationsWithTimeout(3, handler: nil)
    }

    func testPostGistStatusCode999() {
		i.apiGist = mockGistAPI(statusCode: 999)

        let e = expectationWithDescription("...")

        i.postGist()
        .on(failed: {
            error in if case GistRequestReason.OtherErrorResponse(let statusCode) = error {
				XCTAssertEqual(statusCode,999)
                e.fulfill()
            }
        })
        .start()

        waitForExpectationsWithTimeout(3, handler: nil)
    }
}
