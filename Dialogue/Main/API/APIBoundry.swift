import Foundation
import ReactiveCocoa
import Result

typealias GistID = String
typealias SuccessResponse = (url:NSURL, gid:GistID)
typealias ResultType = Result<SuccessResponse, GistRequestReason> -> Void
typealias ProducerOfGistSignals = SignalProducer<SuccessResponse, GistRequestReason>


enum GistRequestReason: ErrorType {
    case JustBecause
    case BadMood
    case ErrorResponse(String)
    case OtherErrorResponse(Int)
    case NoContent
}


struct UserCredential {
}


class RecentFilesArray {
    var _data: [String]
    var count: Int {
        return _data.count
    }
    var last: String? {
        return _data.last
    }
    func append(s: String) {
        _data.append(s)
    }

    func removeAll() {
        _data.removeAll()
    }

    init() {
        _data = []
    }
}


struct GistData {
    var data: String
    init(item: PBItem) {
        switch item {
        case .Text(let text):
            self.data = text
        default:
            preconditionFailure("undefined")
        }
    }
    init(data: String) {
        self.data = data
    }
}


protocol API_MAIN_P {
    func postGist(content: GistData, config: Config_P) -> ProducerOfGistSignals
}


protocol PB_Gateway {
    func getContents() -> GistData
}


protocol MAIN_Interactor_Input {
	//async, try also with a callback and see how the api differs from signals
	func postGist() -> ProducerOfGistSignals
	
	var recentFiles: RecentFilesArray { get set }
	
	func createStringOfOptions() -> String
}


protocol RecentFilesP: MAIN_Interactor_Input {
	var recentFiles: [String] { get set }
}

protocol InteractorOutput_MAIN {
	func giveMeTheURL() -> NSURL
}

protocol MAIN_Presenter_Input {
	func openPreferences()
	
	func submitPasteboardAsGist()
	
	func clearRecentFiles()
}


protocol ViewLifeCycle {
	func viewIsReady()
}



protocol ViewInterface_MAIN {
	func setResultText(s: String)
	
	func setDatasourceForRecentFiles(datasource: NSTableViewDataSource)
	
	func setDelegateForRecentFiles(delegate: NSTableViewDelegate)
	
	func updateConstantOutput(s: String)
}