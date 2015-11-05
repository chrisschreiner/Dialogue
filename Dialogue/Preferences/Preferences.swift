import Cocoa


class View_PREFERENCES: NSWindowController, NSWindowDelegate {
    var eventHandler: ModuleInterface_PREFERENCES?
    var viewLifeCycle: ViewLifeCycle?

    override var windowNibName: String? {
        return "PreferencesWindow"
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
        viewLifeCycle?.viewIsReady()
    }
}


extension View_PREFERENCES: ViewInterface_PREFERENCES {
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


class Wireframe_PREFERENCES {
    var presenter: Presenter_PREFERENCES?
    var view: ViewInterface_PREFERENCES?
    var window: View_PREFERENCES?
    var interactor: Interactor_PREFERENCES?

    init(config: Config_P) {
        presenter = Presenter_PREFERENCES(wireframe: self)
        window = View_PREFERENCES()
        interactor = Interactor_PREFERENCES()

        presenter?.view = window
        presenter?.interactor = interactor

        interactor?.apiDatamanager = APIDataManager_PREFERENCES()
        interactor?.localDatamanager = config
        interactor?.output = presenter

        window?.eventHandler = presenter
        window?.viewLifeCycle = presenter
    }

    func show() {
        //TODO:setup window with default values
        //TODO:find a place to do this

        window?.showWindow(nil)
    }
}


class Presenter_PREFERENCES {
    var view: ViewInterface_PREFERENCES?
    var interactor: InteractorInput_PREFERENCES?
    let wireframe: Wireframe_PREFERENCES

    init(wireframe: Wireframe_PREFERENCES) {
        self.wireframe = wireframe
    }
}


extension Presenter_PREFERENCES: ModuleInterface_PREFERENCES {
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


extension Presenter_PREFERENCES: ViewLifeCycle {
    func viewIsReady() {
        interactor?.setInitialValues()
    }
}


extension Presenter_PREFERENCES: InteractorOutput_PREFERENCES {
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




