import Cocoa


class MAIN_Presenter: NSObject {
    var view: MAIN_ViewInput?
    var interactor: MAIN_InteractorInput?
    var wireframe: MAIN_Wireframe?

    func updateOptions(sender: NSNotification) {
        updateConstantOptionsField()
    }

    func updateConstantOptionsField() {
        if let options = interactor?.createStringOfOptions() {
            view?.updateConstantOutput(options)
        }
    }
}


extension MAIN_Presenter: NSTableViewDataSource, NSTableViewDelegate {
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


extension MAIN_Presenter: MAIN_PresenterInput {
    func openPreferences() {
        wireframe?.presentPreferences()
    }

    func submitPasteboardAsGist() {
        interactor!.postGist()
    }


    func clearRecentFiles() {
        interactor!.recentFiles.removeAll()
    }
}


extension MAIN_Presenter: MAIN_InteractorOutput {
    func giveMeTheURL() -> NSURL {
        return NSURL(string: "whatever")! //TODO:Check
    }
}


extension MAIN_Presenter: ViewLifeCycle {
    func windowDidLoad() {
        view?.setDatasourceForRecentFiles(self)
        view?.setDelegateForRecentFiles(self)

        //TODO:Tear down observer somewhere appropriate
        let n = NSNotificationCenter.defaultCenter()
        n.addObserver(self, selector: Selector("updateOptions:"), name: PreferencesUpdatedNotification, object: nil)
        updateConstantOptionsField()
    }
}