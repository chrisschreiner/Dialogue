import Cocoa


class Interactor_MAIN: InteractorInput_MAIN {
    var localDatamanager: LocalDatamanager?
    var apiDatamanager: APIDatamanager_MAIN?
    var output: InteractorOutput_MAIN?

    func submitToGistService() {
        if let dataMan = localDatamanager {
            let rf = RecentFile(filename: "sample", url: "url")
            dataMan.addRecentFile(rf)
            apiDatamanager?.processIt(dataMan)
        }
    }

    func countRecentFiles() -> Int {
        if let dataMan = localDatamanager, recentFiles = dataMan.recentFiles {
            return recentFiles.count
        }
        return 0
    }

    func recentFileEntry(index: Int) -> Sample {
        if let dataMan = localDatamanager, recentFiles = dataMan.recentFiles {
            let a = recentFiles[index].filename
            let b = recentFiles[index].url.characters.count

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
        let recentCount = ldm.recentFiles?.count ?? 0

        //let s = (localDatamanager!.secretGists ? "Secret" : "Public") + "\n" + "\(localDatamanager!.activeGistService)"

        return "\(gist)\n\(shorten)\n\(secret ? "Secret" : "public")\nRecent count \(recentCount)"
    }
}


class APIDatamanager_MAIN {
    func processIt(dataManager: LocalDatamanager) {

        //?How do I access the Preferences-Module.LocalDataManager instance ?
        //!Turn the LocalDataManager into a GlobalDatamanager by narrow protocols

        let gist = GistService(rawValue: dataManager.activeGistService ?? 0)!
        let shorten = ShortenService(rawValue: dataManager.activeShortenService ?? 0)!
        let secret = dataManager.secretGists ?? true

        //print("processed the gist with: \(gist) \(shorten) \(secret)")
        //print("Total recent: \(dataManager.recentFiles!.count) where the last one was: \(dataManager.recentFiles!.last)")
        print(getPasteboardItems())
    }
}