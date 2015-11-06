import Cocoa


class PREF_Presenter {
	var view: PREF_ViewInterface?
	var interactor: PREF_InteractorInput?
}


extension PREF_Presenter: ModuleInterface_PREFERENCES {
	func toggleSecretGists(value: Bool) {
		interactor?.setSecretGists(value)
	}

	func selectGistService(serviceIndex: Int) {
		interactor?.setGistServiceIndex(serviceIndex)
	}

	func selectShortenService(serviceIndex: Int) {
		interactor?.setShortenServiceIndex(serviceIndex)
	}
}


extension PREF_Presenter: ViewLifeCycle {
	func windowDidLoad() {
//		interactor?.setInitialValues()
//		precondition(localDatamanager != nil)
//		precondition(output != nil)

		let config = (interactor as! PREF_Interactor).config

		populateGistsServicePopupMenu(GistService.popupMenuList())
		populateShortenServicePopupMenu(ShortenService.popupMenuList())
		setActiveGistService(config?.activeGistServiceIndex ?? 0)
		setActiveShortenService(config?.activeShortenServiceIndex ?? 0)
		setUseSecretGists(config?.secretGists ?? true)
	}
}


extension PREF_Presenter: PREF_InteractorOutput {
	func setActiveGistService(index: Int) {
		view?.setGistServiceValue(index)
	}

	func setUseSecretGists(isSecret: Bool) {
		view?.setSecretGistsValue(isSecret)
	}

	func setActiveShortenService(index: Int) {
		view?.setShortenServiceValue(index)
	}

	func populateGistsServicePopupMenu(menu: NSMenu) {
		view?.gistServicePopupButton().menu = menu
	}

	func populateShortenServicePopupMenu(menu: NSMenu) {
		view?.shortenServicePopupButton().menu = menu
	}
}

