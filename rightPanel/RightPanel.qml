// rightPanel/RightPanel.qml
import Quickshell
import QtQuick

import QtQuick.Layouts
import QtQuick.Shapes

import "../components"
import "../services"

import ".."

PanelWindow {
  id: root

  // Set this from shell.qml: triggerHovered: leftFrame.hovered || hotCorner.hovered
  property bool triggerHovered: false
  property int panelThickness: 440
  property int curveDepth: 30
  property int shadowSize: 5

  // ── Window setup ──────────────────────────────────────────────────────────
  anchors.right: true
  anchors.top: true
  anchors.bottom: true

  exclusiveZone: 0
  aboveWindows: true
  color: "transparent"

  implicitWidth: panelThickness + shadowSize
  visible: false

  mask: Region {
    item: bg
  }

  // ── Show/hide logic ───────────────────────────────────────────────────────
  property bool _isOpen: triggerHovered || panelHover.hovered

  on_IsOpenChanged: {
    if (_isOpen) {
      hideTimer.stop()
      root.visible = true
    } else {
      hideTimer.restart()
    }
  }

  Timer {
    id: hideTimer
    interval: slideAnim.duration + 50
    onTriggered: root.visible = false
  }

  // ── Sliding container ─────────────────────────────────────────────────────
  Item {
    id: slider
    width: root.implicitWidth
    height: parent.height

    x: root._isOpen ? 0 : root.implicitWidth

    Behavior on x {
      NumberAnimation {
        id: slideAnim
        duration: 280
        easing.type: Easing.OutCubic
      }
    }

    HoverHandler { id: panelHover }

    // Drop shadow pointing leftward towards the center of the screen
    Rectangle {
      id: panelShadow
      anchors.right: bg.left
      anchors.rightMargin: -root.curveDepth
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: root.shadowSize
      z: -1

      gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: "transparent" }
        GradientStop { position: 1.0; color: Theme.c_shadow }
      }
    }

    // Panel background — flush right, curved left edge
    Shape {
      id: bg
      anchors.right: parent.right
      width: root.panelThickness
      height: parent.height

      ShapePath {
        fillColor: Theme.c_background
        strokeColor: Theme.c_background

        startX: bg.width
        startY: 0

        PathLine {
          x: 0
          y: 0
        }

        PathCubic {
          x: root.curveDepth
          y: root.curveDepth

          control1X: root.curveDepth
          control1Y: 0

          control2X: root.curveDepth
          control2Y: root.curveDepth
        }

        PathLine {
          x: root.curveDepth
          y: bg.height - root.curveDepth
        }

        PathCubic {
          x: 0
          y: bg.height

          control1X: root.curveDepth
          control1Y: bg.height - root.curveDepth

          control2X: root.curveDepth
          control2Y: bg.height 
        }

        PathLine {
          x: bg.width
          y: bg.height
        }
        PathLine {
          x: bg.width
          y: 0
        }
      }
    }

    // ── Content ───────────────────────────────────────────────────────────
    ColumnLayout {
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: bg.left
      anchors.right: bg.right

      anchors.leftMargin: root.curveDepth + 16
      anchors.rightMargin: 16
      anchors.topMargin: 20
      anchors.bottomMargin: 20

      spacing: 16

      NotificationPanel {
        id: notifPanel
        Layout.fillWidth: true
        Layout.fillHeight: true
      }

      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "#313244"
      }

      ControlCenter {
        id: controlCenter
        Layout.fillWidth: true
        Layout.maximumHeight: root.height * 0.5
      }
    }
  }
}
