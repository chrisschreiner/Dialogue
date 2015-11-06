// Module "Main"
//

import Cocoa


class MAIN_Interactor {
    var apiGist: Gist_API_P?
    var output: MAIN_InteractorOutput?
    //attached to the presenter
    var pastebufferGateway: Pastebuffer_API_P?
    //pastebuffer as a service, what about files?
    var config: AppModel_P?

    var recentFiles: RecentFilesArray

    init() {
        recentFiles = RecentFilesArray()
    }
}


extension MAIN_Interactor: MAIN_InteractorInput {
    func postGist() -> GistSignalProducer {

        //setup all data here
        let contentsToGist = pastebufferGateway!.getContents()
        let config = self.config!
        let sp = self.apiGist!.postGist(contentsToGist, config: config)

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
