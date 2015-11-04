//
//  Main-Servicefactory.swift
//  Dialogue
//


import Foundation
import Result


enum ProcessError: ErrorType {
    case NotImplementedYet
}


protocol Strategy {
    func process(contents: GistData) -> Result<NSURL, ProcessError>
}


class GitHubStrategy: Strategy {
    func process(contents: GistData) -> Result<NSURL, ProcessError> {
        return .Failure(.NotImplementedYet)
    }
}


class PasteBinStrategy: Strategy {
    func process(contents: GistData) -> Result<NSURL, ProcessError> {
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