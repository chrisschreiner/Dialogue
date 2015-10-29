class APIDatamanager_MAIN {
    func processIt(dataManager: LocalDatamanager) {

        //?How do I access the Preferences-Module.LocalDataManager instance ?
        //!Turn the LocalDataManager into a GlobalDatamanager by narrow protocols

        let gist = GistService(rawValue: dataManager.activeGistService ?? 0)!
        let shorten = ShortenService(rawValue: dataManager.activeShortenService ?? 0)!
        let secret = dataManager.secretGists ?? true

        //            print("processed the gist with: \(gist) \(shorten) \(secret)")
        //            print("Total recent: \(dataManager.recentFiles!.count) where the last one was: \(dataManager.recentFiles!.last)")
        print(getPasteboardItems())
    }
}