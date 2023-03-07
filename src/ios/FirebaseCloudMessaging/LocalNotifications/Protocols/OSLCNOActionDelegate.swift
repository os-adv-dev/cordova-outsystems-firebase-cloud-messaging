public protocol OSLCNOActionDelegate: AnyObject {
    func triggerNotification(with title: String, _ body: String?, _ badge: Int?, _ sound: String?, and actionArray: [OSLCNOActionButton]?) async throws
}
