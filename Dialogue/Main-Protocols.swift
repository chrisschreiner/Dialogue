import Cocoa
import ReactiveCocoa
import Result


/// Module MAIN
/// Messages from `View` to `Presenter`
/// (aka View.eventHandler)


protocol MAIN_Presenter_Input {
    func openPreferences()

    func submitPasteboardAsGist()

    func clearRecentFiles()
}


protocol ViewLifeCycle {
    func viewIsReady()
}


/// Module MAIN
/// Messages from `Presenter` to `View`


protocol ViewInterface_MAIN {
    func setResultText(s: String)

    func setDatasourceForRecentFiles(datasource: NSTableViewDataSource)

    func setDelegateForRecentFiles(delegate: NSTableViewDelegate)

    func updateConstantOutput(s: String)
}