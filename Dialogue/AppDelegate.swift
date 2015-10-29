//
//  AppDelegate.swift
//  Dialogue
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var wireframe: Wireframe_MAIN?
    var globalDatamanager = LocalDatamanager()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        wireframe = Wireframe_MAIN(dataManager: globalDatamanager)
        wireframe?.show()
    }
}


