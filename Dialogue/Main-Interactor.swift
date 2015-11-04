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
	/*

	TODO: Decide if getPasteboardItems should be a free function or not

	Pasteboard is a Service which must be abstracted behind an interface.
	To enable quick testing you need to mock the pasteboard, that is;
	create a class that implements the pasteboard interface, so the mocked
	class can appear as the Service, and supply it with data before
	passing the class to the Interactor.

	1. Communicate with the Pasteboard-Service via an interface
	2. It will appear as red (as an interactor) in the diagram, the consequences of this
	is that the Pasteboard-Service becomes an interactor on its own.

	Interface:  get_data -> DataFormat


	*/

	func postGist() -> SignalProducer<NSURL,ProcessError> {

		//setup all data here
		let contentsToGist = pastebufferGateway!.getContents()
		let config = self.config!
		
		
		return apiDatamanager!.postGist(contentsToGist, config:config) // <- feed me
	}

//	typealias RIP = Result<Int, ProcessError>
//	typealias SP = SignalProducer<RIP, NoError>

//	@available(*, deprecated=1)
//	func postGist(config: Config_P) {
//		if let data = self.pastebufferGateway?.getContents() {
//			self.apiDatamanager?.sendGist(data)
//
//			let _ = self.output?.giveMeTheURL() //resultURL =
//		}
//	}
//


//    @available(*, deprecated=1)
//	func submitToGistService(config: Config_P) {
//		let condition = {
//			(item: PBItem) -> Bool in switch item {
//			case .Text(_ ):
//				return true
//			default:
//				return false
//			}
//		}
//
//		guard let first = getPasteboardItems().filter(condition).first else {
//			return
//		}
//
//		let data = GistData(item: first)
//		submitToGistService(config, content: data)
//	}

//	func submitToGistService(config: Config_P, content: GistData) -> SignalProducer<NSURL, ProcessError> {
//		return SignalProducer {
//			observer, disposable in let gistService = config.activeGistService
//			_ = config.activeShortenService
//			let userCredentials = UserCredential()
//
//			if let strategy = GistServiceFactory.makeStrategy(gistService, userCredentials) {
//				switch strategy.process(content) {
//				case .Failure(_ ):
//					observer.sendFailed(.NotImplementedYet)
//
//				case .Success(let url):
//					observer.sendNext(url)
//					observer.sendCompleted()
//				}
//			}
//			// ?> apiDatamanager?.processIt(dataMan)
//		}
//	}


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

		//let s = (localDatamanager!.secretGists ? "Secret" : "Public") + "\n" + "\(localDatamanager!.activeGistService)"

		return "\(gist)\n\(shorten)\n\(secret ? "Secret" : "public")\nRecent count \(recentCount)"
	}

}

