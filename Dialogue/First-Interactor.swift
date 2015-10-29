import Cocoa


extension Main {


    class Interactor: InteractorInput_FIRST {
        var localDatamanager: LocalDatamanager?
        var apiDatamanager: APIDatamanager?
        var output: InteractorOutput_FIRST?

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

        func recentFileEntry(index: Int) -> Main.Presenter.Sample {
            if let dataMan = localDatamanager, recentFiles = dataMan.recentFiles {
                let a = recentFiles[index].filename
                let b = recentFiles[index].url.characters.count

                let s = Main.Presenter.Sample(a: a, b: b)
                return s
            }
            preconditionFailure()
        }

        func clearRecentFiles() {
            localDatamanager?.clearRecentFiles()
        }

        func createStringOfOptions() -> String {
            guard let dataManager = localDatamanager else {
                preconditionFailure()
            }

            let gist = GistService(rawValue: dataManager.activeGistService ?? 0)!
            let shorten = ShortenService(rawValue: dataManager.activeShortenService ?? 0)!
            let secret = dataManager.secretGists ?? true

            //let s = (localDatamanager!.secretGists ? "Secret" : "Public") + "\n" + "\(localDatamanager!.activeGistService)"

            return "\(gist)\n\(shorten)\n\(secret ? "Secret" : "public")"
        }
    }


    struct Bunny {
        let gist: GistService
        let shorten: ShortenService
        let secret: Bool
    }


}


class APIDatamanager {
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