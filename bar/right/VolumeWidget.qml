import QtQuick
import Quickshell.Io

Item {
  id: root
  implicitWidth: label.implicitWidth
  implicitHeight: 36

  property int  vol:   0
  property bool muted: false

  Process {
    id: volProc
    // output: "Volume: 0.65" or "Volume: 0.65 [MUTED]"
    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
    stdout: SplitParser {
      onRead: data => {
        const m = data.match(/Volume: ([\d.]+)/)
        if (m) root.vol = Math.round(parseFloat(m[1]) * 100)
        root.muted = data.includes("[MUTED]")
      }
    }
    running: true
  }

  Timer { interval: 1000; running: true; repeat: true; onTriggered: volProc.running = true }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      Process.execute(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
      volProc.running = true
    }
    onWheel: wheel => {
      const dir = wheel.angleDelta.y > 0 ? "5%+" : "5%-"
      Process.execute(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", dir])
      volProc.running = true
    }
  }

  Text {
    id: label
    anchors.centerIn: parent
    font.pixelSize: 12
    color: root.muted ? "#6c7086" : "white"
    text: root.muted ? " --%" : ` ${root.vol}%`
  }
}
