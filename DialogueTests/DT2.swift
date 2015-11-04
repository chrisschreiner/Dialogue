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

	/*
	func testPostAGistThroughGitHubAnonymously() {
	let e = expectationWithDescription("...")
	//A
	i.submitToGistService(config, content: i.pastebufferGateway!.getContents())
	.on(next:{url in
	if url == NSURL(string:"http://sample.url") {
	e.fulfill()
	}
	})
	.start()
	waitForExpectationsWithTimeout(3, handler: {_ in})
	}
	*/

	func testPostGist() {
		class PastebufferGatewayMock: PB_Gateway {
			func getContents() -> GistData {
				return GistData(data: "packet")
			}
		}
		i.pastebufferGateway = PastebufferGatewayMock()

		i.apiDatamanager = MockedApiForGist({}) {
		}

		XCTAssertNotNil(i.config)

		let e = expectationWithDescription("...")

		i.postGist()
			.on(next: {
				url in XCTAssertEqual(url, NSURL(string: "http://sample.url")!)
				e.fulfill()
			})
			.start()

		waitForExpectationsWithTimeout(3, handler: { _ in })
	}
}