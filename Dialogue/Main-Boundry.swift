import Foundation
import ReactiveCocoa
import Result


/// Module MAIN
/// Messages from `Presenter` to `Interactor`


protocol InteractorInput_MAIN {
    //async, try also with a callback and see how the api differs from signals
    func postGist() -> SignalProducer<NSURL, GistRequestReason>

    func countRecentFiles() -> Int

    func recentFileEntry(index: Int) -> Sample

    func clearRecentFiles()

    func createStringOfOptions() -> String
}


/// Module MAIN
/// Messages from `Interactor` to `Presenter`


protocol InteractorOutput_MAIN {
    func giveMeTheURL() -> NSURL
}





