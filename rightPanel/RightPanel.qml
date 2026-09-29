// rightPanel/RightPanel.qml
import Quickshell
import QtQuick

import QtQuick.Layouts
import QtQuick.Shapes

import "../components"
import "../services"

PanelWindow {
  id: root

  // Set this from shell.qml: triggerHovered: leftFrame.hovered || hotCorner.hovered
  property bool triggerHovered: false
  property int panelThickness: 440
  property int curveDepth: 30

  // ── Window setup ──────────────────────────────────────────────────────────
  anchors.right: true
  anchors.top: true
  anchors.bottom: true

  exclusiveZone: 0
  aboveWindows: true
  color: "transparent"

  implicitWidth: panelThickness
  visible: false

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

  HoverHandler { id: panelHover }

  // ── Sliding container ─────────────────────────────────────────────────────
  Item {
    id: slider
    width: parent.width
    height: parent.height

    x: root._isOpen ? 0 : root.implicitWidth

    Behavior on x {
      NumberAnimation {
        id: slideAnim
        duration: 280
        easing.type: Easing.OutCubic
      }
    }

    // Panel background — flush left, rounded right edge only
    Shape {
      id: bg
      anchors.fill: parent

      ShapePath {
        fillColor: "black"
        strokeColor: "black"

        startX: root.width
        startY: 0

        PathLine {
          x: 0
          y: 0
        }

        PathCubic {
          x: root.curveDepth
          y: root.curveDepth

          control1X: curveDepth
          control1Y: 0

          control2X: root.curveDepth
          control2Y: root.curveDepth
        }

        PathLine {
          x: root.curveDepth
          y: root.height - root.curveDepth
        }

        PathCubic {
          x: 0
          y: root.height

          control1X: root.curveDepth
          control1Y: root.height - root.curveDepth

          control2X: root.curveDepth
          control2Y: root.height 
        }

        PathLine {
          x: root.width
          y: root.height
        }
        PathLine {
          x: root.width
          y: 0
        }
      }
    }

    // ── Content ───────────────────────────────────────────────────────────
    ColumnLayout {
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right

      anchors.leftMargin: root.curveDepth + 16
      anchors.rightMargin: 16
      anchors.topMargin: 20
      anchors.bottomMargin: 20

      spacing: 16

      NotificationPanel {
        id: notifPanel
        Layout.fillWidth: true
        Layout.fillHeight: true
        dnd: controlCenter.dnd
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
