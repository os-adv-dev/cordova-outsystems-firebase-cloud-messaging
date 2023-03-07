protocol OSLCNOCenterDelegate: AnyObject {
    associatedtype Notification = OSLCNOContentDelegate
    func trigger(_ notification: Notification, with actionArray: [OSLCNOActionButton]?) async throws
}
