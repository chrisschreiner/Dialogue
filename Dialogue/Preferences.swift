import Cocoa


class WindowController_PREFERENCES: NSWindowController, NSWindowDelegate, PreferencesViewI {
    var eventHandler: PreferencesModuleInterface?

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
        eventHandler?.viewIsReady()
    }

    func servicePopupButton() -> AppKit.NSPopUpButton {
        return gistService
    }

    func secretGistsCheckbox() -> NSButton {
        return secretGists
    }

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


struct Preferences {


    class Wireframe {
        var presenter: Presenter?
        var view: PreferencesViewI?
        var window: WindowController_PREFERENCES?
        var interactor: Interactor?
        //weak var globalDatamanager: GlobalDatamanager?

        init(dataManager: LocalDatamanager) {
            presenter = Presenter(wireframe: self)
            window = WindowController_PREFERENCES()
            interactor = Interactor()

            presenter?.view = window
            presenter?.interactor = interactor

            interactor?.apiDatamanager = APIDataManager()
            interactor?.localDatamanager = dataManager
            interactor?.output = presenter

            window?.eventHandler = presenter
        }

        func show() {
            //TODO:setup window with default values
            //TODO:find a place to do this

            window?.showWindow(nil)
        }
    }


    class Presenter: PreferencesModuleInterface, InteractorOutput_PREFERENCES {
        var view: PreferencesViewI?
        var interactor: InteractorInput_PREFERENCES?
        let wireframe: Wireframe

        init(wireframe: Wireframe) {
            self.wireframe = wireframe
        }

        // -- PreferencesModuleInterface : View ---------------------------------

        func toggleSecretGists(value: Bool) {
            interactor?.setSecretGists(value)
        }

        func selectGistService(serviceIndex: Int) {
            interactor?.setGistServiceIndex(serviceIndex)
        }

        func selectShortenService(serviceIndex: Int) {
            interactor?.setShortenServiceIndex(serviceIndex)
        }

        func viewIsReady() {
            interactor?.setInitialValues()
        }

        // -- InteractorOutput_PREFERENCES --------------------------------------

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


    //== INTERACTOR ===================================================


    class Interactor: InteractorInput_PREFERENCES {
        var localDatamanager: LocalDatamanager?
        var apiDatamanager: APIDataManager?
        var output: InteractorOutput_PREFERENCES?

        func setInitialValues() {
            precondition(localDatamanager != nil)
            precondition(output != nil)

            output?.populateGistsServicePopupMenu(GistService.popupMenuList())
            output?.populateShortenServicePopupMenu(ShortenService.popupMenuList())
            output?.setActiveGistService(localDatamanager?.activeGistService ?? 0)
            output?.setActiveShortenService(localDatamanager?.activeShortenService ?? 0)
            output?.setUseSecretGists(localDatamanager?.secretGists ?? true)
        }

        func setSecretGists(isSecret: Bool) {
            localDatamanager?.secretGists = isSecret
        }

        func setGistServiceIndex(index: Int) {
            localDatamanager?.activeGistService = index
        }

        func setShortenServiceIndex(index: Int) {
            localDatamanager?.activeShortenService = index
        }
    }





    class APIDataManager {
        //for calling outside the app, like web-services and other external API
    }


}