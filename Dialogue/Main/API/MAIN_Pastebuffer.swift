class PastebufferAPI: Pastebuffer_API_P {
    func getContents() -> GistData {
        //TODO:Crashprone, fix
        return GistData(item: getPasteboardItems().first!)
    }
}