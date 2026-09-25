import QtQuick
import ".."

Text {
    color: "white"
    font.family: Globals.font
    font.pixelSize: Globals.fontSize
    font.bold: true

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: parent.text = Qt.formatDateTime(new Date(), "hh:mm")
    }

    Component.onCompleted: text = Qt.formatDateTime(new Date(), "hh:mm")
}
