import Cocoa


protocol ViewInterface_FIRST {
    func setResultText(s: String)

    func setDatasourceForRecentFiles(datasource: NSTableViewDataSource)

    func setDelegateForRecentFiles(delegate: NSTableViewDelegate)

    func updateConstantOutput(s: String)
}


protocol ModuleInterface_FIRST {
    func openPreferences()

    func submitPasteboardAsGist()

    func viewIsReady()

    func clearRecentFiles()
}


protocol InteractorInput_FIRST {
    func submitToGistService()

    func countRecentFiles() -> Int

    func recentFileEntry(index: Int) -> Sample

    func clearRecentFiles()

    func createStringOfOptions() -> String
}


protocol InteractorOutput_FIRST {
    func giveBackResponse(s: String)
}