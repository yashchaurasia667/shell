import Quickshell
import QtQuick

import ".."

Text {
    color: "white"
    font.family: Globals.font
    font.pixelSize: Globals.fontSize
    font.bold: true

    text: Qt.formatDateTime(Globals.clock.date, "hh:mm")
}
