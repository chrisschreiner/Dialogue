import Cocoa


class Interactor_MAIN {
    var apiDatamanager: API_MAIN_P?
    //TODO: Namechange GIST_API (|:?)
    var output: InteractorOutput_MAIN?
    //attached to the presenter
    var pastebufferGateway: PB_Gateway?
    //pastebuffer as a service, what about files?
    var config: Config_P?

    var recentFiles: RecentFilesArray

    init() {
        recentFiles = RecentFilesArray()
    }
}


extension Interactor_MAIN: MAIN_Interactor_Input {
    func postGist() -> ProducerOfGistSignals {

        //setup all data here
        let contentsToGist = pastebufferGateway!.getContents()
        let config = self.config!
        let sp = self.apiDatamanager!.postGist(contentsToGist, config: config)

        sp.startWithNext {
            a in let responseFile = a.url.absoluteString
            self.recentFiles.append(responseFile)
        }

        return sp
    }

    func createStringOfOptions() -> String {
        let gist = GistService(rawValue: config!.activeGistServiceIndex ?? 0)!
        let shorten = ShortenService(rawValue: config!.activeShortenServiceIndex ?? 0)!
        let secret = config!.secretGists ?? true
        let recentCount = self.recentFiles.count

        return "\(gist)\n\(shorten)\n\(secret ? "Secret" : "public")\nRecent count \(recentCount)"
    }
}
