import Quickshell
import QtQuick
import "./bar"
import "./panels"

Scope {
  Singleton {}

  Variants {
    model: Quickshell.screens
    Bar {}
  }
}
