//
//  Main-Servicefactory.swift
//  Dialogue
//
//  Created by Chris Patrick Schreiner on 02/11/15.
//  Copyright © 2015 Chris Patrick Schreiner. All rights reserved.
//

import Foundation
import Result


enum ProcessError: ErrorType {
    case NotImplementedYet
}


struct GistData {
    var data: String
    init(item: PBItem) {
        switch item {
        case .Text(let text):
            self.data = text
        default:
            preconditionFailure("undefined")
        }
    }
    init(data: String) {
        self.data = data
    }
}


protocol Strategy {
    func processIt(contents: GistData) -> Result<NSURL, ProcessError>
}


class GitHubStrategy: Strategy {
    func processIt(contents: GistData) -> Result<NSURL, ProcessError> {
        return .Failure(.NotImplementedYet)
    }
}


class PasteBinStrategy: Strategy {
    func processIt(contents: GistData) -> Result<NSURL, ProcessError> {
        return .Failure(.NotImplementedYet)
    }
}


class GistServiceFactory {
    static func makeStrategy(gistService: GistService, _ userCredential: UserCredential) -> Strategy? {
        switch gistService {
        case .GitHub:
            let strategy = GitHubStrategy()
            // lots of configuration here
            return strategy

        default:
            return nil
        }
    }
}


struct UserCredential {
}