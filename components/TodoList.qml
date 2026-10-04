// components/TodoList.qml
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ".."

PanelWindow {
  id: root
  property int panelMargins: 10

  anchors {
    right: true
    bottom: true
  }

  implicitWidth: 400 + panelMargins
  implicitHeight: 400 + panelMargins
  aboveWindows: false
  color: "transparent"

  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
  BackgroundEffect.blurRegion: Region {
    item: clippingRect
  }

  ClippingRectangle {
    id: clippingRect

    anchors.fill: parent
    anchors.rightMargin: root.panelMargins
    anchors.bottomMargin: root.panelMargins

    radius: 12
    // color: Theme.m3surface
    color: Qt.rgba(Theme.m3surface.r, Theme.m3surface.g, Theme.m3surface.b, 0.75)
    border.color: Theme.m3inverse_on_surface
    border.width: 1

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 12
      spacing: 6

      // Header
      RowLayout {
        Layout.fillWidth: true

        Text {
          text: "To-Do List"
          color: Theme.m3on_surface
          font.pixelSize: 16
          font.bold: true
        }
        Item { Layout.fillWidth: true }

        Text {
          text: todoModel.count + " items"
          color: Theme.m3on_surface
          font.pixelSize: 12
        }
      }

      // Add Items
      RowLayout {
        Layout.fillWidth: true
        spacing: 8

        TextField {
          id: taskInput
          Layout.fillWidth: true

          placeholderText: "Add a new task.."
          placeholderTextColor: Theme.m3primary
          color: Theme.m3on_surface

          background: Rectangle {
            color: Theme.m3inverse_on_surface
            radius: 6
          }

          onAccepted: addTask()
        }
        Button {
          text: "+"
          implicitWidth: 20

          background: Rectangle {
            color: parent.hovered ? Theme.m3on_primary_container : Theme.m3primary
            radius: 8
          }

          contentItem: Text {
            text: parent.text
            color: Theme.m3inverse_on_surface
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
          }

          onClicked: addTask()
        }
      }

      // List View
      ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 6
        clip: true

        model: ListModel {
          id: todoModel
        }

        delegate: Rectangle {
          required property string taskText
          required property bool isCompleted
          required property int index

          width: listView.width
          height: 30
          color: Theme.m3on_secondary
          radius: 6

          RowLayout {
            anchors.fill: parent
            
            CheckBox {
              checked: isCompleted
              onToggled: {
                todoModel.setProperty(index, "isCompleted", checked)
              }
            }

            Text {
              Layout.fillWidth: true
              text: taskText
              color: isCompleted ? Theme.m3primary : Theme.m3on_surface
              font.strikeout: isCompleted
            }

            Button {
              text: "✕"
              implicitWidth: 28
              implicitHeight: 28

              background: Rectangle {
                color: "transparent"
              }

              contentItem: Text {
                text: "✕"
                color: Theme.m3error
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
              }

              onClicked: {
                todoModel.remove(index)
              }
            }
          }
        }
      }
    }
  }

  // Moved inside PanelWindow scope
  function addTask() {
    if (taskInput.text.trim() !== "") {
      todoModel.append({
        "taskText": taskInput.text.trim(),
        "isCompleted": false
      })
      taskInput.text = ""
    }
  }
}
