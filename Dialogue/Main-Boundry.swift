import Foundation
import ReactiveCocoa
import Result


/// Module MAIN
/// Messages from `Presenter` to `Interactor`


protocol MAIN_Interactor_Input {
    //async, try also with a callback and see how the api differs from signals
    func postGist() -> ProducerOfGistSignals

    var recentFiles: RecentFilesArray { get set }

    func createStringOfOptions() -> String
}


protocol RecentFilesP: MAIN_Interactor_Input {
    var recentFiles: [String] { get set }
}


/// Module MAIN
/// Messages from `Interactor` to `Presenter`


protocol InteractorOutput_MAIN {
    func giveMeTheURL() -> NSURL
}