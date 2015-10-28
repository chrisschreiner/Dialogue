protocol InteractorInput_FIRST {
    func submitToGistService()
}


protocol InteractorOutput_FIRST {
    func giveBackResponse(s: String)
}


protocol FirstViewI {
    func setResultText(s: String)
}


protocol FirstModuleInterface {
    func openPreferences()

    func submitPasteboardAsGist()
}