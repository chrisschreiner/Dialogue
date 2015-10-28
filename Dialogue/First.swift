import Cocoa


class Wireframe_FIRST {
    var interactor: Interactor_FIRST?
    var presenter: Presenter_FIRST?
    var view: FirstViewI?
    var apiDatamanager: APIDatamanager?
    var localDatamanager: LocalDatamanager?
    var stubWindow: WindowController_FIRST?
    var preferencesWireframe: Preferences.Wireframe?

    init() {
        interactor = Interactor_FIRST()
        presenter = Presenter_FIRST()
        stubWindow = WindowController_FIRST()

        interactor?.localDatamanager = LocalDatamanager()
        interactor?.apiDatamanager = APIDatamanager()

        presenter?.interactor = interactor
        presenter?.view = stubWindow
        presenter?.wireframe = self

        interactor?.output = presenter

        stubWindow?.presenter = presenter
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


class WindowController_FIRST: NSWindowController, NSWindowDelegate, FirstViewI {
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var toggle: NSButton!
    @IBOutlet weak var action: NSButton!
    @IBOutlet weak var result: NSTextField!

    var presenter: Presenter_FIRST?

    @IBAction func actionClicked(sender: NSButton) {
        presenter?.actionClicked()
    }

    @IBAction func preferencesClicked(sender: NSButton) {
        presenter?.openPreferences()
    }

    @IBAction func toggleClicked(sender: NSButton) {
        presenter?.toggleClicked(sender.integerValue)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override var windowNibName: String? {
        return "FirstWindow"
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


class Presenter_FIRST: FirstOutput {
    var view: FirstViewI?
    var interactor: FirstInput?
    var wireframe: Wireframe_FIRST?

    var toggle: Bool = false

    func toggleClicked(value: Int) {
        toggle = value == 1
    }

    func openPreferences() {
        wireframe?.presentPreferences()
    }

    func actionClicked() {
        if toggle {
            interactor?.performSomethingA()
        } else {
            interactor?.performSomethingB()
        }
    }

    func giveBackResponse(s: String) {
        view?.setResultText(s)
    }
}


//== INTERACTOR ===================================================


class Interactor_FIRST: FirstInput {
    var localDatamanager: LocalDatamanager?
    var apiDatamanager: APIDatamanager?
    var output: FirstOutput?

    func getUserIdentity(id: UserID) -> UserEntity? {
        return localDatamanager?.fetchUser(id)
    }

    func performSomethingA() {
        output?.giveBackResponse("Hello")
    }

    func performSomethingB() {
        output?.giveBackResponse("World")
    }
}


class LocalDatamanager {
	func fetchUser(id: UserID) -> UserEntity? {
		switch id {
		case "Peter":
			return UserEntity(name: "Peter Pan", age: 12)
		default:
			return nil
		}
	}
}


class APIDatamanager {
}
