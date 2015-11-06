import Cocoa


struct ConfigurationRecord {
	let gistService: GistService
	let shortenService: ShortenService
	let secretGists: Bool

    init(fromDataManager data: AppModel_P) {
        self.gistService = GistService(rawValue: data.activeGistServiceIndex)!
        self.shortenService = ShortenService(rawValue: data.activeShortenServiceIndex)!
		self.secretGists = data.secretGists
	}
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
