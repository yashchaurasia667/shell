import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
  property string wallPath: "/home/yash/Pictures/wall/FH4/20260614_12h41m36s_grim.png" 
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      WlrLayershell.layer: WlrLayer.Background

      // Load and display the wallpaper image
      Image {
        anchors.fill: parent
        source: `file://${wallPath}`
        fillMode: Image.PreserveAspectCrop
      }
    }
  }
}
