// ignore_for_file: depend_on_referenced_packages

import 'package:rxdart/rxdart.dart';

enum PlaybackState { pause, play, next, previous }

/// Controller to sync playback between animated child (story) views. This
/// helps make sure when stories are paused, the animation (gifs/slides) are
/// also paused.
/// Another reason for using the controller is to place the stories on `paused`
/// state when a media is loading.
class StoryController2 {
  /// Stream that broadcasts the playback state of the stories.
  final playbackNotifier2 = BehaviorSubject<PlaybackState>();

  /// Notify listeners with a [PlaybackState.pause] state
  void pause() {
    playbackNotifier2.add(PlaybackState.pause);
  }

  /// Notify listeners with a [PlaybackState.play] state
  void play() {
    playbackNotifier2.add(PlaybackState.play);
  }

  void next() {
    playbackNotifier2.add(PlaybackState.next);
  }

  void previous() {
    playbackNotifier2.add(PlaybackState.previous);
  }

  /// Remember to call dispose when the story screen is disposed to close
  /// the notifier stream.
  void dispose() {
    playbackNotifier2.close();
  }
}
