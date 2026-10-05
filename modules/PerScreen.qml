import Quickshell

import qs.common
import "bar"

Scope {
  id: root
  required property var modelData

  Bar { screen: root.modelData }

  Exclusion { screen: root.modelData; edge: "top"; size: Global.reserveTop }
  Exclusion { screen: root.modelData; edge: "bottom"; size: Global.border }
  Exclusion { screen: root.modelData; edge: "left"; size: Global.border }
  Exclusion { screen: root.modelData; edge: "right"; size: Global.border }
}

