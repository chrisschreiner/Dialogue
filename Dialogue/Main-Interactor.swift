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
	func postGist() -> SignalProducer<NSURL,GistRequestReason> {

		//setup all data here
		let contentsToGist = pastebufferGateway!.getContents()
		let config = self.config!

		print(config)
		
		return apiDatamanager!.postGist(contentsToGist, config:config) // <- feed me
	}

	func countRecentFiles() -> Int {
		return self.config!.countRecentFiles()
	}

	func recentFileEntry(index: Int) -> Sample {
		if let recentFile = self.config!.getRecentFile(index) {
			let a = recentFile.filename
			let b = recentFile.url.characters.count

			let s = Sample(a: a, b: b)
			return s
		}
		preconditionFailure()
	}

	func clearRecentFiles() {
		self.config!.clearRecentFiles()
	}

	func createStringOfOptions() -> String {
		let gist = GistService(rawValue: config!.activeGistServiceIndex ?? 0)!
		let shorten = ShortenService(rawValue: config!.activeShortenServiceIndex ?? 0)!
		let secret = config!.secretGists ?? true
		let recentCount = config!.countRecentFiles()

		return "\(gist)\n\(shorten)\n\(secret ? "Secret" : "public")\nRecent count \(recentCount)"
	}

}

