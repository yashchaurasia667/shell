import Quickshell
import QtQuick

import ".."

PanelWindow {
  id: root

  property real radius: 10
  property color cornerColor: Theme.c_background
  property bool mirrorX: false
  property bool mirrorY: false

  implicitWidth: radius
  implicitHeight: radius

  color: "transparent"

  ConcaveCornerShape {
    anchors.fill: parent
    radius: root.radius
    cornerColor: root.cornerColor
    mirrorX: root.mirrorX
    mirrorY: root.mirrorY
  }
}
