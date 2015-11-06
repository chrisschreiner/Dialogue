import Cocoa


protocol PREF_ViewInterface {
	func gistServicePopupButton() -> NSPopUpButton

	func shortenServicePopupButton() -> NSPopUpButton

	func setSecretGistsValue(value: Bool) // A

	func setGistServiceValue(index: Int)

	func setShortenServiceValue(index: Int)
}


protocol ModuleInterface_PREFERENCES {
	func toggleSecretGists(value: Bool) // A

	func selectGistService(serviceIndex: Int)

	func selectShortenService(serviceIndex: Int)
}


protocol PREF_InteractorInput {
	func setSecretGists(isSecret: Bool) // A

	func setGistServiceIndex(index: Int)

	func setShortenServiceIndex(index: Int)
}


protocol PREF_InteractorOutput {
	func setActiveGistService(index: Int)

	func setActiveShortenService(index: Int)

	func setUseSecretGists(isSecret: Bool) // A

	func populateGistsServicePopupMenu(menu: NSMenu)

	func populateShortenServicePopupMenu(menu: NSMenu)
}


class PREF_API_P {
	// Use this class when calling external API, like web-services
	// Doesn't seem to be much to do here for Preferences
}