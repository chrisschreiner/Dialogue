//
//  AppDelegate.swift
//  Dialogue
//

import Cocoa
import ReactiveCocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var wireframe: MAIN_Wireframe!
    var config: Config!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        config = Config()
        wireframe = MAIN_Wireframe(config: config)
        wireframe.view.showWindow(nil)
    }
}