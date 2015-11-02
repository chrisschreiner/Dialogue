import Cocoa


struct UserDefaultsKeys {
    static let GistServiceIndexKey = "gistServiceIndex"
    static let ShortenServiceIndexKey = "shortenServiceIndex"
    static let SecretGistKey = "secretGists"
}


struct ConfigurationRecord {
	let gistService: GistService
	let shortenService: ShortenService
	let secretGists: Bool

    init(fromDataManager data: Config_P) {
        self.gistService = GistService(rawValue: data.activeGistServiceIndex)!
        self.shortenService = ShortenService(rawValue: data.activeShortenServiceIndex)!
		self.secretGists = data.secretGists
	}
}

let NotificationNameOptionsUpdated = "OptionsUpdated"


protocol Config_P {
    var activeGistService: GistService { get }
    var activeShortenService: ShortenService { get }
    var activeGistServiceIndex: Int { get set }
    var activeShortenServiceIndex: Int { get set }
    var secretGists: Bool { get set }
    //var recentFiles: [RecentFile] {get set}

    func countRecentFiles() -> Int

    func getRecentFile(index: Int) -> RecentFile?

    func addRecentFile(rf: RecentFile)

    func clearRecentFiles()

    func notifyWorld()

	var configurationRecord: ConfigurationRecord {get}
}


class Config: Config_P {
    private var userDefaults = NSUserDefaults.standardUserDefaults()

    var activeGistService: GistService {
        get {
            return GistService(rawValue: self.activeGistServiceIndex)!
        }
    }

    var activeShortenService: ShortenService {
        get {
            return ShortenService(rawValue: self.activeShortenServiceIndex)!
        }
    }

    var activeGistServiceIndex: Int {
        get {
            return userDefaults.integerForKey(UserDefaultsKeys.GistServiceIndexKey) ?? 0
        }
        set {
            userDefaults.setInteger(newValue, forKey: UserDefaultsKeys.GistServiceIndexKey)
            notifyWorld()
        }
    }
    var activeShortenServiceIndex: Int {
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

    //TODO:This is stupid and wrong, fix it asap
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

    var configurationRecord: ConfigurationRecord {
		return ConfigurationRecord(fromDataManager:self)
	}

}
