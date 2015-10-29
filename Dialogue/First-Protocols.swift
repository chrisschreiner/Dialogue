import Cocoa


protocol FirstModuleInterface {
    func openPreferences()

    func submitPasteboardAsGist()

    //func countRecentFiles() -> Int

    //func recentFileEntry(i:Int) -> Main.Presenter.Sample
    func viewIsReady()

    func clearRecentFiles()
}


protocol InteractorInput_FIRST {
    func submitToGistService()

    func countRecentFiles() -> Int

    func recentFileEntry(index: Int) -> Main.Presenter.Sample

    func clearRecentFiles()

    func createStringOfOptions() -> String
}


protocol InteractorOutput_FIRST {
    func giveBackResponse(s: String)
}


protocol FirstViewI {
    func setResultText(s: String)

    func setDatasourceAndDelegateForTable(tds tds: NSTableViewDataSource, tvd: NSTableViewDelegate)

    func refreshAndReload()

    func updateConstantOutput(s: String)
}


