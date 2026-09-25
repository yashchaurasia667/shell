import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts

import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "./right" as Right

PanelWindow {
  id: bar

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
    anchors.leftMargin: 8
    anchors.rightMargin: 8

    Workspaces {
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
    }

    Clock {
      anchors.centerIn: parent
    }

    RowLayout {
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      Right.Tray {}
      Right.CpuWidget {}
      Right.WifiWidget {}
      Right.VolumeWidget {}
      Right.BatteryWidget {}
    }
  }
}

