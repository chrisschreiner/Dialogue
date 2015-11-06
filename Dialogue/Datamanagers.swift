import Cocoa


let NotificationNameOptionsUpdated = "OptionsUpdated"


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


protocol Config_P {
    var activeGistService: GistService { get }
    var activeShortenService: ShortenService { get }
    var activeGistServiceIndex: Int { get set }
    var activeShortenServiceIndex: Int { get set }
    var secretGists: Bool { get set }

    func notifyWorld()

	var configurationRecord: ConfigurationRecord {get}
}


class Config: Config_P {
	private struct UserDefaultsKeys {
		static let GistServiceIndexKey = "gistServiceIndex"
		static let ShortenServiceIndexKey = "shortenServiceIndex"
		static let SecretGistKey = "secretGists"
	}
	

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

    func notifyWorld() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNameOptionsUpdated, object: nil)
    }

    var configurationRecord: ConfigurationRecord {
		return ConfigurationRecord(fromDataManager:self)
	}

}



class RecentFilesArray {
	var _data: [String]
	var count: Int {
		return _data.count
	}
	var last: String? {
		return _data.last
	}
	func append(s: String) {
		_data.append(s)
	}
	
	func removeAll() {
		_data.removeAll()
	}
	
	init() {
		_data = []
	}
}


struct GistData {
	var data: String
	init(item: PBItem) {
		switch item {
		case .Text(let text):
			self.data = text
		default:
			preconditionFailure("undefined")
		}
	}
	init(data: String) {
		self.data = data
	}
}
