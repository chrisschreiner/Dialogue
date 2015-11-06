import Cocoa


class PREF_View: NSWindowController, NSWindowDelegate {
	var eventHandler: ModuleInterface_PREFERENCES?
	var viewLifeCycle: ViewLifeCycle?

	override var windowNibName: String? {
		return "PREF_Window"
	}

	@IBOutlet weak var secretGists: NSButton!
	@IBOutlet weak var gistService: NSPopUpButton!
	@IBOutlet weak var shortenService: NSPopUpButton!

	@IBAction func toggleSecretGists(sender: NSButton) {
		eventHandler?.toggleSecretGists(sender.integerValue == 1)
	}

	@IBAction func gistServiceSelected(sender: NSPopUpButton) {
		eventHandler?.selectGistService(sender.indexOfSelectedItem)
	}

	@IBAction func shortenServiceSelected(sender: NSPopUpButton) {
		eventHandler?.selectShortenService(sender.indexOfSelectedItem)
	}

	override func windowDidLoad() {
		//TODO:find a proper place for this (awakeFromNib/prepare/here)
		viewLifeCycle?.windowDidLoad()
	}
}


extension PREF_View: PREF_ViewInterface {
	func setSecretGistsValue(value: Bool) {
		secretGists.integerValue = value ? 1 : 0
	}

	func setGistServiceValue(index: Int) {
		gistService.selectItemAtIndex(index)
	}

	func setShortenServiceValue(index: Int) {
		shortenService.selectItemAtIndex(index)
	}

	func gistServicePopupButton() -> NSPopUpButton {
		return gistService
	}

	func shortenServicePopupButton() -> NSPopUpButton {
		return shortenService
	}
}
