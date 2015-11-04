import Foundation


protocol PB_Gateway {
    func getContents() -> GistData
}


class PastebufferGatewayMock: PB_Gateway {
    let _callback: () -> GistData

    func getContents() -> GistData {
        return self._callback()
    }

    init(_callback: () -> GistData) {
        self._callback = _callback
    }
}