
protocol FirstInput {
    func getUserIdentity(id: UserID) -> UserEntity?

    func performSomethingA()

    func performSomethingB()
}


protocol FirstOutput {
    func giveBackResponse(s: String)
}


protocol FirstViewI {
    func setResultText(s: String)
}
