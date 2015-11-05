import Cocoa


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
        interactor!.postGist()
    }


    func clearRecentFiles() {
        interactor!.recentFiles.removeAll()
    }
}


extension Presenter_MAIN: InteractorOutput_MAIN {
    func giveMeTheURL() -> NSURL {
        return NSURL(string: "whatever")! //TODO:Check
    }
}


extension Presenter_MAIN: ViewLifeCycle {
    func windowDidLoad() {
        view?.setDatasourceForRecentFiles(self)
        view?.setDelegateForRecentFiles(self)

        //TODO:Tear down observer somewhere appropriate
        let n = NSNotificationCenter.defaultCenter()
        n.addObserver(self, selector: Selector("updateOptions:"), name: NotificationNameOptionsUpdated, object: nil)
        updateConstantOptionsField()
    }
}