import Quickshell.Hyprland
import Quickshell.Io
import QtQuick.Layouts
import QtQuick

import ".."

RowLayout {
  spacing: 8

  // Normal workspaces — always shows 1-4, plus any active beyond that
  Repeater {
    model: {
      const activeIds = Hyprland.workspaces.values
      .filter(ws => ws.id > 0)
      .map(ws => ws.id)
      return [...new Set([1, 2, 3, 4, ...activeIds])].sort((a, b) => a - b)
    }

    delegate: Rectangle {
      required property int modelData
      property bool wsActive: modelData === Hyprland.focusedMonitor?.activeWorkspace?.id

      Layout.preferredWidth: wsActive ? 30 : 15
      Layout.preferredHeight: 15
      Layout.alignment: Qt.AlignVCenter

      radius: 12
      color: wsActive ? Theme.c_primary : Theme.c_secondary_container

      // Text {
      //   text: wsActive ? "" : modelData
      //   color: "white"
      //   font.pixelSize: 10
      //   anchors.centerIn: parent
      // }

      Behavior on Layout.preferredWidth {
        NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
      }
      Behavior on color { ColorAnimation { duration: 150 } }

      MouseArea {
        cursorShape: Qt.PointingHandCursor

        anchors.fill: parent
        onClicked: Hyprland.dispatch("hl.dsp.focus({workspace=" + modelData + "})")
      }
    }
  }

  // Special workspaces on the right
  Repeater {
    model: Hyprland.workspaces.values.filter(ws => ws.id < 0)

    delegate: Rectangle {
      required property var modelData
      property bool wsActive: modelData.id === Hyprland.focusedMonitor?.activeWorkspace?.id

      Layout.preferredWidth: wsActive ? 30 : 15
      Layout.preferredHeight: 15
      Layout.alignment: Qt.AlignVCenter

      radius: 4 
      color: wsActive ? Theme.c_tertiary : Theme.c_secondary_container

      Behavior on Layout.preferredWidth {
        NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
      }
      Behavior on color { ColorAnimation { duration: 150 } }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: Process.execute([
          "hyprctl", "dispatch", "togglespecialworkspace",
          modelData.name.replace("special:", "")
        ])
      }
    }
  }
}
