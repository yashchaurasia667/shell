import QtQuick
import Quickshell.Io

Item {
  id: root
  implicitWidth: icon.implicitWidth
  implicitHeight: 36

  property string ssid: ""
  property bool connected: ssid !== ""

  Process {
    id: wifiProc
    // iwgetid not available on all systems; nmcli is reliable with NetworkManager
    command: ["bash", "-c", "nmcli -t -f active,ssid dev wifi 2>/dev/null | sed -n 's/^yes://p' | head -1"]
    stdout: SplitParser {
      onRead: data => { root.ssid = data.trim() }
    }
    running: true
  }

  Timer { interval: 5000; running: true; repeat: true; onTriggered: wifiProc.running = true }

  HoverHandler { id: hoverHandler }

  Text {
    id: icon
    anchors.centerIn: parent
    font.pixelSize: 14
    color: root.connected ? "white" : "#6c7086"
    text: root.connected ? "" : "󰖪"
  }

  // SSID tooltip shown on hover
  // Text {
  //   visible: hoverHandler.hovered && root.connected
  //   text: root.ssid
  //   color: "white"
  //   font.pixelSize: 11
  //
  //   parent: root.parent
  //   x: root.x + root.width / 2 - width / 2
  //   y: root.y - height - 6
  //
  //   Rectangle {
  //     anchors.fill: parent
  //     anchors.margins: -5
  //     z: -1
  //     color: "#1e1e2e"
  //     radius: 4
  //   }
  // }
}
