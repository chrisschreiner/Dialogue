import Foundation


class PastebufferAPI: PB_Gateway {
    func getContents() -> GistData {
        //TODO:Crashprone, fix
        return GistData(item: getPasteboardItems().first!)
    }
}