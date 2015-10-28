extension First {


    class Interactor: InteractorInput_FIRST {
        var localDatamanager: LocalDatamanager?
        var apiDatamanager: APIDatamanager?
        var output: InteractorOutput_FIRST?

        //        func getUserIdentity(id: UserID) -> UserEntity? {
        //            return localDatamanager?.fetchUser(id)
        //        }
        //
        //        func performSomethingA() {
        //            output?.giveBackResponse("Hello")
        //        }
        //
        //        func performSomethingB() {
        //            output?.giveBackResponse("World")
        //        }
        //

        func submitToGistService() {
        }
    }


    class LocalDatamanager {
        func fetchUser(id: UserID) -> UserEntity? {
            switch id {
            case "Peter":
                return UserEntity(name: "Peter Pan", age: 12)
            default:
                return nil
            }
        }
    }


    class APIDatamanager {
    }


}