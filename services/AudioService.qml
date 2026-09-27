// AudioService.qml
pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

QtObject {
  id: root

  property var _sink: Pipewire.defaultAudioSink
  property var _audio: _sink != null ? _sink.audio : null

  property real volume: _audio != null ? _audio.volume : 0.0
  property bool muted:  _audio != null ? _audio.muted  : false

  property real _pendingVolume: -1

  property Timer _debounce: Timer {
    interval: 16
    repeat: false
    onTriggered: {
      if (root._pendingVolume < 0) return

      _volProc.command = [
        "wpctl", "set-volume",
        "@DEFAULT_AUDIO_SINK@",
        root._pendingVolume.toFixed(2)
      ]
      _volProc.running = true
      root._pendingVolume = -1
    }
  }

  property Process _volProc: Process {
    onExited: (code, status) => {
      if (root._pendingVolume >= 0) {
        root._debounce.restart()
      }
    }
  }

  property Process _muteProc: Process {}

  function setVolume(v) {
    if (_audio == null) return

    _pendingVolume = Math.max(0.0, Math.min(1.0, v))
    _debounce.restart()

    if (muted && v > 0) {
      _muteProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "0"]
      _muteProc.running = true
    }
  }

  function toggleMute() {
    if (_muteProc.running) _muteProc.running = false
    _muteProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
    _muteProc.running = true
  }
}

