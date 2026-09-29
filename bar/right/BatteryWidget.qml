import QtQuick
import Quickshell.Io

Item {
  id: root
  implicitWidth: label.implicitWidth
  implicitHeight: 36

  property int    cap:    0
  property string status: "Unknown"

  // change BAT1 to BAT0 if needed
  Process {
    id: capProc
    command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
    stdout: SplitParser {
      onRead: data => { root.cap = parseInt(data.trim()) || 0 }
    }
  }

  Process {
    id: statusProc
    command: ["cat", "/sys/class/power_supply/BAT1/status"]
    stdout: SplitParser {
      onRead: data => { root.status = data.trim() }
    }
  }

  function refresh() {
    capProc.running = true
    statusProc.running = true
  }

  Timer { interval: 10000; running: true; repeat: true; onTriggered: root.refresh() }
  Component.onCompleted: root.refresh()

  function icon() {
    if (root.status === "Charging") return "󱐋"
    if(root.status >= 90) return ""
    if (root.cap >= 80) return ""
    if (root.cap >= 50) return ""
    if (root.cap >= 20) return ""
    return ""
  }

  Text {
    id: label
    anchors.centerIn: parent
    font.pixelSize: 12
    color: root.cap <= 15 && root.status !== "Charging" ? "#f38ba8" : "white"
    text: `${root.icon()}  ${root.cap}%`
  }
}
