// components/NotificationTile.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Item {
  id: root
  required property Notification modelData

  // Record the time this tile was first shown
  property var receivedAt: new Date()
  property bool expanded: false

  implicitHeight: card.height
  implicitWidth: card.width
  clip: true

  // --- Relative timestamp (updates with Globals.clock) ---
  function relativeTime() {
    const diffMs = new Date() - root.receivedAt
    const diffS  = Math.floor(diffMs / 1000)
    if (diffS < 60)   return "now"
    if (diffS < 3600) return Math.floor(diffS / 60) + "m ago"
    if (diffS < 86400) return Math.floor(diffS / 3600) + "h ago"
    return Math.floor(diffS / 86400) + "d ago"
  }

  // Recompute label whenever the clock ticks (Globals.clock fires every minute)
  property string _timestamp: relativeTime()
  Connections {
    target: Globals.clock
    function onMinutesChanged() { root._timestamp = root.relativeTime() }
  }

  // --- Urgency accent color ---
  property color accentColor: {
    switch (root.modelData.urgency) {
      case NotificationUrgency.Critical: return "#f38ba8"  // red
      case NotificationUrgency.Low:      return "#6c7086"  // muted
      default:                           return "#89b4fa"  // blue (Normal)
    }
  }

  // ── Card ─────────────────────────────────────────────────────────────────
  Rectangle {
    id: card
    width: root.width
    implicitHeight: innerCol.implicitHeight + 20
    height: implicitHeight

    radius: 12
    color: "#313244"

    // Left urgency accent stripe
    Rectangle {
      width: 3
      height: parent.height - 16
      anchors.left: parent.left
      anchors.leftMargin: 0
      anchors.verticalCenter: parent.verticalCenter
      radius: 2
      color: root.accentColor
    }

    // Swipe-to-dismiss: drag left past 35% to dismiss
    property real dragX: 0
    x: dragX

    opacity: Math.max(0, 1 - Math.abs(dragX) / width)

    Behavior on dragX {
      enabled: !swipeHandler.active
      NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
    }

    DragHandler {
      id: swipeHandler
      xAxis.minimum: -card.width * 2
      xAxis.maximum: 0
      yAxis.enabled: false

      onCentroidChanged: {
        if (active)
          card.dragX = Math.min(0, centroid.position.x - centroid.pressPosition.x)
      }

      onActiveChanged: {
        if (!active) {
          if (card.dragX < -card.width * 0.35) {
            card.dragX = -(card.width + 24)
            dismissTimer.start()
          } else {
            card.dragX = 0
          }
        }
      }
    }

    Timer {
      id: dismissTimer
      interval: 300
      onTriggered: root.modelData.dismiss()
    }

    // Click anywhere to expand/collapse body
    TapHandler {
      onTapped: root.expanded = !root.expanded
    }

    // ── Content ──────────────────────────────────────────────────────────
    ColumnLayout {
      id: innerCol
      anchors {
        left: parent.left;  leftMargin: 16
        right: parent.right; rightMargin: 12
        top: parent.top;    topMargin: 10
      }
      spacing: 4

      // Header row: icon · app name · timestamp · ✕
      RowLayout {
        Layout.fillWidth: true
        spacing: 7

        // App icon (themed or image)
        Item {
          width: 16; height: 16
          Layout.alignment: Qt.AlignVCenter

          Image {
            id: iconImg
            anchors.fill: parent
            source: {
              if (root.modelData.image !== "")
                return root.modelData.image
              const p = Quickshell.iconPath(root.modelData.appIcon, false)
              return p !== "" ? p : ""
            }
            fillMode: Image.PreserveAspectFit
            visible: status === Image.Ready
          }

          // Fallback: first letter of app name in a pill
          Rectangle {
            anchors.fill: parent
            radius: 4
            color: root.accentColor
            visible: !iconImg.visible || iconImg.source === ""

            Text {
              anchors.centerIn: parent
              text: root.modelData.appName.charAt(0).toUpperCase()
              color: "white"
              font.pixelSize: 9
              font.bold: true
            }
          }
        }

        // App name
        Text {
          text: root.modelData.appName
          color: "#a6adc8"
          font.pixelSize: 11
          elide: Text.ElideRight
          Layout.fillWidth: true
        }

        // Relative timestamp
        Text {
          text: root._timestamp
          color: "#6c7086"
          font.pixelSize: 11
        }

        // Dismiss ✕
        Text {
          text: "✕"
          color: "#6c7086"
          font.pixelSize: 11
          Layout.alignment: Qt.AlignVCenter

          MouseArea {
            anchors.fill: parent
            anchors.margins: -6   // bigger hit target
            onClicked: root.modelData.dismiss()
          }
        }
      }

      // Summary
      Text {
        text: root.modelData.summary
        color: "#cdd6f4"
        font.pixelSize: 13
        font.bold: true
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        maximumLineCount: 2
        elide: Text.ElideRight
      }

      // Body (collapsible)
      Text {
        id: bodyText
        visible: root.modelData.body !== ""
        text: root.modelData.body
        textFormat: Text.PlainText
        color: "#a6adc8"
        font.pixelSize: 12
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        maximumLineCount: root.expanded ? 0 : 2
        elide: Text.ElideRight
        bottomPadding: 2
      }
    }
  }

  // Animate height changes on expand/collapse
  Behavior on implicitHeight {
    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
  }
}
