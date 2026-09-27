// Frame.qml
import Quickshell
import QtQuick

PanelWindow {
  id: root
  property bool anchorLeft: true
  property bool anchorRight: true
  property bool anchorTop: true
  property bool anchorBottom: true

  property int thickness: 5
  property int hoverWidth: thickness+10
  property int hoverHeight: thickness+400

  property color frameColor: "black"
  property bool hovered: hoverHandler.hovered

  anchors {
    top: anchorTop
    bottom: anchorBottom
    left: anchorLeft
    right: anchorRight
  }

  implicitHeight: thickness 
  implicitWidth: thickness

  color: frameColor

  Item {
    id: hoverArea
    width: root.hoverWidth
    height: root.hoverHeight

    anchors.fill: parent
    anchors.verticalCenter: parent.verticalCenter

    HoverHandler {
      id: hoverHandler
    }
  }

  Item {
    id: contentContainer
    anchors.fill: parent
  }

  default property alias content: contentContainer.data

}
