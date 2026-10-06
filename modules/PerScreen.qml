// import QtQuick
import Quickshell

import qs.common
import "bar"
import "notifications"

Scope {
  id: root
  required property var modelData

  Bar { screen: root.modelData }

  Exclusion { screen: root.modelData; edge: "top"; size: Global.reserveTop }
  Exclusion { screen: root.modelData; edge: "bottom"; size: Global.border }
  Exclusion { screen: root.modelData; edge: "left"; size: Global.border }
  Exclusion { screen: root.modelData; edge: "right"; size: Global.border }

  NotificationToast {}
  // NotificationCenter {}

  // hot corner
  // Rectangle {
  //   anchors {
  //     bottom: parent.bottom
  //     right: parent.right
  //   }
  //   width: 100
  //   height: 100
  //   color: "white"
  // }
}

