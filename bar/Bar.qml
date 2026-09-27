import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Hyprland

import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "./right" as Right

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

    Clock {
      anchors.centerIn: parent
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
}

