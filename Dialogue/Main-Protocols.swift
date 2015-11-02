import Cocoa


/// Module MAIN
/// Messages from `View` to `Presenter`
/// (aka View.eventHandler)


protocol ModuleInterface_MAIN {
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


/// Module MAIN
/// Messages from `Presenter` to `Interactor`


protocol InteractorInput_MAIN {
    func submitToGistService(dataMan: LocalDatamanager_P)

    func countRecentFiles(dataMan: LocalDatamanager_P) -> Int

    func recentFileEntry(dataMan: LocalDatamanager_P, index: Int) -> Sample

    func clearRecentFiles(dataMan: LocalDatamanager_P)

    func createStringOfOptions(dataMan: LocalDatamanager_P) -> String
}


/// Module MAIN
/// Messages from `Interactor` to `Presenter`


protocol InteractorOutput_MAIN {
}