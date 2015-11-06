import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var wireframe: MAIN_Wireframe!
    let appModel = AppModel()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        wireframe = MAIN_Wireframe(appModel: appModel)
    }
}

