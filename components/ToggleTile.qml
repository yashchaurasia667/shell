// components/ToggleTile.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root

  property string icon: ""
  property string label: ""
  property bool active: false

  signal toggled()

  implicitWidth: 80
  implicitHeight: 70
  radius: 12

  color: root.active ? "#45475a" : "#1e1e2e"

  Behavior on color { ColorAnimation { duration: 150 } }

  // Active glow strip at top
  Rectangle {
    width: parent.width * 0.5
    height: 2
    anchors.top: parent.top
    anchors.topMargin: 0
    anchors.horizontalCenter: parent.horizontalCenter
    radius: 1
    color: "#89b4fa"
    opacity: root.active ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 150 } }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 6

    Text {
      Layout.alignment: Qt.AlignHCenter
      text: root.icon
      font.family: "Symbols Nerd Font"
      font.pixelSize: 20
      color: root.active ? "#89b4fa" : "#6c7086"
      Behavior on color { ColorAnimation { duration: 150 } }
    }

    Text {
      Layout.alignment: Qt.AlignHCenter
      text: root.label
      color: root.active ? "#cdd6f4" : "#6c7086"
      font.pixelSize: 10
      horizontalAlignment: Text.AlignHCenter
      wrapMode: Text.WordWrap
      width: root.width - 8
      Behavior on color { ColorAnimation { duration: 150 } }
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: root.toggled()
  }
}
