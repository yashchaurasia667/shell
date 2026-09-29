import QtQuick
import "../../services/"

Item {
  id: root
  implicitWidth: label.implicitWidth
  implicitHeight: 36

  // MouseArea is more reliable than WheelHandler for combined click+scroll
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    onClicked: AudioService.toggleMute()
    onWheel: wheel => {
      const step = 0.05
      const delta = wheel.angleDelta.y > 0 ? step : -step
      AudioService.setVolume(AudioService.volume + delta)
    }
  }

  Text {
    id: label
    anchors.centerIn: parent
    font.pixelSize: AudioService.muted ? 16 : 12
    color: AudioService.muted ? "#6c7086" : "white"
    text: AudioService.muted
      ? "󰸈"
      : `${Math.round(AudioService.volume * 100)}% 󰕾`
  }
}
