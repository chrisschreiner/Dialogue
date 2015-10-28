protocol InteractorInput_FIRST {
    func getUserIdentity(id: UserID) -> UserEntity?

    func performSomethingA()

    func performSomethingB()
}


protocol InteractorOutput_FIRST {
    func giveBackResponse(s: String)
}


protocol FirstViewI {
    func setResultText(s: String)
}
