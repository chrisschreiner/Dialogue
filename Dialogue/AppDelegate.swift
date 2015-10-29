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
    var wireframe: Main.Wireframe?
    var globalDatamanager = LocalDatamanager()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        wireframe = Main.Wireframe(dataManager: globalDatamanager)
        wireframe?.show()
    }
}


class LocalDatamanager {
    private var userDefaults = NSUserDefaults.standardUserDefaults()

    var activeGistService: Int {
        get {
            return userDefaults.integerForKey("gistServiceIndex") ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: "gistServiceIndex")
        }
    }
    var activeShortenService: Int {
        get {
            return userDefaults.integerForKey("shortenServiceIndex") ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: "shortenServiceIndex")
        }
    }
    var secretGists: Bool {
        get {
            return userDefaults.boolForKey("secretGists") ?? true
        }
        set {
            print(__FUNCTION__)
            userDefaults.setBool(newValue, forKey: "secretGists")
        }
    }
    var recentFiles: [RecentFile]? = []
}


struct RecentFile {
    let filename: String
    let url: String
}
