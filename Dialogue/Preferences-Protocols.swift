import Cocoa


protocol PreferencesViewI {
    func gistServicePopupButton() -> NSPopUpButton

    func shortenServicePopupButton() -> NSPopUpButton

    func setSecretGistsValue(value: Bool) // A

    func setGistServiceValue(index: Int)

    func setShortenServiceValue(index: Int)
}


protocol PreferencesModuleInterface {
    func toggleSecretGists(value: Bool) // A

    func selectGistService(serviceIndex: Int)

    func selectShortenService(serviceIndex: Int)

    func viewIsReady()
}


protocol InteractorInput_PREFERENCES {
    func setInitialValues()

    func setSecretGists(isSecret: Bool) // A

    func setGistServiceIndex(index: Int)

    func setShortenServiceIndex(index: Int)
}


protocol InteractorOutput_PREFERENCES {
    func setActiveGistService(index: Int)

    func setActiveShortenService(index: Int)

    func setUseSecretGists(isSecret: Bool) // A

    func populateGistsServicePopupMenu(menu: NSMenu)

    func populateShortenServicePopupMenu(menu: NSMenu)
}