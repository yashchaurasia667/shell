// SidePanel.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

PanelWindow {
  id: root
  anchors.right: true

  exclusiveZone: 0
  aboveWindows: true

  property int panelWidth: 50
  property int panelHeight: 380

  property int curveDepth: 40 
  property int cornerRadius: 20

  property alias slideAnimation: slideAnim

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
    interval: slideAnim.duration 
    onTriggered: root.visible = false
  }

  implicitWidth: panelWidth
  implicitHeight: panelHeight

  color: "transparent"

  default property alias content: contentContainer.data

  HoverHandler {
    id: panelHoverHandler
  }

  Item {
    id: slidingContainer
    width: parent.width
    height: parent.height

    x: root._isHovered ? 0 : root.panelWidth

    Behavior on x {
      NumberAnimation {
        id: slideAnim
        duration: 150
        easing.type: Easing.OutCubic
      }
    }

    Item {
      id: backgroundContainer
      anchors.fill: parent

      Shape {
        id: tabShape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4

        ShapePath {
          fillColor: "black"
          strokeColor: "transparent"

          startX: root.panelWidth
          startY: 0

          // top concave thingy
          PathCubic {
            x: root.cornerRadius
            y: root.cornerRadius

            control1X: root.panelWidth
            control1Y: 0

            control2X: root.panelWidth
            control2Y: root.curveDepth
          }

          PathLine { x: root.cornerRadius; y: root.cornerRadius }

          //  top rouned corner
          PathCubic {
            x: 0
            y: root.cornerRadius * 2
            control1X: root.cornerRadius * 0.5; control1Y: root.cornerRadius
            control2X: 0; control2Y: root.cornerRadius * 1.5
          }

          // straight down
          PathLine { x: 0; y: root.panelHeight - (root.cornerRadius * 2) }

          // bottom round corner
          PathCubic {
            x: root.cornerRadius
            y: root.panelHeight - root.cornerRadius
            control1X: 0; control1Y: root.panelHeight - (root.cornerRadius * 1.5)
            control2X: root.cornerRadius * 0.5; control2Y: root.panelHeight - root.cornerRadius
          }

          PathLine { x: root.panelWidth - root.cornerRadius; y: root.panelHeight - root.cornerRadius }

          // bottom concave thingy
          PathCubic {
            x: root.panelWidth
            y: root.panelHeight

            control1X: root.panelWidth
            control1Y: root.panelHeight - root.curveDepth

            control2X: root.panelWidth
            control2Y: root.panelHeight
          }
        }
      }

      Item {
        id: contentContainer
        anchors.fill: parent
      }
    }
  }
}
