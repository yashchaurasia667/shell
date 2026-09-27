// services/BrightnessService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
  id: root

  property real value: 0.5
  property real maxValue: 1.0

  // 1. Fetch max hardware brightness on startup
  property Process _maxProc: Process {
    command: ["brightnessctl", "max"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        root.maxValue = parseFloat(text.trim())
        _getProc.running = true // Now fetch the current value
      }
    }
  }

  // 2. Fetch current hardware brightness
  property Process _getProc: Process {
    command: ["brightnessctl", "get"]
    stdout: StdioCollector {
      onStreamFinished: {
        let current = parseFloat(text.trim())
        if (root.maxValue > 0) {
          root.value = current / root.maxValue
        }
      }
    }
  }

  // 3. Reusable process to set brightness without freezing the UI
  property Process _setProc: Process {}

  // 4. The function your slider will call
  function setBrightness(percent) {
    let p = Math.max(1, Math.round(percent * 100))
    _setProc.command = ["brightnessctl", "set", p + "%"]
    _setProc.running = true

    // Update the property instantly so the UI feels snappy
    root.value = percent 
  }
}
