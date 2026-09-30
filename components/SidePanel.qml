// SidePanel.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects

import ".."

PanelWindow {
  id: root

  property int edge: Qt.RightEdge

  anchors.right: edge === Qt.RightEdge
  anchors.left: edge === Qt.LeftEdge
  anchors.top: edge === Qt.TopEdge
  anchors.bottom: edge === Qt.BottomEdge

  exclusiveZone: 0
  aboveWindows: true

  property int panelThickness: 50
  property int panelLength: 380
  property int shadowSize: 20

  property int curveDepth: 40 
  property int cornerRadius: 20

  property alias slideAnimation: xAnim

  visible: false
  property bool triggerHovered: false
  property bool _isHovered: triggerHovered || panelHoverHandler.hovered

  on_IsHoveredChanged: {
    if (_isHovered) {
      hideTimer.stop()
      root.visible = true
    } else {
      hideTimer.restart()
    }
  }

  Timer {
    id: hideTimer
    interval: xAnim.duration + 50
    onTriggered: root.visible = false
  }

  property bool isHorizontal: edge === Qt.TopEdge || edge === Qt.BottomEdge

  // Window expands by shadowSize on all 3 exposed sides
  implicitWidth: isHorizontal ? (panelLength + shadowSize * 2) : (panelThickness + shadowSize)
  implicitHeight: isHorizontal ? (panelThickness + shadowSize) : (panelLength + shadowSize * 2)

  color: "transparent"

  mask: Region {
    item: contentContainer
  }

  default property alias content: contentContainer.data

  Item {
    id: slidingContainer
    width: parent.width
    height: parent.height

    x: {
      if (root._isHovered) return 0;
      if (root.edge === Qt.RightEdge) return (root.panelThickness + root.shadowSize);
      if (root.edge === Qt.LeftEdge) return -(root.panelThickness + root.shadowSize);
      return 0;
    }

    y: {
      if (root._isHovered) return 0;
      if (root.edge === Qt.BottomEdge) return (root.panelThickness + root.shadowSize);
      if (root.edge === Qt.TopEdge) return -(root.panelThickness + root.shadowSize);
      return 0;
    }

    Behavior on x {
      NumberAnimation {
        id: xAnim
        duration: 250
        easing.type: Easing.OutCubic
      }
    }

    Behavior on y {
      NumberAnimation {
        duration: xAnim.duration
        easing.type: xAnim.easing.type
      }
    }

    // Outer tab bounds positioned flush against the attached screen edge
    Item {
      id: tabContainer
      width: root.isHorizontal ? root.panelLength : root.panelThickness
      height: root.isHorizontal ? root.panelThickness : root.panelLength

      anchors.right: root.edge === Qt.RightEdge ? parent.right : undefined
      anchors.left: root.edge === Qt.LeftEdge ? parent.left : undefined
      anchors.top: root.edge === Qt.TopEdge ? parent.top : undefined
      anchors.bottom: root.edge === Qt.BottomEdge ? parent.bottom : undefined
      anchors.horizontalCenter: root.isHorizontal ? parent.horizontalCenter : undefined
      anchors.verticalCenter: !root.isHorizontal ? parent.verticalCenter : undefined

      Item {
        id: shapeWrapper
        width: root.panelThickness
        height: root.panelLength
        anchors.centerIn: parent

        rotation: {
          if (root.edge === Qt.TopEdge) return -90
          if (root.edge === Qt.BottomEdge) return 90
          if (root.edge === Qt.LeftEdge) return 180
          return 0
        }

        Shape {
          id: tabShape
          anchors.fill: parent
          layer.enabled: true
          layer.samples: 4

          // MultiEffect generates a drop shadow conforming to tabShape's organic curve on all 3 exposed sides.
          // shadowHorizontalOffset: -8 shifts the shadow away from the screen edge so no shadow bleeds off-screen.
          layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.45)
            shadowBlur: 0.6
            shadowHorizontalOffset: -8
            shadowVerticalOffset: 0
          }

          ShapePath {
            fillColor: Theme.c_background
            strokeColor: Theme.c_primary
            strokeWidth: 0

            startX: root.panelThickness
            startY: 0

            PathCubic {
              x: root.panelThickness - root.cornerRadius
              y: root.cornerRadius
              control1X: root.panelThickness; control1Y: 0
              control2X: root.panelThickness; control2Y: root.curveDepth
            }

            PathLine { x: root.cornerRadius; y: root.cornerRadius }

            PathCubic {
              x: 0; y: root.cornerRadius * 2
              control1X: root.cornerRadius * 0.5; control1Y: root.cornerRadius
              control2X: 0; control2Y: root.cornerRadius * 1.5
            }

            PathLine { x: 0; y: root.panelLength - (root.cornerRadius * 2) }

            PathCubic {
              x: root.cornerRadius; y: root.panelLength - root.cornerRadius
              control1X: 0; control1Y: root.panelLength - (root.cornerRadius * 1.5)
              control2X: root.cornerRadius * 0.5; control2Y: root.panelLength - root.cornerRadius
            }

            PathLine { x: root.panelThickness - root.cornerRadius; y: root.panelLength - root.cornerRadius }

            PathCubic {
              x: root.panelThickness; y: root.panelLength
              control1X: root.panelThickness; control1Y: root.panelLength - root.curveDepth
              control2X: root.panelThickness; control2Y: root.panelLength
            }
          }
        }
      }

      Item {
        id: contentContainer
        anchors.fill: parent

        HoverHandler {
          id: panelHoverHandler
        }
      }
    }
  }
}
