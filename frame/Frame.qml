// Frame.qml
import Quickshell
import QtQuick
import ".."

PanelWindow {
  id: root
  property bool anchorLeft: true
  property bool anchorRight: true
  property bool anchorTop: true
  property bool anchorBottom: true

  property int thickness: 1
  property int shadowSize: 5
  property int hoverWidth: thickness + 10
  property int hoverHeight: thickness + 400

  property color frameColor: Theme.c_background
  property bool hovered: hoverHandler.hovered

  // Edge detection: which screen edge is this frame on?
  readonly property bool isBottom: !anchorTop && anchorBottom
  readonly property bool isTop: anchorTop && !anchorBottom
  readonly property bool isLeft: anchorLeft && !anchorRight
  readonly property bool isRight: !anchorLeft && anchorRight
  readonly property bool isHorizontal: isBottom || isTop

  anchors {
    top: anchorTop
    bottom: anchorBottom
    left: anchorLeft
    right: anchorRight
  }

  // Window expands only inward by shadowSize to accommodate the drop shadow
  implicitHeight: isHorizontal ? (thickness + shadowSize) : 0
  implicitWidth: !isHorizontal ? (thickness + shadowSize) : 0

  exclusiveZone: thickness

  color: "transparent"

  mask: Region {
    item: interactiveArea
  }

  // frame bar 
  Rectangle {
    id: visibleFrame
    color: frameColor

    anchors.left: isRight ? undefined : parent.left
    anchors.right: isLeft ? undefined : parent.right
    anchors.top: isBottom ? undefined : parent.top
    anchors.bottom: isTop ? undefined : parent.bottom

    width: isHorizontal ? parent.width : root.thickness
    height: isHorizontal ? root.thickness : parent.height
  }

  // drop shadow 
  Rectangle {
    id: shadow

    anchors.left: isLeft ? visibleFrame.right : (isRight ? undefined : parent.left)
    anchors.right: isRight ? visibleFrame.left : (isLeft ? undefined : parent.right)
    anchors.top: isTop ? visibleFrame.bottom : (isBottom ? undefined : parent.top)
    anchors.bottom: isBottom ? visibleFrame.top : (isTop ? undefined : parent.bottom)

    width: isHorizontal ? parent.width : root.shadowSize
    height: isHorizontal ? root.shadowSize : parent.height

    gradient: Gradient {
      orientation: isHorizontal ? Gradient.Vertical : Gradient.Horizontal

      GradientStop {
        position: (isBottom || isRight) ? 1.0 : 0.0
        color: Theme.c_shadow
      }
      GradientStop {
        position: (isBottom || isRight) ? 0.0 : 1.0
        color: "transparent"
      }
    }
  }

  // hover detection and click passing
  Item {
    id: interactiveArea
    anchors.left: isRight ? undefined : parent.left
    anchors.right: isLeft ? undefined : parent.right
    anchors.top: isBottom ? undefined : parent.top
    anchors.bottom: isTop ? undefined : parent.bottom

    width: isHorizontal ? parent.width : root.hoverWidth
    height: isHorizontal ? root.hoverHeight : parent.height

    HoverHandler {
      id: hoverHandler
    }
  }

  Item {
    id: contentContainer
    anchors.fill: visibleFrame
  }

  default property alias content: contentContainer.data
}
