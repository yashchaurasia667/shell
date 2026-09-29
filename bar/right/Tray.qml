import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
  id: root

  // The containing PanelWindow — must be passed in from Bar.qml
  // QsMenuAnchor requires the Quickshell window object, not Window.window
  property var panelWindow: null
  property int hPadding: 4
  property int vPadding: 4
  color: "#313244"

  implicitWidth: trayIcon.implicitWidth + (expanded ? trayItems.implicitWidth + 6 : 0) + hPadding * 2
  implicitHeight: 18 + vPadding * 2

  radius: root.height / 2
  clip: true

  property bool expanded: false
  property bool _anyHovered: trayHover.hovered || itemsHover.hovered

  on_AnyHoveredChanged: {
    if (_anyHovered) {
      hideTimer.stop()
      expanded = true
    } else {
      hideTimer.restart()
    }
  }

  Timer {
    id: hideTimer
    interval: 150
    repeat: false
    onTriggered: root.expanded = false
  }

  Behavior on implicitWidth {
    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
  }

  // Tray items — expands leftward from the trigger icon
  RowLayout {
    id: trayItems
    anchors.right: trayIcon.left
    anchors.leftMargin: hPadding
    anchors.rightMargin: 6
    anchors.verticalCenter: parent.verticalCenter

    spacing: 4
    implicitHeight: 18

    HoverHandler { id: itemsHover }

    Repeater {
      model: SystemTray.items
      delegate: Item {
        id: delegateItem
        required property SystemTrayItem modelData
        width: 18; height: 18
        Layout.alignment: Qt.AlignVCenter

        // QsMenuAnchor is the correct Quickshell API for opening tray context menus
        QsMenuAnchor {
          id: menuAnchor
          anchor.window: root.panelWindow
          menu: delegateItem.modelData.menu
          anchor.rect: {
            let pos = delegateItem.mapToItem(null, 0, 0)
            return Qt.rect(pos.x, pos.y, delegateItem.width, delegateItem.height)
          }
        }

        Image {
          anchors.fill: parent
          source: delegateItem.modelData.icon
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: mouse => {
            if (mouse.button === Qt.RightButton && delegateItem.modelData.hasMenu)
              menuAnchor.open()
            else
              delegateItem.modelData.activate()
          }
        }
      }
    }
  }

  // Trigger icon — always visible
  Text {
    id: trayIcon
    anchors.right: parent.right
    anchors.rightMargin: hPadding
    anchors.verticalCenter: parent.verticalCenter
    font.pixelSize: 14
    color: "white"
    text: "󱊖"

    HoverHandler { id: trayHover }
  }
}
