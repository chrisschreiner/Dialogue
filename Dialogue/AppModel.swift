import Foundation
import SwiftyUserDefaults

let PreferencesUpdatedNotification = "PreferencesUpdatedNotification"


protocol AppModel_P {
    var activeGistService: GistService { get }
    var activeShortenService: ShortenService { get }
    var activeGistServiceIndex: Int { get set }
    var activeShortenServiceIndex: Int { get set }
    var secretGists: Bool { get set }

    func notifyWorld()

    var configurationRecord: ConfigurationRecord { get }
	var userDefaults: NSUserDefaults {get}
}


extension DefaultsKeys {
	static let gistService = DefaultsKey<Int>("gistService")
	static let launchCount = DefaultsKey<Int>("launchCount")
	static let shortenService = DefaultsKey<Int>("shortenService")
	static let secretGists = DefaultsKey<Bool>("secretGists")
}

//Defaults[.username] = "Peter"


class AppModel: AppModel_P {

	init() {
		//Defaults[.gistService] = 1
		print(userDefaults[.launchCount])
		userDefaults[.launchCount] += 1
	}
	
    private struct UserDefaultsKeys {
        static let GistServiceIndexKey = "gistServiceIndex"
        static let ShortenServiceIndexKey = "shortenServiceIndex"
        static let SecretGistKey = "secretGists"
    }


	var userDefaults = NSUserDefaults.standardUserDefaults()


	
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
        NSNotificationCenter.defaultCenter().postNotificationName(PreferencesUpdatedNotification, object: nil)
    }

    var configurationRecord: ConfigurationRecord {
        return ConfigurationRecord(fromDataManager: self)
    }

}

