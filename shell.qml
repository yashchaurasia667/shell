import QtQuick
import QtQuick.Layouts
import Quickshell

import "./bar"
import "./frame"
import "./components"

ShellRoot {
  // Singleton {}

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
    anchorLeft: false
    thickness: 5

    PanelWindow {
      anchors.right: true

      exclusiveZone: 0
      aboveWindows: true

      implicitWidth: 50
      implicitHeight: 350

      color: "transparent"

      Rectangle {
        anchors.fill: parent
        color: "black"
        radius: 10

        ColumnLayout {
          anchors.fill: parent
          spacing: 12

          Item {Layout.fillHeight: true}
          Slider { 
            icon: "󰕾" 
            Layout.alignment: Qt.AlignHCenter
          }
          Slider { 
            icon: "󰃝" 
            Layout.alignment: Qt.AlignHCenter
          }
          Item {Layout.fillHeight: true}
        }
      }
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
