import Cocoa


class WindowController_FIRST: NSWindowController, NSWindowDelegate, FirstViewI {
    var eventHandler: FirstModuleInterface?

    override var windowNibName: String? {
        return "FirstWindow"
    }

    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var toggle: NSButton!
    @IBOutlet weak var action: NSButton!
    @IBOutlet weak var result: NSTextField!

    @IBAction func actionClicked(sender: NSButton) {
        eventHandler?.submitPasteboardAsGist()
    }

    @IBAction func preferencesClicked(sender: NSButton) {
        eventHandler?.openPreferences()
    }

    @IBAction func toggleClicked(sender: NSButton) {
        //eventHandler?.toggleClicked(sender.integerValue)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self
    }

    func windowWillClose(notification: NSNotification) {
    }

    func setResultText(s: String) {
        result.stringValue = s
    }
}


struct Main {


    class Wireframe {
        var interactor: Interactor?
        var presenter: Presenter?
        var view: FirstViewI?
        var stubWindow: WindowController_FIRST?
        var preferencesWireframe: Preferences.Wireframe?
        //weak var globalDatamanager: GlobalDatamanager?

        init(dataManager: LocalDatamanager) {
            interactor = Interactor()
            presenter = Presenter(wireframe: self)
            stubWindow = WindowController_FIRST()

            stubWindow?.eventHandler = presenter

            interactor?.localDatamanager = dataManager
            interactor?.apiDatamanager = APIDatamanager()
            interactor?.output = presenter

            presenter?.interactor = interactor
            presenter?.view = stubWindow
        }

        func show() {
            /// Who should show - wireframe or presenter?
            stubWindow?.showWindow(nil)
        }

        func presentPreferences() {
            if let dataMan = interactor?.localDatamanager {
                preferencesWireframe = Preferences.Wireframe(dataManager: dataMan)
                preferencesWireframe?.show()
            } else {
                preconditionFailure()
            }
        }
    }


    class Presenter: FirstModuleInterface, InteractorOutput_FIRST {
        var view: FirstViewI?
        var interactor: InteractorInput_FIRST?
        let wireframe: Wireframe

        //TODO: remove this
        var toggle: Bool = false

        init(wireframe: Main.Wireframe) {
            self.wireframe = wireframe
        }

        func toggleClicked(value: Int) {
            toggle = value == 1
        }

        func actionClicked() {
            //            if toggle {
            //                interactor?.performSomethingA()
            //            } else {
            //                interactor?.performSomethingB()
            //            }
        }

        func giveBackResponse(s: String) {
            view?.setResultText(s)
        }

        // -- FirstModuleInterface -----------------------------------

        func submitPasteboardAsGist() {
            // where should this go?
            interactor?.submitToGistService()
        }

        func openPreferences() {
            wireframe.presentPreferences()
        }
    }


}

