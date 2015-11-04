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

		//w = Wireframe_MAIN(config: config)
		i = Interactor_MAIN()

		p = Presenter_MAIN(config: config)
		i.config = config
	}

	override func tearDown() {
		super.tearDown()
	}

	func testAssertDefaultGistIsGitHub() {
		XCTAssert(config.activeGistService == GistService.GitHub)
	}

	func testPostGist() {
		let sampleURL = NSURL(string: "http://sample.url")!
		
		i.pastebufferGateway = PastebufferGatewayMock {return GistData(data: "packet")}
		i.apiDatamanager = MockedApiForGist {return sampleURL}

		XCTAssertNotNil(i.config)

		let e = expectationWithDescription("...")

		i.postGist()
			.on(next: {
				url in XCTAssertEqual(url, sampleURL)
				e.fulfill()
			})
			.start()

		waitForExpectationsWithTimeout(3, handler: { _ in })
	}
}