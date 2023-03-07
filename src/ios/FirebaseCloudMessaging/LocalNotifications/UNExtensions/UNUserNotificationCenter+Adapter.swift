import UserNotifications

extension UNUserNotificationCenter: OSLCNOCenterDelegate {
    func trigger(_ notification: UNMutableNotificationContent, with actionArray: [OSLCNOActionButton]?) async throws {
        let uuidString = UUID().uuidString
        var actions = [UNNotificationAction]()
        
        if let actionArray = actionArray {
            actionArray.forEach { actionButton in
                if case .textInput(_) = actionButton.type {
                    actions += [UNTextInputNotificationAction(textInputFrom: actionButton)]
                } else {
                    actions += [UNNotificationAction(from: actionButton)]
                }
                notification.userInfo[actionButton.id] = actionButton.processData
            }
        }
        
        let category = UNNotificationCategory(identifier: uuidString, actions: actions, intentIdentifiers: [])
        notification.categoryIdentifier = category.identifier
        
        let request = UNNotificationRequest(identifier: uuidString, content: notification, trigger: nil)
        
        self.setNotificationCategories([category])
        
        // Schedule the request with the system.
        try await self.add(request)
    }
}

extension UNNotificationActionOptions {
    init(from actionType: OSLCNOActionType) throws {
        if actionType == .destructive {
            self = .destructive
        } else {
            throw UNNotificationActionOptionsError.unsupportedOption
        }
    }
    
    enum UNNotificationActionOptionsError: Error {
        case unsupportedOption
    }
}

@available(iOS 15, *)
extension UNNotificationActionIcon {
    convenience init(from actionIcon: String) {
        self.init(systemImageName: actionIcon)
    }
}

extension UNNotificationAction {
    convenience init(from actionButton: OSLCNOActionButton) {
        let identifier = actionButton.id
        let title = actionButton.label
        let options: UNNotificationActionOptions
        do {
            let actionType = try UNNotificationActionOptions(from: actionButton.type)
            options = [actionType]
        } catch {
            options = []
        }
        
        
        if #available(iOS 15, *) {
            var icon: UNNotificationActionIcon?
            if let actionIcon = actionButton.icon {
                icon = .init(from: actionIcon)
            }
            
            self.init(identifier: identifier, title: title, options: options, icon: icon)
        } else {
            self.init(identifier: identifier, title: title, options: options)
        }
    }
}

extension UNTextInputNotificationAction {
    static let defaultButtonTitle = "Submit"
    static let defaultPlaceholder = ""
    
    convenience init(textInputFrom actionButton: OSLCNOActionButton) {
        let identifier = actionButton.id
        let title = actionButton.label
        let textInputButtonTitle = Self.defaultButtonTitle
        var textInputPlaceholder = Self.defaultPlaceholder
            
        if case .textInput(let placeholder) = actionButton.type, let placeholder = placeholder {
            textInputPlaceholder = placeholder
        }
        
        if #available(iOS 15, *) {
            var icon: UNNotificationActionIcon?
            if let actionIcon = actionButton.icon {
                icon = .init(from: actionIcon)
            }
            
            self.init(identifier: identifier, title: title, options: [], icon: icon, textInputButtonTitle: textInputButtonTitle, textInputPlaceholder: textInputPlaceholder)
        } else {
            self.init(identifier: identifier, title: title, options: [], textInputButtonTitle: textInputButtonTitle, textInputPlaceholder: textInputPlaceholder)
        }
    }
}
