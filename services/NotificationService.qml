// services/NotificationService.qml
pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

QtObject {
  id: root

  property bool dnd: false

  // The notification daemon — only one can own the D-Bus name system-wide
  property NotificationServer _server: NotificationServer {
    keepOnReload: true
    bodyMarkupSupported: false
    bodySupported: true
    persistenceSupported: true
    imageSupported: true
    actionsSupported: true
    onNotification: notif => {
      if (root.dnd) {
        notif.dismiss()
      } else {
        notif.tracked = true
        root.notificationReceived(notif)
      }
    }
  }

  // Expose the tracked notifications model for panels and popups
  readonly property var trackedNotifications: _server.trackedNotifications
  readonly property int count: _server.trackedNotifications.values.length

  // Signal emitted when a new notification arrives (for popups to react)
  signal notificationReceived(var notification)

  // Dismiss all tracked notifications
  function clearAll() {
    const items = _server.trackedNotifications.values
    for (let i = items.length - 1; i >= 0; i--)
      items[i].dismiss()
  }
}
