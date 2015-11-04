import ReactiveCocoa
import Foundation


//TODO: Generify this


class MockedApiForGist: API_MAIN_P {
    private let _callback: () -> NSURL

    func postGist(content: GistData, config: Config_P) -> SignalProducer<NSURL, ProcessError> {
        return SignalProducer {
            o, d in

            o.sendNext(self._callback())
            o.sendCompleted()
        }
    }

    init( _callback: () -> NSURL) {
        self._callback = _callback
    }
}


class PastebufferGatewayMock: PB_Gateway {
	private let _callback: () -> GistData

	func getContents() -> GistData {
		return self._callback()
	}
	
	init( _callback: () -> GistData) {
		self._callback = _callback
	}
}