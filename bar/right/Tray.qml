import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
  spacing: 4

  Repeater {
    model: SystemTray.items

    delegate: Item {
      required property SystemTrayItem modelData
      width: 18; height: 18
      Layout.alignment: Qt.AlignVCenter

      Image {
        anchors.fill: parent
        source: modelData.icon
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
          if (mouse.button === Qt.RightButton)
          modelData.menu?.open(this, Qt.point(mouseX, mouseY))
          else
          modelData.activate()
        }
      }
    }
  }
}
