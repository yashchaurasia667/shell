// Globals.qml
pragma Singleton

import QtQuick
import Quickshell

QtObject {
  readonly property string font: "Maple Mono NF CN"
  readonly property int fontSize: 14

  readonly property SystemClock clock: SystemClock {
    precision: SystemClock.Minutes
  }
}
