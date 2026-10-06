//@ pragma UseQApplication
import Quickshell
import QtQuick

import qs.components

import qs.modules

import "modules/notifications"
import "modules/bar"

ShellRoot {
  id: root
  Variants {
    model: Quickshell.screens
    PerScreen {}
  }
  // NotificationToast {}
  // NotificationCenter {}
  // TodoList {}
}
