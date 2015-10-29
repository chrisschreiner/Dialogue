//
//  AppDelegate.swift
//  Dialogue
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var wireframe: Main.Wireframe?
    var globalDatamanager = LocalDatamanager()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        wireframe = Main.Wireframe(dataManager: globalDatamanager)
        wireframe?.show()
    }
}


