// rightPanel/NotificationPanel.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Notifications

import "../components"

Item {
  id: root

  // ── Notification daemon ───────────────────────────────────────────────────
  // Instantiating NotificationServer makes Quickshell the system notification daemon.
  // All apps that use libnotify / D-Bus notifications will send here.
  property bool dnd: false

  NotificationServer {
    id: server
    keepOnReload: true
    bodyMarkupSupported: false
    bodySupported: true
    persistenceSupported: true
    onNotification: notif => {
      if (root.dnd) notif.dismiss()
    }
  }

  property int count: server.trackedNotifications.count

  // ── Layout ────────────────────────────────────────────────────────────────
  ColumnLayout {
    anchors.fill: parent
    spacing: 10

    // Header
    RowLayout {
      Layout.fillWidth: true
      Layout.leftMargin: 2
      Layout.rightMargin: 2

      Text {
        text: "Notifications"
        color: "#cdd6f4"
        font.pixelSize: 14
        font.bold: true
        Layout.fillWidth: true
      }

      // Notification count badge
      Rectangle {
        visible: root.count > 0
        width: countLabel.implicitWidth + 10
        height: 18
        radius: 9
        color: "#45475a"

        Text {
          id: countLabel
          anchors.centerIn: parent
          text: root.count
          color: "#cdd6f4"
          font.pixelSize: 11
        }
      }

      // Clear all button
      Text {
        visible: root.count > 0
        text: "Clear all"
        color: "#6c7086"
        font.pixelSize: 11
        Layout.leftMargin: 8

        MouseArea {
          anchors.fill: parent
          anchors.margins: -4
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            // Dismiss from end to start to avoid index shifting issues
            const items = server.trackedNotifications
            for (let i = items.count - 1; i >= 0; i--)
              items.get(i).dismiss()
          }
        }
      }
    }

    // ── Empty state ───────────────────────────────────────────────────────
    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true
      visible: root.count === 0

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 8

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: "󰂚"
          font.family: "Symbols Nerd Font"
          font.pixelSize: 32
          color: "#313244"
        }

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: "No notifications"
          color: "#6c7086"
          font.pixelSize: 13
        }
      }
    }

    // ── Notification list ─────────────────────────────────────────────────
    ScrollView {
      id: scrollView
      Layout.fillWidth: true
      Layout.fillHeight: true
      visible: root.count > 0
      clip: true

      // Hide scrollbar — swipe to scroll feels more native
      ScrollBar.vertical.policy: ScrollBar.AsNeeded
      ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

      ListView {
        id: listView
        width: scrollView.width
        spacing: 8
        clip: true

        // Newest first: reverse the model
        model: server.trackedNotifications
        verticalLayoutDirection: ListView.BottomToTop

        // Tiles
        delegate: NotificationTile {
          required property var modelData
          width: listView.width
        }

        // Animate items appearing / disappearing
        add: Transition {
          NumberAnimation {
            properties: "opacity,x"
            from: 0
            duration: 250
            easing.type: Easing.OutCubic
          }
        }

        remove: Transition {
          NumberAnimation {
            property: "opacity"
            to: 0
            duration: 200
          }
        }

        displaced: Transition {
          NumberAnimation {
            properties: "y"
            duration: 200
            easing.type: Easing.OutCubic
          }
        }
      }
    }
  }
}
