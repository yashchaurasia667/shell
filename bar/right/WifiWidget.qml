import QtQuick
import Quickshell.Io

Item {
  id: root
  implicitWidth: label.implicitWidth
  implicitHeight: 36

  property string ssid: ""

  Process {
    id: wifiProc
    command: ["bash", "-c", "iwgetid -r 2>/dev/null || echo ''"]
    stdout: SplitParser {
      onRead: data => { root.ssid = data.trim() }
    }
    running: true
  }

  Timer { interval: 5000; running: true; repeat: true; onTriggered: wifiProc.running = true }

  Text {
    id: label
    anchors.centerIn: parent
    font.pixelSize: 12
    color: root.ssid !== "" ? "white" : "#6c7086"
    text: root.ssid !== "" ? ` ${root.ssid}` : " --"
  }
}
