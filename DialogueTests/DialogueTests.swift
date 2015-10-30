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
            print(s)
            _result = s
        }
    }


    override func setUp() {
        super.setUp()

        let d = LocalDatamanager() //you probably want to mock this
        let w = Wireframe_MAIN(dataManager: d)
        let i = Interactor_MAIN()
        i.apiDatamanager = Mocked_APIDatamanager()
        i.localDatamanager = d

        p = Presenter_MAIN()
        p?.wireframe = w
        p?.interactor = i
        p?.view = Mocked_View()

        XCTAssertNotNil(p)
    }

    func testSendGist() {
        XCTAssertNotNil(p?.view)
        p?.updateConstantOptionsField() //mock the view to test
        XCTAssert((p?.view as! Mocked_View)._result == "NoPaste\nIsgd\npublic\nRecent count 0")
    }
}