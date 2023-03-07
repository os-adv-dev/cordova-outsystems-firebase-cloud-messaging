protocol OSLCNOContentDelegate: AnyObject {
    associatedtype Notification = Self
    static func createNotification(with title: String, _ body: String, _ badge: Int?, and sound: String?) -> Notification
}

extension OSLCNOContentDelegate {
    static func createNotification(with title: String, _ body: String, and sound: String?) -> Notification {
        self.createNotification(with: title, body, nil, and: sound)
    }
}
