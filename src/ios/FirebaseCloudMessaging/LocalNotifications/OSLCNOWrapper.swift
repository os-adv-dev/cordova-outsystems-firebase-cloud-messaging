import Foundation

final class OSLCNOWrapper<
    CenterType: OSLCNOCenterDelegate, ContentType: OSLCNOContentDelegate
>: NSObject where CenterType.Notification == ContentType.Notification {
    typealias Notification = ContentType.Notification
    
    private let center: CenterType
    private let contentType: ContentType.Type
    
    init(center: CenterType, contentType: ContentType.Type) {
        self.center = center
        self.contentType = contentType
    }
}

extension OSLCNOWrapper: OSLCNOActionDelegate {
    func triggerNotification(with title: String, _ body: String?, _ badge: Int?, _ sound: String?, and actionArray: [OSLCNOActionButton]?) async throws {
        guard !title.isEmpty else { throw OSLCNOError.noTitle }
        
        let body = body ?? ""
        
        let notification: Notification
        if let badge = badge, badge >= 0 {
            notification = self.contentType.createNotification(with: title, body, badge, and: sound)
        } else {
            notification = self.contentType.createNotification(with: title, body, and: sound)
        }
        
        do {
            try await self.center.trigger(notification, with: actionArray)
        } catch {
            throw OSLCNOError.triggerError
        }
    }
}
