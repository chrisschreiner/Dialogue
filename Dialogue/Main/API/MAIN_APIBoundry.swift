import Foundation
import ReactiveCocoa
import Result

typealias GistID = String

typealias SuccessResponse = (url:NSURL, gid:GistID)

typealias ResultType = Result<SuccessResponse, GistRequestReason> -> Void

typealias GistSignalProducer = SignalProducer<SuccessResponse, GistRequestReason>


enum GistRequestReason: ErrorType {
    case JustBecause
    case BadMood
    case ErrorResponse(String)
    case OtherErrorResponse(Int)
    case NoContent
}


struct UserCredential {
}

protocol Gist_API_P {
    func postGist(content: GistData, config: AppModel_P) -> GistSignalProducer
}


protocol Pastebuffer_API_P {
    func getContents() -> GistData
}


protocol MAIN_InteractorInput {
    func postGist() -> GistSignalProducer

    func createStringOfOptions() -> String

    var recentFiles: RecentFilesArray { get set }
}


protocol MAIN_InteractorOutput {
    func giveMeTheURL() -> NSURL
}


protocol MAIN_PresenterInput {
    func openPreferences()

    func submitPasteboardAsGist()

    func clearRecentFiles()
}


protocol ViewLifeCycle {
    func windowDidLoad()
}


protocol MAIN_ViewInput {
    func setResultText(s: String)

    func setDatasourceForRecentFiles(datasource: NSTableViewDataSource)

    func setDelegateForRecentFiles(delegate: NSTableViewDelegate)

    func updateConstantOutput(s: String)
}
