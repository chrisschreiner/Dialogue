//
//  AppDelegate.swift
//  Dialogue
//
//  Created by Chris Patrick Schreiner on 23/10/15.
//  Copyright © 2015 Chris Patrick Schreiner. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	var wireframe: Wireframe_FIRST?

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		wireframe = Wireframe_FIRST()
		wireframe?.show()
	}
}

