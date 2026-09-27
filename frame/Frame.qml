// Frame.qml
import Quickshell
import QtQuick

PanelWindow {
  property bool anchorLeft: true
  property bool anchorRight: true
  property bool anchorTop: true
  property bool anchorBottom: true

  property int thickness: 5
  property int hoverWidth: thickness
  property int hoverHeight: thickness

  property color frameColor: "black"
  property bool hovered: false

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
    id: contentContainer
    anchors.fill: parent
  }

  default property alias content: contentContainer.data

}
