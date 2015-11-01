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


        class LocalDatamanager_Mock: LocalDatamanager {
            override func getRecentFile(index: Int) -> RecentFile? {
                return nil
            }
        }


        let i = Interactor_MAIN()
        i.apiDatamanager = APIDatamanager_MAIN()
        i.localDatamanager = LocalDatamanager_Mock()

        XCTAssertNil(i.localDatamanager!.getRecentFile(123))
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


    class Mocked_LocalDatamanager: LocalDatamanager {
        override var activeGistService: Int {
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
        i.localDatamanager = Mocked_LocalDatamanager()

        p = Presenter_MAIN()
        p?.interactor = i
        p?.view = Mocked_View()

        XCTAssertNotNil(p)
    }

    //TODO: Useless
    func testUpdateConstantOptionsField() {
        let i = Interactor_MAIN()
        i.localDatamanager = LocalDatamanager()
        p?.interactor = i

        XCTAssertNotNil(p?.view)
        p?.updateConstantOptionsField() //mock the view to test
        XCTAssert((p?.view as! Mocked_View)._result == "NoPaste\nIsgd\npublic\nRecent count 0")
    }

    //TODO: Fails when configuration changes, reason; dependent of values in NSUserDefaults
    func testDefaultConfiguration() {
        let i = Interactor_MAIN()
        i.localDatamanager = LocalDatamanager()
        if let x = i.localDatamanager?.configurationRecord {
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
}