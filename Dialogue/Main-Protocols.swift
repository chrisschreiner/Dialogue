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
    func submitToGistService(config: Config_P)

    func countRecentFiles(config: Config_P) -> Int

    func recentFileEntry(config: Config_P, index: Int) -> Sample

    func clearRecentFiles(config: Config_P)

    func createStringOfOptions(config: Config_P) -> String
}


/// Module MAIN
/// Messages from `Interactor` to `Presenter`


protocol InteractorOutput_MAIN {
}