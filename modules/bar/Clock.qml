import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.common
import qs.components

Item {
  // anchors.verticalCenter: parent.verticalCenter
  // implicitHeight: Global.pillHeight
  // anchors.fill: parent
  // Layout.alignment: Qt.AlignVCenter
  // Layout.fillHeight: true

  RowLayout {
    spacing: 6
    anchors.verticalCenter: parent.verticalCenter

    SystemClock {
      id: clock
      precision: SystemClock.Minutes
    }

    // Label {
    //   text: Qt.formatDateTime(clock.date, "ddd d MMM")
    //   color: Theme.m3on_surface
    //   font.pixelSize: 13
    // }
    Label {
      text: Qt.formatDateTime(clock.date, "HH:mm")
      // color: Theme.m3on_surface
      font.bold: true
      font.pixelSize: 16
    }
  }
}
