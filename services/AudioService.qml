// AudioService.qml
pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire

QtObject {
  id: root

  property var _sink: Pipewire.defaultAudioSink
  property var _audio: _sink != null ? _sink.audio : null

  readonly property bool _ready: _sink && _sink.ready
  readonly property bool muted: _ready && _sink.audio.muted

  property real volume: _ready ? _audio.volume : 0

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
  property PwObjectTracker _tracker: PwObjectTracker {
    objects: [root._sink]
  }


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

  on_SinkChanged: {
    if (_ready) volume = _audio.volume
  }

  on_ReadyChanged: {
    if (_ready) volume = _audio.volume
  }

  // keep in sync with external volume changes once ready
  property Connections _audioConnections: Connections {
    target: _ready ? _audio : null
    function onVolumeChanged() { root.volume = _audio.volume }
  }

}

