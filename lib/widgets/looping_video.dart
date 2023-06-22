import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoopingVideoContainer extends StatefulWidget {
  final String videoPath;

  const LoopingVideoContainer({required this.videoPath});

  @override
  _LoopingVideoContainerState createState() => _LoopingVideoContainerState();
}

class _LoopingVideoContainerState extends State<LoopingVideoContainer> {
  late VideoPlayerController _videoController;
  late bool _isVideoInitialized;

  @override
  void initState() {
    super.initState();
    _isVideoInitialized = false;
    _videoController = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          _videoController.setLooping(false);
          _videoController.play();

        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isVideoInitialized
          ? AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      )
          : Container(),
    );
  }
}