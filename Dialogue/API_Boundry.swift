/*

Boundry

API_MAIN_P is the only way to communicate with API_Gist

*/

import Foundation
import ReactiveCocoa

enum GistRequestReason: ErrorType {
    case JustBecause
    case BadMood
    case ErrorResponse(String)
    case OtherErrorResponse(Int)
    case NoContent
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

	func postGist(content:GistData, config:Config_P) -> SignalProducer<NSURL,GistRequestReason>

}
