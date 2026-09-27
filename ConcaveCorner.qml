import Quickshell
import QtQuick
import QtQuick.Shapes

PanelWindow {
  id: root

  property real radius: 10
  property color cornerColor: "black"

  property bool mirrorX: false
  property bool mirrorY: false

  implicitWidth: radius
  implicitHeight: radius

  color: "transparent"

  Shape {
    id: shape

    anchors.fill: parent

    transform: Scale {
      origin.x: root.radius / 2
      origin.y: root.radius / 2

      xScale: root.mirrorX ? -1 : 1
      yScale: root.mirrorY ? -1 : 1
    }

    ShapePath {
      fillColor: root.cornerColor
      strokeWidth: 0

      startX: 0
      startY: 0

      PathLine {
        x: root.radius
        y: 0
      }

      PathCubic {
        x: 0
        y: root.radius

        control1X: root.radius * 0.4477152
        control1Y: 0

        control2X: 0
        control2Y: root.radius * 0.4477152
      }

      PathLine {
        x: 0
        y: 0
      }
    }
  }
}
