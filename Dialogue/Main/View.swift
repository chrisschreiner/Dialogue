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
        viewLifeCycle?.windowDidLoad()
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