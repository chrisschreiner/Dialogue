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


struct First {


    class Wireframe {
        var interactor: Interactor?
        var presenter: Presenter?
        var view: FirstViewI?
        var stubWindow: WindowController_FIRST?
        var preferencesWireframe: Preferences.Wireframe?

        init() {
            interactor = Interactor()
            presenter = Presenter(wireframe: self)
            stubWindow = WindowController_FIRST()

            interactor?.localDatamanager = LocalDatamanager()
            interactor?.apiDatamanager = APIDatamanager()

            presenter?.interactor = interactor
            presenter?.view = stubWindow

            interactor?.output = presenter

            stubWindow?.eventHandler = presenter
        }

        func show() {
            /// Who should show - wireframe or presenter?
            stubWindow?.showWindow(nil)
        }

        func presentPreferences() {
            preferencesWireframe = Preferences.Wireframe()
            preferencesWireframe?.show()
        }
    }


    class Presenter: FirstModuleInterface, InteractorOutput_FIRST {
        var view: FirstViewI?
        var interactor: InteractorInput_FIRST?
        let wireframe: Wireframe

        //TODO: remove this
        var toggle: Bool = false

        init(wireframe: First.Wireframe) {
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

