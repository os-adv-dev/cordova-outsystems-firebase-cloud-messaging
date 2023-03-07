import UserNotifications

public struct OSLCNOFactory {
    public static func createUNWrapper() -> OSLCNOActionDelegate {
        let center = UNUserNotificationCenter.current()
        let contentType = UNMutableNotificationContent.self
        return OSLCNOWrapper(center: center, contentType: contentType)
    }
}
