pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root

  readonly property alias notifications: server.trackedNotifications
  readonly property int count: notifications.count === undefined ? 0 : notifications.count
  readonly property bool hasNotifications: count > 0

  property bool doNotDisturb: false
  property int defaultTimeout: 5000
  property int exitAnimDuration: 200

  signal notified(notification: Notification)
  signal expiring(notification: Notification)

  function dismiss(notification: Notification): void {
    notification.dismiss()
  }

  function dismissAll(): void {
    for (const n of [...notifications.values]) n.dismiss()
  }

  NotificationServer {
    id: server

    bodySupported: true
    bodyMarkupSupported: true
    bodyHyperlinksSupported: true
    imageSupported: true
    actionsSupported: true
    actionIconsSupported: true
    persistenceSupported: true
    keepOnReload: false

    onNotification: (notification) => {
      notification.tracked = true
      root.notified(notification)

      if (!root.doNotDisturb && notification.expireTimeout !== 0) {
        const timeout = notification.expireTimeout > 0
          ? notification.expireTimeout
          : root.defaultTimeout

        expireTimer.createObject(root, {
          notification: notification,
          interval: timeout
        })
      }
    }
  }

  Component {
    id: expireTimer
    Timer {
      id: timer
      required property Notification notification
      running: true
      repeat: false
      onTriggered: {
        timer.notification.expire()
        timer.destroy()
      }
    }
  }
}
