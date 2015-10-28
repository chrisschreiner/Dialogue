protocol InteractorInput_FIRST {
    //    func getUserIdentity(id: UserID) -> UserEntity?
    //
    //    func performSomethingA()
    //
    //    func performSomethingB()


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