//
//  Interactor
//  Dialogue/Codealog|ue
//

import Cocoa

typealias UserID = String


struct UserEntity {
    var name: String
    var age: Int
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


//-- via interface -------------------------------------------------------------


protocol FirstInput {
    func getUserIdentity(id: UserID) -> UserEntity?

    func performSomethingA()

    func performSomethingB()
}


class FirstInteractor {
    var localDatamanager: LocalDatamanager?
    var apiDatamanager: APIDatamanager?
    var output: FirstOutput?
}


extension FirstInteractor: FirstInput {
    func getUserIdentity(id: UserID) -> UserEntity? {
        return localDatamanager?.fetchUser(id)
    }

    func performSomethingA() {
        print(__FUNCTION__)
        output?.giveBackResponse("Hello")
    }

    func performSomethingB() {
        print(__FUNCTION__)
        output?.giveBackResponse("World")
    }
}


//== boundary ==================================================================


class FirstWireframe {
    var interactor: FirstInteractor?
    var presenter: FirstPresenter?
    var view: FirstViewI?
    var apiDatamanager: APIDatamanager?
    var localDatamanager: LocalDatamanager?
    var stubWindow: FirstWC?
    var preferencesWireframe: PreferencesWireframe?

    init() {
        interactor = FirstInteractor()
        presenter = FirstPresenter()
        stubWindow = FirstWC()

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

    func presentSettings() {
        preferencesWireframe = PreferencesWireframe()
        preferencesWireframe?.show()
    }
}


class PreferencesWireframe {
    var presenter: PreferencesPresenter?
    var view: PreferencesViewI?
    var window: PreferencesWC?

    init() {
        presenter = PreferencesPresenter()
        window = PreferencesWC()

        presenter?.view = window
    }

    func show() {
        window?.showWindow(nil)
    }
}


class PreferencesPresenter {
    var view: PreferencesViewI?

    var toggle: Bool = false

    func specialClicked(value: Bool) {
        toggle = value
    }
}


protocol FirstOutput {
    func giveBackResponse(s: String)
}


class FirstPresenter: FirstOutput {
    var view: FirstViewI?
    var interactor: FirstInput?
    var wireframe: FirstWireframe?

    var toggle: Bool = false

    init() {
        //do default init of view?
    }

    func toggleClicked(value: Int) {
        toggle = value == 1
    }

    func preferencesClicked() {
        wireframe?.presentSettings()
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


//== boundary ==================================================================


protocol PreferencesViewI {
}


class PreferencesWC: NSWindowController, NSWindowDelegate, PreferencesViewI {
    @IBOutlet weak var special: NSButton!

    var presenter: PreferencesPresenter?

    override var windowNibName: String? {
        return "PreferencesWindow"
    }

    @IBAction func specialClicked(sender: NSButton) {
        presenter?.specialClicked(sender.integerValue == 1)
    }
}


//== boundary ==================================================================


protocol FirstViewI {
    func setResultText(s: String)
}


//-- via interface -------------------------------------------------------------


class FirstWC: NSWindowController, NSWindowDelegate, FirstViewI {
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var toggle: NSButton!
    @IBOutlet weak var action: NSButton!
    @IBOutlet weak var result: NSTextField!

    var presenter: FirstPresenter?

    @IBAction func actionClicked(sender: NSButton) {
        presenter?.actionClicked()
    }

    @IBAction func preferencesClicked(sender: NSButton) {
        presenter?.preferencesClicked()
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