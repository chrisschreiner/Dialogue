import Cocoa


class View_MAIN: NSWindowController, NSWindowDelegate {
    var eventHandler: ModuleInterface_MAIN?
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
        presenter = Presenter_MAIN(config: config)
        presenter?.wireframe = self
        view = View_MAIN()
        view?.viewLifeCycle = presenter //TODO:Think through; could this be handled by the wireframe?
        view?.eventHandler = presenter

        interactor?.apiDatamanager = APIDatamanager_MAIN()
        interactor?.output = presenter //no functions yet

        presenter?.interactor = interactor
        presenter?.view = view
    }

    func show() {
        /// Who should show - wireframe or presenter?
        view?.showWindow(nil)
    }

    func presentPreferences(dataMan: Config_P) {
        /// Is this nescessary? Find alternative connection-points for the "global" localDatamanager
        /// Local in this context means "not API" or external.
        preferencesWireframe = Wireframe_PREFERENCES(config: dataMan)
        preferencesWireframe?.show()
    }
}


class Presenter_MAIN: NSObject {
    var view: ViewInterface_MAIN?
    var interactor: InteractorInput_MAIN?
    var wireframe: Wireframe_MAIN?
    var config: Config_P

    init(config: Config_P) {
        self.config = config
    }

    func updateOptions(sender: NSNotification) {
        updateConstantOptionsField()
    }

    func updateConstantOptionsField() {
        if let options = interactor?.createStringOfOptions(config) {
            view?.updateConstantOutput(options)
        }
    }
}


extension Presenter_MAIN: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return interactor?.countRecentFiles(config) ?? 0
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let column1RecentFiles = "column1"
        //let column2RecentFiles = "column2"

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


extension Presenter_MAIN: ModuleInterface_MAIN {
    func openPreferences() {
        wireframe?.presentPreferences(config)
    }

    func submitPasteboardAsGist() {
        /*

        open questions related to this pattern:

        -- 1. bring all configuration-details to the interactor

        -> 2. let the interactor bother with configuration

        */

        let condition = {
            (item: PBItem) -> Bool in switch item {
            case .Text(let text):
                return true
            default:
                return false
            }
        }

        if let dataContents = getPasteboardItems().filter(condition).first {
            interactor?.submitToGistService(config)
        }
    }

    func clearRecentFiles() {
        interactor?.clearRecentFiles(config)
    }
}


extension Presenter_MAIN: InteractorOutput_MAIN {
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
