import Cocoa


typealias UserID = String


struct UserEntity {
    var name: String
    var age: Int
}


enum ShortenService: Int {
    case Isgd = 0
    case Hive
    case Bitly
    case Supr
    case Vgd

    static func popupMenuList() -> NSMenu {
        return buildMenuPopup(source:
        [
                (Isgd.rawValue, "Isgd", "is.gd"),
                (Hive.rawValue, "Hive.am", "hive.am"),
                (Bitly.rawValue, "Bitly", "bit.ly"),
                (Supr.rawValue, "Supr", ""),
                (Vgd.rawValue, "Vgd", ""),
        ])
    }
}


enum GistService: Int {
    case GitHub = 0
    case PasteBin
    case NoPaste
    case TinyPaste

    static func popupMenuList() -> NSMenu {
        return buildMenuPopup(source:
        [
                (GitHub.rawValue, "GitHub", ""),
                (PasteBin.rawValue, "PasteBin", ""),
                (NoPaste.rawValue, "NoPaste", ""),
                (TinyPaste.rawValue, "TinyPaste", ""),
        ])
    }
}


typealias MenuTypeTuple = (tag:Int, title:String, imageName:String)


func buildMenuPopup(source source: [MenuTypeTuple]) -> NSMenu {
    let menuItemList = source.map {
        tag, title, imageName -> NSMenuItem in
        let m = NSMenuItem()
        m.tag = tag
        m.title = title
        m.onStateImage = NSImage(named: imageName)
        m.onStateImage?.template = false
        return m
    }

    let menu = NSMenu()
    for each in menuItemList {
        menu.addItem(each)
    }

    return menu
}

