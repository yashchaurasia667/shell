// components/NotificationPopup.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Services.Notifications

import "../services"

PanelWindow {
  id: root

  anchors {
    top: true
    right: true
  }

  // Position right below the top bar (bar height is 35)
  margins.top: 35

  implicitWidth: 400
  implicitHeight: screen ? screen.height - 35 : 800

  color: "transparent"
  aboveWindows: true
  exclusionMode: ExclusionMode.Ignore

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "notification-popups"

  // Temporary list storing notifications actively showing as popups
  property var activePopups: []
  property int maxPopups: 4

  Connections {
    target: NotificationService
    function onNotificationReceived(notif) {
      let list = root.activePopups.slice()
      list.unshift(notif)
      if (list.length > root.maxPopups) {
        list = list.slice(0, root.maxPopups)
      }
      root.activePopups = list
    }
  }

  function dismissPopup(notif) {
    let list = root.activePopups.filter(n => n !== notif)
    root.activePopups = list
  }

  // If a notification is explicitly dismissed elsewhere (e.g. "Clear all" in panel)
  Connections {
    target: NotificationService.trackedNotifications
    function onObjectRemovedPre(object, index) {
      root.dismissPopup(object)
    }
  }

  // Only show the window when there are active popups
  visible: activePopups.length > 0

  // Pass mouse clicks/drags to popups, pass-through empty space to desktop
  mask: Region {
    item: popupColumn
  }

  Column {
    id: popupColumn
    width: root.implicitWidth
    // spacing: 12
    // topPadding: 10
    // rightPadding: 0

    Repeater {
      id: popupRepeater
      model: root.activePopups

      delegate: Item {
        id: popupItem
        required property var modelData
        required property int index

        width: popupColumn.width
        height: outerContainer.height

        // Auto-dismiss timeout (pauses on hover)
        readonly property int timeout: {
          if (!modelData) return 5000
          if (modelData.urgency === NotificationUrgency.Critical || modelData.expireTimeout === 0)
          return 0
          if (modelData.expireTimeout > 0)
          return modelData.expireTimeout
          return modelData.urgency === NotificationUrgency.Low ? 3500 : 5000
        }

        HoverHandler {
          id: cardHover
        }

        Timer {
          id: expireTimer
          interval: popupItem.timeout
          running: popupItem.timeout > 0 && !cardHover.hovered
          onTriggered: {
            // Dismiss ONLY the popup card; keeps it preserved in NotificationPanel!
            root.dismissPopup(popupItem.modelData)
          }
        }

        // ── Outer Framed Container ───────────────────────────────────────────
        Item {
          id: outerContainer
          width: parent.width
          height: contentTile.height + 20

          // Slide in from right
          x: 0
          Behavior on x {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
          }

          // The actual NotificationTile nested inside the frame
          NotificationTile {
            id: contentTile
            anchors.left: parent.left
            // anchors.leftMargin: frameShape.curveDepth + 12
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            modelData: popupItem.modelData

            // When user clicks the ✕ on the popup or swipes it away,
            // dismiss only the popup card while preserving it in the panel
            onDismissCustom: function() {
              root.dismissPopup(popupItem.modelData)
            }
          }
        }
      }
    }
  }
}
