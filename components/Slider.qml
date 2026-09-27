// Slider.qml
import QtQuick
import Qt5Compat.GraphicalEffects

Item {
  id: root

  property real value: 0.5
  property real _position: value
  property int orientation: Qt.Vertical

  property string icon: "󰕾"
  property string iconFont: "Symbols Nerd Font"

  property color trackColor: "#F8EDED"
  property color fillColor: "#6B564C" 
  property color handleColor: "#292624"
  property color iconColor: "#FFFFFF"

  property int trackThickness: 34
  property int sliderLength: 150
  property int handleSize: 36

  property int valueDisplayDuration: 500
  property bool showValueOnMove: true

  signal moved(real position)
  signal dragStarted()
  signal dragEnded()

  implicitWidth: orientation === Qt.Vertical ? handleSize : sliderLength
  implicitHeight: orientation === Qt.Vertical ? sliderLength : handleSize

  on_PositionChanged: {
    if (showValueOnMove) {
      valueTimer.restart()
    }
  }

  onValueChanged: {
    if (!mouseArea.pressed) {
      _position = value
    }
  }

  Behavior on _position {
    enabled: !mouseArea.pressed
    NumberAnimation {
      duration: 150
      easing.type: Easing.OutQuad
    }
  }

  Timer {
    id: valueTimer
    interval: root.valueDisplayDuration
  }

  Item {
    id: trackContainer
    width: root.orientation === Qt.Vertical ? root.trackThickness : parent.width
    height: root.orientation === Qt.Vertical ? parent.height : root.trackThickness
    anchors.centerIn: parent

    Rectangle {
      id: trackBg
      anchors.fill: parent
      radius: Math.min(width, height) / 2
      color: root.trackColor
    }

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
        ? parent.width * root._position
        : parent.width

        height: root.orientation === Qt.Vertical
        ? parent.height * root._position
        : parent.height
      }
    }

    Rectangle {
      id: maskShape
      anchors.fill: parent
      radius: Math.min(width, height) / 2
      visible: false
    }

    OpacityMask {
      anchors.fill: parent
      source: fillWrapper
      maskSource: maskShape
    }
  }

  Item {
    id: handleItem
    width: root.handleSize
    height: root.handleSize

    x: root.orientation === Qt.Horizontal
    ? (parent.width - width) * root._position
    : (parent.width - width) / 2

    y: root.orientation === Qt.Vertical
    ? (parent.height - height) * (1 - root._position)
    : (parent.height - height) / 2

    Rectangle {
      id: handle
      anchors.fill: parent
      radius: width / 2
      color: root.handleColor
      visible: false 
    }

    DropShadow {
      anchors.fill: handle
      source: handle
      color: "#66000000"
      horizontalOffset: 0
      verticalOffset: 2
      radius: 8
      samples: 17
    }

    Text {
      anchors.centerIn: parent
      color: root.iconColor
      text: valueTimer.running ? Math.round(root._position * 100) : root.icon
      font.family: valueTimer.running ? "sans-serif" : root.iconFont
      font.pixelSize: valueTimer.running ? 13 : 16
      font.bold: valueTimer.running
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent

    onPressed: mouse => {
      root.dragStarted()
      updatePosition(mouse)
    }

    onReleased: {
      root.dragEnded()
    }

    onPositionChanged: mouse => {
      if (pressed) updatePosition(mouse)
    }

    onWheel: wheel => {
      let step = 0.05 
      let delta = wheel.angleDelta.y > 0 ? step : -step
      let newPos = Math.max(0, Math.min(1, root._position + delta))

      root._position = newPos
      root.moved(newPos)
    }

    function updatePosition(mouse) {
      let calcPos = 0
      if (root.orientation === Qt.Horizontal) {
        let activeWidth = width - root.handleSize
        let adjustedX = mouse.x - (root.handleSize / 2)
        calcPos = Math.max(0, Math.min(1, adjustedX / activeWidth))
      } else {
        let activeHeight = height - root.handleSize
        let adjustedY = mouse.y - (root.handleSize / 2)
        calcPos = Math.max(0, Math.min(1, 1 - (adjustedY / activeHeight)))
      }

      root._position = calcPos 
      root.moved(calcPos)
    }
  }
}
