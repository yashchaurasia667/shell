// bar/Bar.qml
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Hyprland

import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "./right" as Right
import "../components" 

PanelWindow {
  id: bar
  property var modelData

  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: 35
  color: "black"
  exclusiveZone: implicitHeight

  Item {
    anchors.fill: parent
    anchors.leftMargin: 14
    anchors.rightMargin: 14

    Workspaces {
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8
    }

    Item {
      id: clockWrapper
      width: clock.width
      height: parent.height
      anchors.centerIn: parent

      Clock {
        id: clock
        anchors.centerIn: parent
      }

      HoverHandler {
        id: clockHoverHandler
      }
    }

    RowLayout {
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      spacing: 12

      Right.Tray {}
      Right.CpuWidget {}
      Right.WifiWidget {}
      Right.VolumeWidget {}
      Right.BatteryWidget {}
    }
  }

  SidePanel {
    id: topDropdown
    edge: Qt.TopEdge
    triggerHovered: clockHoverHandler.hovered

    curveDepth: 20
    cornerRadius: 25

    panelThickness: 350
    panelLength: 1000

    ColumnLayout {
      anchors.fill: parent
      anchors.topMargin: 40
      spacing: 15

      Text {
        text: "Quick Settings & Calendar"
        color: "white"
        font.pixelSize: 18
        Layout.alignment: Qt.AlignHCenter
      }

      Item { Layout.fillHeight: true }
    }
  }
}
