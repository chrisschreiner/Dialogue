//
//  DialogueTests.swift
//  DialogueTests
//
//  Created by Chris Patrick Schreiner on 29/10/15.
//  Copyright © 2015 Chris Patrick Schreiner. All rights reserved.
//

import XCTest
import Dialogue


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