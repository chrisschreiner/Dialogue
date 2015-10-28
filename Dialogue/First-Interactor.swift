import Cocoa


protocol GlobalDataProtocol {
}


extension Main {


    class Interactor: InteractorInput_FIRST {
        var localDatamanager: LocalDatamanager?
        var apiDatamanager: APIDatamanager?
        var output: InteractorOutput_FIRST?

        func submitToGistService() {
            apiDatamanager?.processIt(localDatamanager!)
        }
    }


    class APIDatamanager {
        var globalAccessData: GlobalDataProtocol?
        func processIt(dataManager: LocalDatamanager) {

            //?How do I access the Preferences-Module.LocalDataManager instance ?
            //!Turn the LocalDataManager into a GlobalDatamanager by narrow protocols

            let gist = GistService(rawValue: dataManager.activeGistService ?? 0)!
            let shorten = ShortenService(rawValue: dataManager.activeShortenService ?? 0)!
            let secret = dataManager.secretGists ?? true

            print("processed the gist with: \(gist) \(shorten) \(secret)")
        }
    }


    struct Bunny {
        let gist: GistService
        let shorten: ShortenService
        let secret: Bool
    }


}


/*
struct GistOptions {
    var gistHTTPBody: [String:String] {
        return [
                "description": self.options.description,
                "public": !self.options.publicGist,
                "files": [self.options.fileName: ["content": content]],
        ]
    }
}


func makeRequest(updateGist: Bool, gistID: String, gistOptions: GistOptions) -> NSMutableURLRequest {
    let request = NSMutableURLRequest()
    if updateGist {
        let updateURL = connectionURL.URLByAppendingPathComponent(gistID!)
        request = NSMutableURLRequest(URL: updateURL)
        request.HTTPMethod = "PATCH"
    } else {
        request = NSMutableURLRequest(URL: connectionURL)
        request.HTTPMethod = "POST"
    }

    request.HTTPBody = try! JSON(gistOptions.gistHTTPBody.rawData())
    request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

    if let token = oauth.getToken() {
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
    }

    return request
}

*/