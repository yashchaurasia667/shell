// shell.qml
import QtQuick
import QtQuick.Layouts
import Quickshell

import "./bar"
import "./frame"
import "./components"
import "./services"

ShellRoot {

  Variants {
    model: Quickshell.screens
    Bar {}
  }

  // bottom
  Frame {
    anchorTop: false
  }
  // left
  Frame {
    anchorRight: false
  }

  // right
  Frame {
    id: rightFrame
    anchorLeft: false
    thickness: 5
  }
  SidePanel {
    id: volumeControl
    triggerHovered: rightFrame.hovered
    edge: Qt.RightEdge

    curveDepth: 15
    cornerRadius: 25

    ColumnLayout {
      anchors.fill: parent
      spacing: 12

      Item {Layout.fillHeight: true}
      Slider { 
        icon: AudioService.muted ? "󰖁" : "󰕾" 
        Layout.alignment: Qt.AlignHCenter
        value: AudioService.volume
        onMoved: position => {
          AudioService.setVolume(position)
        }
      }

      Slider { 
        icon: "󰃝" 
        Layout.alignment: Qt.AlignHCenter
        value: BrightnessService.value
        onMoved: position => {
          BrightnessService.setBrightness(position)
        }
      }
      Item {Layout.fillHeight: true}
    }
  }

  // concave corners
  ConcaveCorner {
    anchors {
      top: true
      left: true
    }
  }
  ConcaveCorner {
    anchors {
      top: true
      right: true
    }
    mirrorX: true
  }
  ConcaveCorner {
    anchors {
      bottom: true
      right: true
    }
    mirrorX: true
    mirrorY: true
  }
  ConcaveCorner {
    anchors {
      bottom: true
      left: true
    }
    mirrorY: true
  }
}
