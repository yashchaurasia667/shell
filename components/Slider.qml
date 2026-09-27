import QtQuick
import Qt5Compat.GraphicalEffects

Item {
  id: root

  property real value: 0.5
  property int orientation: Qt.Vertical

  property string icon: "󰕾"
  property string iconFont: "Symbols Nerd Font"

  property color trackColor: "#F8EDED"
  property color fillColor: "#806A60"
  property color handleColor: "#292624"
  property color iconColor: "#FFFFFF"

  property int handleSize: 34

  implicitWidth: orientation === Qt.Vertical ? handleSize : 150
  implicitHeight: orientation === Qt.Vertical ? 150 : handleSize

  Rectangle {
    id: track
    anchors.fill: parent
    radius: Math.min(width, height) / 2
    color: root.trackColor
  }

  // 2. A wrapper for the fill that matches the exact size of the track.
  // This preserves your anchor positioning inside the mask.
  Item {
    id: fillWrapper
    anchors.fill: parent
    visible: false 

    Rectangle {
      id: fill
      color: root.fillColor

      anchors {
        left: root.orientation === Qt.Horizontal ? parent.left : undefined
        right: root.orientation === Qt.Horizontal ? undefined : parent.right
        bottom: root.orientation === Qt.Vertical ? parent.bottom : undefined
      }

      width: root.orientation === Qt.Horizontal
             ? parent.width * root.value
             : parent.width

      height: root.orientation === Qt.Vertical
              ? parent.height * root.value
              : parent.height
    }
  }

  // 3. A dedicated, hidden shape to act as the mask alpha-channel
  Rectangle {
    id: maskShape
    anchors.fill: parent
    radius: Math.min(width, height) / 2
    visible: false
  }

  // 4. The effect that clips the fillWrapper to the maskShape
  OpacityMask {
    anchors.fill: parent
    source: fillWrapper
    maskSource: maskShape
  }

  // 5. The handle (drawn on top)
  Rectangle {
    id: handle

    width: root.handleSize
    height: root.handleSize
    radius: width / 2
    color: root.handleColor

    x: root.orientation === Qt.Horizontal
       ? (parent.width - width) * root.value
       : (parent.width - width) / 2

    y: root.orientation === Qt.Vertical
       ? (parent.height - height) * (1 - root.value)
       : (parent.height - height) / 2

    Text {
      anchors.centerIn: parent

      text: root.icon
      color: root.iconColor

      font.family: root.iconFont
      font.pixelSize: 15
    }
  }

  // 6. The MouseArea
  MouseArea {
    anchors.fill: parent

    onPressed: mouse => {
      updateValue(mouse)
    }

    onPositionChanged: mouse => {
      if (pressed)
        updateValue(mouse)
    }

    function updateValue(mouse) {
      if (root.orientation === Qt.Horizontal) {
        root.value = Math.max(
          0,
          Math.min(1, mouse.x / width)
        )
      } else {
        root.value = Math.max(
          0,
          Math.min(1, 1 - mouse.y / height)
        )
      }
    }
  }
}
