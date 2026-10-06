import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

import qs.common
import qs.components

Item {
  id: root

  property bool expanded: false
  readonly property int iconSize: 20
  readonly property int iconSpacing: 8

  readonly property int trayContentWidth:
    SystemTray.items.values.length * iconSize +
    Math.max(0, SystemTray.items.values.length - 1) * iconSpacing

  implicitWidth: trayContainer.width + iconSpacing + toggleIcon.width
  implicitHeight: Math.max(iconSize, toggleIcon.height)

  // clipped container holding the actual tray icons — expands/collapses leftward
  Item {
    id: trayContainer
    anchors.right: toggleIcon.left
    anchors.rightMargin: root.expanded ? root.iconSpacing : 0
    anchors.verticalCenter: parent.verticalCenter

    clip: true
    width: root.expanded ? root.trayContentWidth : 0
    height: root.iconSize

    Behavior on width {
      NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
    }
    Behavior on anchors.rightMargin {
      NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
    }

    RowLayout {
      height: parent.height
      spacing: root.iconSpacing
      // anchor to the right edge of the container so icons reveal from the right
      // (i.e. nearest the toggle) outward, matching the leftward expansion
      anchors.right: parent.right

      Repeater {
        model: SystemTray.items

        delegate: Item {
          id: trayIcon
          required property SystemTrayItem modelData

          implicitWidth: root.iconSize
          implicitHeight: root.iconSize

          Image {
            anchors.fill: parent
            source: trayIcon.modelData.icon
            fillMode: Image.PreserveAspectFit
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: (mouse) => {
              if (mouse.button === Qt.LeftButton) {
                trayIcon.modelData.activate()
              } else if (mouse.button === Qt.RightButton) {
                if (trayIcon.modelData.hasMenu) {
                  menuAnchor.menu = trayIcon.modelData.menu
                  menuAnchor.open()
                }
              }
            }
          }

          QsMenuAnchor {
            id: menuAnchor
            anchor.window: trayIcon.QsWindow.window
            anchor.item: trayIcon
            anchor.rect.y: trayIcon.height
          }
        }
      }
    }
  }

  // fixed toggle icon — stays in place
  Icon {
    id: toggleIcon
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter

    text: root.expanded ? "chevron_right" : "chevron_left"
    font.pixelSize: 16
    color: Theme.m3primary

    MouseArea {
      anchors.fill: parent
      onClicked: root.expanded = !root.expanded
    }
  }
}
