class PastebufferGatewayMock: Pastebuffer_API_P {
    let _callback: () -> GistData

    func getContents() -> GistData {
        return self._callback()
    }

    init(_callback: () -> GistData) {
        self._callback = _callback
    }
}