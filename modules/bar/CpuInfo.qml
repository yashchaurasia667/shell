import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.common
import qs.components
import qs.services

Item {
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  RowLayout {
    id: row
    anchors.fill: parent
    spacing: 6

    Icon {
      text: "memory"
      color: Theme.m3primary
    }

    Label {
      text: Math.round(SystemStatsService.cpuUsage) + "% | " + Math.round(SystemStatsService.cpuTemp) + "°C"
      font.bold: true
      color: Theme.m3primary
    }
    Icon {
      text: "device_thermostat"
      color: Theme.m3primary
    }
  }
}
