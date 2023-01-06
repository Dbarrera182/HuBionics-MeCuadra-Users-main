import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../dependencies/story_controller2.dart';
import '../utils/youtubeToUid.dart';

// ignore: must_be_immutable
class PlayerYoutube extends StatefulWidget {
  late String url;
  bool isLast;
  List<String> videoList;
  List<bool> isVideoList;
  final StoryController2 storyController2;
  PlayerYoutube(
      {Key? key,
      required this.url,
      required this.isLast,
      required this.videoList,
      required this.isVideoList,
      required this.storyController2})
      : super(key: key);

  @override
  State<PlayerYoutube> createState() => _PlayerYoutubeState();
}

class _PlayerYoutubeState extends State<PlayerYoutube> {
  late YoutubePlayerController controller;
  bool _isPlayerReady = false;
  int countStories = 0;

  void runYoutubePlayer(int index) {
    countStories = index;
    controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
        flags: const YoutubePlayerFlags(
          disableDragSeek: false, //mas rapido en reproducir
          useHybridComposition: false,
          forceHD: false,
          autoPlay: true,
          isLive: false,
          enableCaption: true,
          loop: true,
          hideControls: true,
          controlsVisibleAtStart: true,
          startAt: 0,
        ))
      ..addListener(listener);
    _isPlayerReady = widget.isLast ? true : false;
  }

  void listener() {
    if (_isPlayerReady && mounted) {
      setState(() {});
    } else {
      if (!widget.isLast) {
        setState(() {
          controller.removeListener(() {});
          deactivate();
        });
      }
    }
  }

  @override
  void initState() {
    runYoutubePlayer(
        widget.videoList.indexOf(YoutubeMethods.convertUrlToId(widget.url)!));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    controller.pause();
    super.deactivate();
  }

  @override
  void activate() {
    controller.play();
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        aspectRatio: 9 / 16,
        onReady: () {
          _isPlayerReady = widget.isLast;
        },
        // onEnded: (data) {
        //   print(data.duration);
        //   controller.removeListener(() {});
        //   if (widget.videoList.length >= 2) {
        //     if (widget.videoList.indexOf(data.videoId) ==
        //         widget.videoList.length - 1) {
        //       controller
        //           .load(YoutubePlayer.convertUrlToId(widget.videoList[0])!);
        //     } else {
        //       String videoString = widget.videoList[
        //           (widget.videoList.indexOf(data.videoId) + 1) %
        //               widget.videoList.length];
        //       controller.load(YoutubePlayer.convertUrlToId(videoString)!);
        //     }
        //   }
        // },
      ),
      builder: (context, player) {
        return Container(child: player);
      },
    );
  }
}
