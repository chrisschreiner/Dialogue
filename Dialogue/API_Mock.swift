import ReactiveCocoa
import Foundation


//TODO: Generify this


class MockedApiForGist: API_MAIN_P {
    let _closure: () -> Void
    let _callback: () -> Void

    func postGist(content: GistData, config: Config_P) -> SignalProducer<NSURL, ProcessError> {
        return SignalProducer {
            o, d in

            o.sendNext(NSURL(string: "http://sample.url")!)
            o.sendCompleted()
        }
    }

/*
    func sendGist(data: GistData) {
        _closure()
        _callback()
    }

    func sendGist() {
        _closure()

        //do stuff
        print("Doing stuff")
    }
*/

    init(_ _closure: () -> Void, _callback: () -> Void) {
        self._closure = _closure
        self._callback = _callback
    }
}