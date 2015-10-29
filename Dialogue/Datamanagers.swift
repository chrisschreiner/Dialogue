import Cocoa


struct UserDefaultsKeys {
    static let GistServiceIndexKey = "gistServiceIndex"
    static let ShortenServiceIndexKey = "shortenServiceIndex"
    static let SecretGistKey = "secretGists"
}


let NotificationNameOptionsUpdated = "OptionsUpdated"

class LocalDatamanager {
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
