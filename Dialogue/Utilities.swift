import Cocoa


typealias UserID = String


struct Bunny {
    let gist: GistService
    let shorten: ShortenService
    let secret: Bool
}


struct Sample {
    let a: String
    let b: Int
}


struct RecentFile {
    let filename: String
    let url: String
}


struct UserEntity {
    var name: String
    var age: Int
}


typealias MenuTypeTuple = (tag:Int, title:String, imageName:String)


enum ShortenService: Int {
    case Isgd = 0
    case Hive
    case Bitly
    case Supr
    case Vgd

    static func popupMenuList() -> NSMenu {
        let data: [MenuTypeTuple] = [(Isgd.rawValue, "Isgd", "is.gd"), (Hive.rawValue, "Hive.am", "hive.am"), (Bitly.rawValue, "Bitly", "bit.ly"), (Supr.rawValue, "Supr", ""), (Vgd.rawValue, "Vgd", ""), ]

        return buildMenuPopup(source: data)
    }
}


enum GistService: Int {
    case GitHub = 0
    case PasteBin
    case NoPaste
    case TinyPaste

    static func popupMenuList() -> NSMenu {
        let data: [MenuTypeTuple] = [(GitHub.rawValue, "GitHub", ""), (PasteBin.rawValue, "PasteBin", ""), (NoPaste.rawValue, "NoPaste", ""), (TinyPaste.rawValue, "TinyPaste", ""), ]
        return buildMenuPopup(source: data)
    }
}


extension NSMenu {
    func addAllItems(menuItems: [NSMenuItem]) -> NSMenu {
        for each in menuItems {
            self.addItem(each)
        }
        return self
    }
}


func buildMenuPopup(source data: [MenuTypeTuple]) -> NSMenu {
    return NSMenu().addAllItems(data.map {
        tag, title, imageName -> NSMenuItem in let m = NSMenuItem()
        m.tag = tag
        m.title = title
        m.onStateImage = NSImage(named: imageName)
        m.onStateImage?.template = false
        return m
    })
}

func putInPasteboard(items items: [String]) -> Bool {
    let pb = NSPasteboard.generalPasteboard()
    pb.clearContents()

    return pb.writeObjects(items)
}

func getPasteboardItems() -> [PBItem] {

    func switchOnItem(item: AnyObject) -> PBItem {
        switch item {
        case let image as NSImage:
            return .Image(image)

        case let text as NSString:
            return .Text(String(text))

        case let attrText as NSAttributedString:
            return .Text(attrText.string)

        case let file as NSURL:
            return .File(file)

        default: //blow up
            preconditionFailure()
        }
    }

    let pasteBoard = NSPasteboard.generalPasteboard()
    let classes: [AnyClass] = [NSURL.self, NSString.self, NSAttributedString.self, NSImage.self]
    let options: [String:AnyObject] = [:]
    let copiedItems = pasteBoard.readObjectsForClasses(classes, options: options)
    var result: [PBItem] = []
    if let items = copiedItems {
        for item in items {
            result.append(switchOnItem(item))
        }
    }
    return result
}


enum PBItem {
    case Text(String)
    case Image(NSImage)
    case File(NSURL)
}


/*
struct GistOptions {
var gistHTTPBody: [String:String] {
return [
"description": self.options.description,
"public": !self.options.publicGist,
"files": [self.options.fileName: ["content": content]],
]
}
}


func makeRequest(updateGist: Bool, gistID: String, gistOptions: GistOptions) -> NSMutableURLRequest {
let request = NSMutableURLRequest()
if updateGist {
let updateURL = connectionURL.URLByAppendingPathComponent(gistID!)
request = NSMutableURLRequest(URL: updateURL)
request.HTTPMethod = "PATCH"
} else {
request = NSMutableURLRequest(URL: connectionURL)
request.HTTPMethod = "POST"
}

request.HTTPBody = try! JSON(gistOptions.gistHTTPBody.rawData())
request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

if let token = oauth.getToken() {
request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
}

return request
}

*/
