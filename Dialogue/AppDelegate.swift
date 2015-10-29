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
            notifyWorld()
        }
    }
    var activeShortenService: Int {
        get {
            return userDefaults.integerForKey("shortenServiceIndex") ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: "shortenServiceIndex")
            notifyWorld()
        }
    }
    var secretGists: Bool {
        get {
            return userDefaults.boolForKey("secretGists") ?? true
        }
        set {
            userDefaults.setBool(newValue, forKey: "secretGists")
            notifyWorld()
        }
    }

    //TODO:Invent mechanism to notifyWorld when recentFiles changes
    var recentFiles: [RecentFile]? = []

    func notifyWorld() {
        NSNotificationCenter.defaultCenter().postNotificationName("OptionsUpdated", object: nil)
    }
}


struct RecentFile {
    let filename: String
    let url: String
}
