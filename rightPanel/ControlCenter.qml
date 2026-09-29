// leftPanel/ControlCenter.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "../components"
import "../services"

Item {
  id: root
  implicitHeight: col.implicitHeight

  // Exposed so LeftPanel can read and pass to NotificationPanel
  property bool dnd: false

  // ── WiFi state ────────────────────────────────────────────────────────────
  property bool wifiEnabled: false

  Process {
    id: wifiCheckProc
    command: ["bash", "-c", "nmcli radio wifi 2>/dev/null"]
    running: true
    stdout: SplitParser {
      onRead: data => { root.wifiEnabled = data.trim() === "enabled" }
    }
  }

  Process {
    id: wifiToggleProc
    onExited: wifiCheckProc.running = true   // re-check after toggle
  }

  Timer {
    interval: 10000; running: true; repeat: true
    onTriggered: wifiCheckProc.running = true
  }

  function toggleWifi() {
    wifiEnabled = !wifiEnabled  // optimistic update for snappy feel
    wifiToggleProc.command = ["nmcli", "radio", "wifi", wifiEnabled ? "on" : "off"]
    wifiToggleProc.running = true
  }

  // ── Layout ────────────────────────────────────────────────────────────────
  ColumnLayout {
    id: col
    anchors { left: parent.left; right: parent.right; top: parent.top }
    spacing: 14

    // Header
    Text {
      text: "Control Center"
      color: "#cdd6f4"
      font.pixelSize: 14
      font.bold: true
    }

    // Toggle tiles row
    RowLayout {
      Layout.fillWidth: true
      spacing: 10

      // WiFi tile
      ToggleTile {
        Layout.fillWidth: true
        icon: root.wifiEnabled ? "󰤨" : "󰤭"
        label: "Wi-Fi"
        active: root.wifiEnabled
        onToggled: root.toggleWifi()
      }

      // Do Not Disturb tile
      ToggleTile {
        Layout.fillWidth: true
        icon: root.dnd ? "󰂛" : "󰂚"
        label: "Do Not Disturb"
        active: root.dnd
        onToggled: root.dnd = !root.dnd
      }
    }

    // Sliders row
    ColumnLayout {
      Layout.fillWidth: true
      // Layout.alignment: Qt.AlignHCenter
      spacing: 20

      Slider {
        icon: AudioService.muted ? "󰖁" : "󰕾"
        value: AudioService.volume
        orientation: Qt.Horizontal
        Layout.fillWidth: true
        onMoved: pos => AudioService.setVolume(pos)
      }

      Slider {
        icon: "󰃝"
        value: BrightnessService.value
        orientation: Qt.Horizontal
        Layout.fillWidth: true
        onMoved: pos => BrightnessService.setBrightness(pos)
      }
    }
  }
}
