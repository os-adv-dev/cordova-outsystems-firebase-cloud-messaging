import UserNotifications

extension UNMutableNotificationContent: OSLCNOContentDelegate {
    static func createNotification(with title: String, _ body: String, _ badge: Int?, and sound: String?) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if let badge = badge, badge >= 0 {
            content.badge = NSNumber(value: badge)
        }
        if let sound = sound {
            let filePath = "\(Self.audioFileFolder)/\(sound)"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: filePath))
        } else {
            content.sound = .default
        }
        
        return content
    }
}

private extension UNMutableNotificationContent {
    static let audioFileFolder = "www"
}

enum OSLCNOActionType: Equatable {
    case standard
    case destructive
    case textInput(placeholder: String?)
    
    init(from text: String, with placeholder: String?) throws {
        switch text.lowercased() {
        case "default": self = .standard
        case "destructive": self = .destructive
        case "textinput": self = .textInput(placeholder: placeholder)
        default: throw OSLCNOActionTypeError.unknownType
        }
    }
    
    enum OSLCNOActionTypeError: Error {
        case unknownType
    }
}

enum OSLCNOActionEvent: String {
    case internalRoute
    case appRoute
    case webRoute
    case apiPost
    
    init(from text: String) throws {
        guard let actionEvent = OSLCNOActionEvent(rawValue: text) else { throw OSLCNOActionEventError.unknownEvent }
        self = actionEvent
    }
    
    enum OSLCNOActionEventError: Error {
        case unknownEvent
    }
}


public struct OSLCNOActionButton {
    let id: String
    let label: String
    let icon: String?
    let type: OSLCNOActionType
    let event: OSLCNOActionEvent
    let processData: String?
}

extension OSLCNOActionButton: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case label
        case icon
        case type
        case inputTextPlaceholder
        case event
        case processData
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let label = try container.decode(String.self, forKey: .label)
        let icon = try container.decodeIfPresent(String.self, forKey: .icon)
        let type = try container.decode(String.self, forKey: .type)
        let inputTextPlaceholder = try container.decodeIfPresent(String.self, forKey: .inputTextPlaceholder)
        let event = try container.decode(String.self, forKey: .event)
        let processData = try container.decodeIfPresent(String.self, forKey: .processData)
        
        let actionType = try OSLCNOActionType(from: type, with: inputTextPlaceholder)
        let actionEvent = try OSLCNOActionEvent(from: event)
        
        self.init(id: id, label: label, icon: icon, type: actionType, event: actionEvent, processData: processData)
    }
}
