import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import qs.common
import qs.components

PanelWindow {
  id: launcher

  property bool open: false
  property int launcherWidth: 600
  property int launcherHeight: 440
  property int maxResults: 8

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  exclusionMode: ExclusionMode.Ignore
  aboveWindows: true
  color: "transparent"
  visible: open

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "app-launcher"
  WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

  function show(): void {
    searchInput.text = ""
    listView.currentIndex = 0
    open = true
  }

  function hide(): void {
    open = false
  }

  function toggle(): void {
    if (open) hide()
    else show()
  }

  function launch(entry): void {
    if (!entry) return
    Quickshell.execDetached(entry.command)
    hide()
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void { launcher.toggle() }
    function show(): void { launcher.show() }
    function hide(): void { launcher.hide() }
  }

  // click-outside-to-close backdrop
  Rectangle {
    anchors.fill: parent
    color: "#80000000"

    MouseArea {
      anchors.fill: parent
      onClicked: launcher.hide()
    }
  }

  Rectangle {
    id: panel
    width: launcher.launcherWidth
    height: launcher.launcherHeight
    anchors.centerIn: parent
    radius: Global.earRadius
    color: Theme.m3surface
    border.color: Theme.m3surface_variant
    border.width: 1

    // swallow clicks so they don't fall through to the backdrop
    MouseArea {
      anchors.fill: parent
      onClicked: {}
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Global.pad
      spacing: Global.pad

      RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Icon {
          text: "search"
          font.pixelSize: 18
          color: Theme.m3on_surface
        }

        TextInput {
          id: searchInput
          Layout.fillWidth: true
          font.pixelSize: 16
          color: Theme.m3on_surface
          clip: true

          Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
              launcher.hide()
              event.accepted = true
            } else if (event.key === Qt.Key_Down) {
              listView.currentIndex = Math.min(listView.count - 1, listView.currentIndex + 1)
              event.accepted = true
            } else if (event.key === Qt.Key_Up) {
              listView.currentIndex = Math.max(0, listView.currentIndex - 1)
              event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              launcher.launch(filteredApps.values[listView.currentIndex])
              event.accepted = true
            }
          }

          Label {
            visible: searchInput.text === ""
            text: "Search apps…"
            color: Theme.m3on_surface
            opacity: 0.5
            font.pixelSize: 16
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Theme.m3surface_variant
      }

      ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        model: ScriptModel {
          id: filteredApps
          values: {
            const all = [...DesktopEntries.applications.values]
            const q = searchInput.text.trim().toLowerCase()

            const matches = q === "" ? all : all.filter(entry => {
              if (entry.name.toLowerCase().includes(q)) return true
              if (entry.genericName.toLowerCase().includes(q)) return true
              return entry.keywords.some(k => k.toLowerCase().includes(q))
            })

            return matches.slice(0, launcher.maxResults)
          }
        }

        delegate: Rectangle {
          id: resultRow
          required property var modelData
          required property int index

          width: ListView.view.width
          height: 50
          radius: 8
          color: index === listView.currentIndex ? Theme.m3surface_variant : "transparent"

          RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 10

            Image {
              Layout.preferredWidth: 35
              Layout.preferredHeight: 35
              source: Quickshell.iconPath(resultRow.modelData.icon, true)
              fillMode: Image.PreserveAspectFit
              asynchronous: true
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 0

              Label {
                Layout.fillWidth: true
                text: resultRow.modelData.name
                font.pixelSize: 14
                elide: Text.ElideRight
              }

              Label {
                Layout.fillWidth: true
                visible: resultRow.modelData.genericName !== ""
                text: resultRow.modelData.genericName
                font.pixelSize: 12
                color: Theme.m3on_surface
                opacity: 0.6
                elide: Text.ElideRight
              }
            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: launcher.launch(resultRow.modelData)
            onEntered: listView.currentIndex = resultRow.index
            hoverEnabled: true
          }
        }

        Label {
          anchors.centerIn: parent
          visible: listView.count === 0
          text: "No results"
          color: Theme.m3on_surface
          opacity: 0.5
        }
      }
    }
  }

  onOpenChanged: {
    if (open) searchInput.forceActiveFocus()
  }
}
