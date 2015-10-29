import Cocoa


struct UserDefaultsKeys {
    static let GistServiceIndexKey = "gistServiceIndex"
    static let ShortenServiceIndexKey = "shortenServiceIndex"
    static let SecretGistKey = "secretGists"
}


let NotificationNameOptionsUpdated = "OptionsUpdated"


protocol LocalDatamanager_P {
    var activeGistService: Int { get set }
    var activeShortenService: Int { get set }
    var secretGists: Bool { get set }
    //var recentFiles: [RecentFile] {get set}

    func countRecentFiles() -> Int

    func getRecentFile(index: Int) -> RecentFile?

    func addRecentFile(rf: RecentFile)

    func clearRecentFiles()

    func notifyWorld()
}


class LocalDatamanager: LocalDatamanager_P {
    private var userDefaults = NSUserDefaults.standardUserDefaults()

    var activeGistService: Int {
        get {
            return userDefaults.integerForKey(UserDefaultsKeys.GistServiceIndexKey) ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: UserDefaultsKeys.GistServiceIndexKey)
            notifyWorld()
        }
    }
    var activeShortenService: Int {
        get {
            return userDefaults.integerForKey(UserDefaultsKeys.ShortenServiceIndexKey) ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: UserDefaultsKeys.ShortenServiceIndexKey)
            notifyWorld()
        }
    }
    var secretGists: Bool {
        get {
            return userDefaults.boolForKey(UserDefaultsKeys.SecretGistKey) ?? true
        }
        set {
            userDefaults.setBool(newValue, forKey: UserDefaultsKeys.SecretGistKey)
            notifyWorld()
        }
    }

    //TODO:This is stupid and wrong, fix it tomorrow
    func countRecentFiles() -> Int {
        return recentFiles?.count ?? 0
    }

    func getRecentFile(index: Int) -> RecentFile? {
        return recentFiles?[index]
    }

    func addRecentFile(rf: RecentFile) {
        recentFiles?.append(rf)
        notifyWorld()
    }

    func clearRecentFiles() {
        recentFiles?.removeAll(keepCapacity: false)
        notifyWorld()
    }

    var recentFiles: [RecentFile]? = []

    func notifyWorld() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNameOptionsUpdated, object: nil)
    }
}
