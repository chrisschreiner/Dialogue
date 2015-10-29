import Cocoa


class WindowController_FIRST: NSWindowController, NSWindowDelegate, FirstViewI, NSTableViewDelegate {
    var eventHandler: FirstModuleInterface?

    override var windowNibName: String? {
        return "FirstWindow"
    }

    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var toggle: NSButton!
    @IBOutlet weak var action: NSButton!
    @IBOutlet weak var action1: NSButton!
    @IBOutlet weak var action2: NSButton!
    @IBOutlet weak var clearRecentFiles: NSButton!
    @IBOutlet weak var result: NSTextField!
    @IBOutlet weak var table: NSTableView!
    @IBOutlet weak var constantOutput: NSTextField!
    @IBAction func clearRecentFiles(sender: NSButton) {
        eventHandler?.clearRecentFiles()
        table.reloadData()
    }

    @IBAction func action1(sender: NSButton) {
    }

    @IBAction func action2(sender: NSButton) {
    }

    @IBAction func actionClicked(sender: NSButton) {
        eventHandler?.submitPasteboardAsGist()
        table.reloadData()
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

    func setDatasourceAndDelegateForTable(tds tds: NSTableViewDataSource, tvd: NSTableViewDelegate) {
        table.setDelegate(tvd)
        table.setDataSource(tds)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self
        eventHandler?.viewIsReady()
    }

    func windowWillClose(notification: NSNotification) {
    }

    func setResultText(s: String) {
        result.stringValue = s
    }

    func refreshAndReload() {
        //        table.reloadData()
    }

    func updateConstantOutput(s: String) {
        constantOutput.stringValue = s
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


    class Presenter: NSObject, NSTableViewDataSource, NSTableViewDelegate, FirstModuleInterface, InteractorOutput_FIRST {
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
        }

        func giveBackResponse(s: String) {
            view?.setResultText(s)
        }

        // -- FirstModuleInterface -----------------------------------

        func submitPasteboardAsGist() {
            // where should this go?
            interactor?.submitToGistService()
        }

        func clearRecentFiles() {
            interactor?.clearRecentFiles()
        }

        func openPreferences() {
            wireframe.presentPreferences()
        }

        // --

        func numberOfRowsInTableView(tableView: NSTableView) -> Int {
            return interactor?.countRecentFiles() ?? 0
        }

        let column1 = "column1"
        let column2 = "column2"


        struct Sample {
            let a: String
            let b: Int
        }


        func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let t = NSTextField()
            t.bordered = false
            t.drawsBackground = false

            let sample = Sample(a: "test", b: row)

            switch tableColumn!.identifier {
            case column1:
                t.stringValue = sample.a
            default:
                t.stringValue = "\(sample.b)"
            }

            return t
        }

        func viewIsReady() {
            view?.setDatasourceAndDelegateForTable(tds: self, tvd: self)
            //TODO:Tear down observer somewhere appropriate
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateOptions:"), name: "OptionsUpdated", object: nil)
        }

        func updateOptions(sender: NSNotification) {
            if let options = interactor?.createStringOfOptions() {
                view?.updateConstantOutput(options)
            }
        }
    }


}

