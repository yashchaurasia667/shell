// bar/Bar.qml
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Hyprland

import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../"
import "../components" 
import "./right" as Right

PanelWindow {
  id: bar
  property var modelData

  property int barHeight: 35
  property int shadowSize: 5

  anchors {
    top: true
    left: true
    right: true
  }

  color: "transparent"
  implicitHeight: barHeight + shadowSize
  exclusiveZone: barHeight

  mask: Region {
    item: barBackground
  }

  Rectangle {
    id: barBackground

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    height: bar.barHeight
    color: Theme.c_background

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

        Right.Tray { panelWindow: bar }
        Right.VolumeWidget {}
        Right.CpuWidget {}
        Right.WifiWidget {}
        Right.BatteryWidget {}
      }
    }
  }

  // Downward shadow towards center of screen
  Rectangle {
    id: barShadow
    anchors.top: barBackground.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: bar.shadowSize
    gradient: Gradient {
      orientation: Gradient.Vertical
      GradientStop { position: 0.0; color: Theme.c_shadow }
      // GradientStop { position: 0.25; color: Qt.rgba(0, 0, 0, 0.22) }
      // GradientStop { position: 0.60; color: Qt.rgba(0, 0, 0, 0.07) }
      GradientStop { position: 1.0; color: "transparent" }
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
