import QtQuick
import QtQuick.Layouts

import Quickshell.Services.Notifications

import qs.common
import qs.components
import qs.services

Rectangle {
  id: toast
  required property Notification modelData

  // true only when the slide-out was triggered by a manual click (not auto-expire) —
  // gates whether exitAnim's onFinished should also tell the service to dismiss.
  property bool manualDismissPending: false

  Layout.fillWidth: true
  implicitHeight: content.implicitHeight + 24
  radius: 12
  color: Theme.m3surface
  border.color: Theme.m3surface_variant
  border.width: 1

  // entry: slide in from the right
  transform: Translate {
    id: entryTransform
    y: -toast.height - 20
  }

  Component.onCompleted: entryAnim.start()

  NumberAnimation {
    id: entryAnim
    target: entryTransform
    property: "y"
    to: 0 
    duration: 200
    easing.type: Easing.OutCubic
  }

  // exit: slide out to the right
  NumberAnimation {
    id: exitAnim
    target: toast
    property: "x"
    to: toast.width + 40
    duration: NotificationService.exitAnimDuration
    easing.type: Easing.InCubic
    onFinished: {
      if (toast.manualDismissPending) {
        NotificationService.dismiss(toast.modelData)
      }
      // if not manual, the service's own grace timer is already running
      // and will call expire() on its own — nothing more to do here.
    }
  }

  function requestDismiss(): void {
    toast.manualDismissPending = true
    exitAnim.start()
  }

  // catches this notification's own auto-expire warning and animates it out,
  // without telling the service to close it again (the service does that itself)
  Connections {
    target: NotificationService
    function onExpiring(notification) {
      if (notification === toast.modelData) {
        exitAnim.start()
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (mouse) => {
      if (mouse.button === Qt.RightButton) {
        toast.requestDismiss()
      }
    }
    onEntered: dismissBtn.visible = true
    onExited: dismissBtn.visible = false
    hoverEnabled: true
  }

  RowLayout {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 12
    spacing: 10

    Image {
      visible: toast.modelData.image !== ""
      source: toast.modelData.image
      Layout.preferredWidth: 36
      Layout.preferredHeight: 36
      fillMode: Image.PreserveAspectCrop
    }

    Icon {
      visible: toast.modelData.image === "" && toast.modelData.appIcon !== ""
      text: "notifications"
      font.pixelSize: 20
      color: Theme.m3primary
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2

      Label {
        Layout.fillWidth: true
        text: toast.modelData.summary
        font.bold: true
        font.pixelSize: 14
        elide: Text.ElideRight
      }

      Label {
        Layout.fillWidth: true
        visible: toast.modelData.body !== ""
        text: toast.modelData.body
        font.pixelSize: 12
        color: Theme.m3on_surface
        wrapMode: Text.WordWrap
        maximumLineCount: 3
        elide: Text.ElideRight
      }

      RowLayout {
        visible: toast.modelData.actions.length > 0
        spacing: 6
        Layout.topMargin: 4

        Repeater {
          model: toast.modelData.actions

          delegate: Rectangle {
            required property NotificationAction modelData

            implicitWidth: actionLabel.implicitWidth + 16
            implicitHeight: actionLabel.implicitHeight + 8
            radius: 6
            color: Theme.m3surface_variant

            Label {
              id: actionLabel
              anchors.centerIn: parent
              text: parent.modelData.text
              font.pixelSize: 12
            }

            MouseArea {
              anchors.fill: parent
              onClicked: parent.modelData.invoke()
            }
          }
        }
      }
    }

    Icon {
      id: dismissBtn
      visible: false
      text: "close"
      font.pixelSize: 14
      color: Theme.m3error

      MouseArea {
        anchors.fill: parent
        onClicked: toast.requestDismiss()
      }
    }
  }
}
