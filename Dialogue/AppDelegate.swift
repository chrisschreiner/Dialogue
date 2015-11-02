//
//  AppDelegate.swift
//  Dialogue
//

import Cocoa
import ReactiveCocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var wireframe: Wireframe_MAIN!
    var config: Config!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        config = Config()
        wireframe = Wireframe_MAIN(config: config)
        wireframe.show()
    }
}