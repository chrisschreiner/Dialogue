import Cocoa


protocol ViewInterface_MAIN {
    func setResultText(s: String)

    func setDatasourceForRecentFiles(datasource: NSTableViewDataSource)

    func setDelegateForRecentFiles(delegate: NSTableViewDelegate)

    func updateConstantOutput(s: String)
}


protocol ModuleInterface_MAIN {
    func openPreferences()

    func submitPasteboardAsGist()

    func viewIsReady()

    func clearRecentFiles()
}


protocol InteractorInput_MAIN {
    func submitToGistService()

    func countRecentFiles() -> Int

    func recentFileEntry(index: Int) -> Sample

    func clearRecentFiles()

    func createStringOfOptions() -> String
}


protocol InteractorOutput_MAIN {
}