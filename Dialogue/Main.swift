import Cocoa
import ReactiveCocoa


class View_MAIN: NSWindowController, NSWindowDelegate {
    var eventHandler: MAIN_Presenter_Input?
    var viewLifeCycle: ViewLifeCycle?

    override var windowNibName: String? {
        return "MainWindow"
    }

    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var toggle: NSButton!
    @IBOutlet weak var submitGistButton: NSButton!
    @IBOutlet weak var showPasteboardButton: NSButton!
    @IBOutlet weak var shortenLinkButton: NSButton!
    @IBOutlet weak var clearRecentFiles: NSButton!
    @IBOutlet weak var result: NSTextField!
    @IBOutlet weak var table: NSTableView!
    @IBOutlet weak var constantOutput: NSTextField!

    @IBAction func clearRecentFiles(sender: NSButton) {
        eventHandler?.clearRecentFiles()
        table.reloadData()
    }

    @IBAction func showPasteboardButton(sender: NSButton) {
    }

    @IBAction func shortenLinkButton(sender: NSButton) {
    }

    @IBAction func actionClicked(sender: NSButton) {
        eventHandler?.submitPasteboardAsGist()
        table.reloadData()
    }

    @IBAction func preferencesClicked(sender: NSButton) {
        eventHandler?.openPreferences()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self
        viewLifeCycle?.viewIsReady()
    }

    func windowWillClose(notification: NSNotification) {
    }
}


extension View_MAIN: ViewInterface_MAIN {
    func setResultText(s: String) {
        result.stringValue = s
    }

    func updateConstantOutput(s: String) {
        constantOutput.stringValue = s
    }

    func setDatasourceForRecentFiles(datasource: NSTableViewDataSource) {
        table.setDataSource(datasource)
    }

    func setDelegateForRecentFiles(delegate: NSTableViewDelegate) {
        table.setDelegate(delegate)
    }
}


class Wireframe_MAIN {
    var interactor: Interactor_MAIN?
    var presenter: Presenter_MAIN?
    var view: View_MAIN?
    var preferencesWireframe: Wireframe_PREFERENCES?

    init(config: Config_P) {
        interactor = Interactor_MAIN()
        presenter = Presenter_MAIN()
        presenter?.wireframe = self
        view = View_MAIN()
        view?.viewLifeCycle = presenter //TODO:Think through; could this be handled by the wireframe?
        view?.eventHandler = presenter

        interactor?.apiDatamanager = API_MAIN()
        interactor?.output = presenter //no functions yet
		interactor?.config = config

        presenter?.interactor = interactor
        presenter?.view = view
    }

    func presentPreferences() {
        preferencesWireframe = Wireframe_PREFERENCES(config: self.interactor!.config!)
        preferencesWireframe?.show()
    }
}


class Presenter_MAIN: NSObject {
    var view: ViewInterface_MAIN?
    var interactor: MAIN_Interactor_Input?
    var wireframe: Wireframe_MAIN?

    func updateOptions(sender: NSNotification) {
        updateConstantOptionsField()
    }

    func updateConstantOptionsField() {
        if let options = interactor?.createStringOfOptions() {
            view?.updateConstantOutput(options)
        }
    }
}


extension Presenter_MAIN: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return interactor!.recentFiles.count // countRecentFiles() ?? 0
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let column1RecentFiles = "column1"

        let t = NSTextField()
        t.bordered = false
        t.drawsBackground = false

        let sample = Sample(a: "test", b: row)

        switch tableColumn!.identifier {
        case column1RecentFiles:
            t.stringValue = sample.a
        default:
            t.stringValue = "\(sample.b)"
        }

        return t
    }
}


extension Presenter_MAIN: MAIN_Presenter_Input {
    func openPreferences() {
        wireframe?.presentPreferences()
    }

    func submitPasteboardAsGist() {
        preconditionFailure()
    }


    func clearRecentFiles() {
        interactor!.recentFiles.removeAll()
    }
}


extension Presenter_MAIN: InteractorOutput_MAIN {
	func giveMeTheURL() -> NSURL {
		return NSURL(string:"whatever")! //TODO:Check
	}
}


extension Presenter_MAIN: ViewLifeCycle {
    func viewIsReady() {
        view?.setDatasourceForRecentFiles(self)
        view?.setDelegateForRecentFiles(self)

        //TODO:Tear down observer somewhere appropriate
        let n = NSNotificationCenter.defaultCenter()
        n.addObserver(self, selector: Selector("updateOptions:"), name: NotificationNameOptionsUpdated, object: nil)
        updateConstantOptionsField()
    }
}
