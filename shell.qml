//@ pragma UseQApplication
// shell.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

import "./bar"
import "./frame"
import "./components"
import "./services"
import "./rightPanel"

ShellRoot {

  Variants {
    model: Quickshell.screens
    Bar {}
  }

  // bottom
  Frame {
    anchorTop: false
  }
  // left
  Frame {
    // id: leftFrame
    anchorRight: false
  }

  // Left panel — triggered by left frame hover OR bottom-right hot corner
  RightPanel {
    triggerHovered: hotCorner.hovered
  }

  // Hot corner - bottom right
  PanelWindow {
    id: hotCorner
    anchors.bottom: true
    anchors.right: true

    implicitWidth: 20
    implicitHeight: 20

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "hotcorner"
    exclusiveZone: -1

    color: "transparent"

    // Poll hyprctl monitors -j to reliably detect special workspace visibility.
    // Hyprland.focusedMonitor.activeWorkspace does NOT update for special workspaces
    // (they overlay the regular workspace without changing the activeWorkspace property).
    property bool onSpecialWorkspace: false

    function refreshWorkspaceState() {
      monitorProc.running = true
    }

    Process {
      id: monitorProc
      command: ["hyprctl", "monitors", "-j"]
      stdout: StdioCollector {
        onStreamFinished: {
          try {
            const monitors = JSON.parse(text)
            const focused = monitors.find(m => m.focused) ?? monitors[0]
            hotCorner.onSpecialWorkspace = focused?.specialWorkspace?.id !== 0
          } catch (e) {}
        }
      }
    }

    // Refresh on startup and whenever Hyprland workspace state changes
    Component.onCompleted: refreshWorkspaceState()
    Connections {
      target: Hyprland
      function onRawEvent(event) {
        const name = event.name
        if (name === "workspace" || name === "openspecialworkspace" ||
            name === "closespecialworkspace" || name === "activemon") {
          hotCorner.refreshWorkspaceState()
        }
      }
    }

    readonly property bool activeFullscreen: {
      if (onSpecialWorkspace) return false
      const t = ToplevelManager.activeToplevel
      return t !== null && t.fullscreen
    }

    property bool hovered: hotCornerHandler.hovered && !activeFullscreen

    HoverHandler { id: hotCornerHandler }
  }

  // right
  Frame {
    id: rightFrame
    anchorLeft: false
    thickness: 5
  }
  SidePanel {
    id: volumeControl
    triggerHovered: rightFrame.hovered
    edge: Qt.RightEdge

    curveDepth: 15
    cornerRadius: 25

    ColumnLayout {
      anchors.fill: parent
      spacing: 12

      Item {Layout.fillHeight: true}
      Slider { 
        icon: AudioService.muted ? "󰖁" : "󰕾" 
        Layout.alignment: Qt.AlignHCenter
        value: AudioService.volume
        onMoved: position => {
          AudioService.setVolume(position)
        }
      }

      Slider { 
        icon: "󰃝" 
        Layout.alignment: Qt.AlignHCenter
        value: BrightnessService.value
        onMoved: position => {
          BrightnessService.setBrightness(position)
        }
      }
      Item {Layout.fillHeight: true}
    }
  }

  // concave corners
  ConcaveCorner {
    anchors {
      top: true
      left: true
    }
  }
  ConcaveCorner {
    anchors {
      top: true
      right: true
    }
    mirrorX: true
  }
  ConcaveCorner {
    anchors {
      bottom: true
      right: true
    }
    mirrorX: true
    mirrorY: true
  }
  ConcaveCorner {
    anchors {
      bottom: true
      left: true
    }
    mirrorY: true
  }
}
