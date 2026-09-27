import Quickshell
import QtQuick
import QtQuick.Layouts

import "../components"

PanelWindow {
  id: root

  property bool expanded: false

  property int panelWidth: 40
  property int collapsedWidth: 5
  property int panelHeight: 180

  property color panelColor: "#F8F4EA"

  anchors {
    right: true
  }

  implicitWidth: panelWidth
  implicitHeight: panelHeight

  color: "transparent"

  // Keep the panel attached to the right edge.
  margins.right: 0

  Rectangle {
    id: panel

    width: root.panelWidth
    height: root.panelHeight

    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right

    color: root.panelColor

    radius: 20

    x: root.expanded
       ? 0
       : root.panelWidth - root.collapsedWidth

    Behavior on x {
      NumberAnimation {
        duration: 180
        easing.type: Easing.OutCubic
      }
    }

    ColumnLayout {
      anchors.fill: parent

      anchors.topMargin: 10
      anchors.bottomMargin: 10
      anchors.leftMargin: 3
      anchors.rightMargin: 3

      spacing: 12

      Item {
        Layout.fillHeight: true
      }

      Slider {
        icon: "󰕾"

        Layout.alignment: Qt.AlignHCenter
      }

      Slider {
        icon: "󰃝"

        Layout.alignment: Qt.AlignHCenter
      }

      Item {
        Layout.fillHeight: true
      }
    }

    HoverHandler {
      onHoveredChanged: {
        if (hovered)
          root.expanded = true
        else
          root.expanded = false
      }
    }
  }

  // Invisible 5px trigger at the screen edge.
  MouseArea {
    id: trigger

    anchors {
      right: parent.right
      top: parent.top
      bottom: parent.bottom
    }

    width: root.collapsedWidth

    hoverEnabled: true

    onEntered: {
      root.expanded = true
    }
  }
}
