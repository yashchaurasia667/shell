import QtQuick
import Quickshell.Io

Rectangle {
  id: root
  property int hPadding: 8
  property int vPadding: 2

  implicitWidth: label.implicitWidth + hPadding * 2
  implicitHeight: 28

  radius: root.height / 2
  color: "#313244"

  property real usage: 0
  property int temp: 0

  // for delta calculation
  property real _prevIdle: 0
  property real _prevTotal: 0

  Process {
    id: statProc
    command: ["bash", "-c", "head -1 /proc/stat"]
    stdout: SplitParser {
      onRead: data => {
        const p = data.trim().split(/\s+/).slice(1).map(Number)
        const idle  = p[3] + p[4]          // idle + iowait
        const total = p.reduce((a, b) => a + b, 0)
        if (root._prevTotal > 0) {
          const di = idle  - root._prevIdle
          const dt = total - root._prevTotal
          root.usage = Math.round((1 - di / dt) * 100)
        }
        root._prevIdle  = idle
        root._prevTotal = total
      }
    }
  }

  Process {
    id: tempProc
    command: ["bash", "-c", "cat /sys/class/thermal/thermal_zone0/temp"]
    stdout: SplitParser {
      onRead: data => { root.temp = Math.round(parseInt(data.trim()) / 1000) }
    }
  }

  function refresh() { statProc.running = true; tempProc.running = true }

  Timer { interval: 2000; running: true; repeat: true; onTriggered: root.refresh() }
  Component.onCompleted: root.refresh()

  Text {
    id: label
    anchors.centerIn: parent
    anchors.rightMargin: hPadding
    color: "white"
    font.pixelSize: 12
    text: `${root.usage}%   | ${root.temp}°C `
  }
}
