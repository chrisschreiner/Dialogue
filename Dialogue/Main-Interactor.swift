import Cocoa
import Result
import SwiftyJSON
import ReactiveCocoa


class Interactor_MAIN {
	var apiDatamanager: API_MAIN_P?
	//TODO: Namechange GIST_API (|:?)
	var output: InteractorOutput_MAIN?
	//attached to the presenter
	var pastebufferGateway: PB_Gateway?
	//pastebuffer as a service, what about files?
	var config: Config_P?
}


extension Interactor_MAIN: InteractorInput_MAIN {
	func postGist() -> SignalProducer<NSURL,ProcessError> {

		//setup all data here
		let contentsToGist = pastebufferGateway!.getContents()
		let config = self.config!
		
		
		return apiDatamanager!.postGist(contentsToGist, config:config) // <- feed me
	}

	func countRecentFiles(config: Config_P) -> Int {
		return config.countRecentFiles()
	}

	func recentFileEntry(config: Config_P, index: Int) -> Sample {
		if let recentFile = config.getRecentFile(index) {
			let a = recentFile.filename
			let b = recentFile.url.characters.count

			let s = Sample(a: a, b: b)
			return s
		}
		preconditionFailure()
	}

	func clearRecentFiles(config: Config_P) {
		config.clearRecentFiles()
	}

	func createStringOfOptions(config: Config_P) -> String {
		let gist = GistService(rawValue: config.activeGistServiceIndex ?? 0)!
		let shorten = ShortenService(rawValue: config.activeShortenServiceIndex ?? 0)!
		let secret = config.secretGists ?? true
		let recentCount = config.countRecentFiles()

		return "\(gist)\n\(shorten)\n\(secret ? "Secret" : "public")\nRecent count \(recentCount)"
	}

}

