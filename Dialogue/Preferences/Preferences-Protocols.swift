import Cocoa


/// Module PREFERENCES
/// Messages from `Presenter` to `View`
/// (aka View.eventHandler)


protocol ViewInterface_PREFERENCES {
    func gistServicePopupButton() -> NSPopUpButton

    func shortenServicePopupButton() -> NSPopUpButton

    func setSecretGistsValue(value: Bool) // A

    func setGistServiceValue(index: Int)

    func setShortenServiceValue(index: Int)
}


/// Module PREFERENCES
/// Messages from `View` to `Presenter`


protocol ModuleInterface_PREFERENCES {
    func toggleSecretGists(value: Bool) // A

    func selectGistService(serviceIndex: Int)

    func selectShortenService(serviceIndex: Int)
}


/// Module PREFERENCES
/// Messages from `Presenter` to `Interactor`


protocol InteractorInput_PREFERENCES {
    func setInitialValues()

    func setSecretGists(isSecret: Bool) // A

    func setGistServiceIndex(index: Int)

    func setShortenServiceIndex(index: Int)
}


/// Module PREFERENCES
/// Messages from `Interactor` to `Presenter`


protocol InteractorOutput_PREFERENCES {
    func setActiveGistService(index: Int)

    func setActiveShortenService(index: Int)

    func setUseSecretGists(isSecret: Bool) // A

    func populateGistsServicePopupMenu(menu: NSMenu)

    func populateShortenServicePopupMenu(menu: NSMenu)
}