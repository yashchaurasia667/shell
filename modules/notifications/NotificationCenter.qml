import QtQuick
import QtQuick.Shapes

import Quickshell
import Quickshell.Services.Notifications

import qs.common
import qs.components
import qs.services

PanelWindow {
  id: notifcenter

  anchors {
    top: true
    bottom: true
    right: true
  }

  aboveWindows: false
  exclusiveZone: 0

  implicitWidth: 400 + Global.panelRadius + Global.pad
  // implicitHeight: parent.height
  color: "transparent"

  Shape {
    anchors.fill: parent
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
      startX: 0; startY: 0
      fillRule: ShapePath.OddEvenFill
      fillColor: Theme.m3surface
      // fillColor: "white"
      strokeColor: "transparent"

      PathArc {
        x: Global.panelRadius; y: Global.panelRadius
        radiusX: Global.panelRadius; radiusY: Global.panelRadius
      }

      PathLine { x: Global.panelRadius; y: notifcenter.height - Global.panelRadius }

      PathArc {
        x: 0; y: notifcenter.height
        radiusX: Global.panelRadius; radiusY: Global.panelRadius
      }

      PathLine { x: notifcenter.width; y: notifcenter.height }
      PathLine { x: notifcenter.width; y: 0 }
    }
  }
}
