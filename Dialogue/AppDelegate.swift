//
//  AppDelegate.swift
//  Dialogue
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var wireframe: Wireframe_MAIN?
    var datamanager = LocalDatamanager()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        wireframe = Wireframe_MAIN(dataManager: datamanager)
        wireframe?.show()
    }
}


