import Cocoa


class Interactor_MAIN {
    var localDatamanager: LocalDatamanager_P?
    var apiDatamanager: APIDatamanager_MAIN_P?
    var output: InteractorOutput_MAIN?
}


extension Interactor_MAIN: InteractorInput_MAIN {
    func submitToGistService() {
        if let dataMan = localDatamanager {
            let rf = RecentFile(filename: "sample", url: "url")
            dataMan.addRecentFile(rf)
            apiDatamanager?.processIt(dataMan)
        }
    }

    func countRecentFiles() -> Int {
        if let dataMan = localDatamanager {
            return dataMan.countRecentFiles()
        }
        return 0
    }

    func recentFileEntry(index: Int) -> Sample {
        if let dataMan = localDatamanager, recentFile = dataMan.getRecentFile(index) {
            let a = recentFile.filename
            let b = recentFile.url.characters.count

            let s = Sample(a: a, b: b)
            return s
        }
        preconditionFailure()
    }

    func clearRecentFiles() {
        localDatamanager?.clearRecentFiles()
    }

    func createStringOfOptions() -> String {
        guard let ldm = localDatamanager else {
            preconditionFailure()
        }

        let gist = GistService(rawValue: ldm.activeGistService ?? 0)!
        let shorten = ShortenService(rawValue: ldm.activeShortenService ?? 0)!
        let secret = ldm.secretGists ?? true
        let recentCount = ldm.countRecentFiles()

        //let s = (localDatamanager!.secretGists ? "Secret" : "Public") + "\n" + "\(localDatamanager!.activeGistService)"

        return "\(gist)\n\(shorten)\n\(secret ? "Secret" : "public")\nRecent count \(recentCount)"
    }
}


protocol APIDatamanager_MAIN_P {
    func processIt(dataManager: LocalDatamanager_P)
}


class APIDatamanager_MAIN: APIDatamanager_MAIN_P {
    func processIt(dataManager: LocalDatamanager_P) {

        //?How do I access the Preferences-Module.LocalDataManager instance ?
        //!Turn the LocalDataManager into a GlobalDatamanager by narrow protocols

        let gist = GistService(rawValue: dataManager.activeGistService ?? 0)!
        let shorten = ShortenService(rawValue: dataManager.activeShortenService ?? 0)!
        let secret = dataManager.secretGists ?? true

        print("processed the gist with: \(gist) \(shorten) \(secret)")
        //TODO:Fix this as well
        print("Total recent: \(dataManager.countRecentFiles()) where the last one was: \(dataManager.getRecentFile(dataManager.countRecentFiles()))")
        print(getPasteboardItems())
    }
}