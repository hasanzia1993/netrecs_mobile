import 'package:flutter/material.dart';
import 'package:nexthour/custom_player/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:nexthour/common/global.dart';
import 'dart:io';

class DownloadedVideoPlayer extends StatefulWidget {
  DownloadedVideoPlayer(
      {this.taskId, this.name, this.fileName, this.downloadStatus});
  final String? taskId;
  final String? name;
  final String? fileName;
  final int? downloadStatus;

  @override
  _DownloadedVideoPlayerState createState() => _DownloadedVideoPlayerState();
}

class _DownloadedVideoPlayerState extends State<DownloadedVideoPlayer>
    with WidgetsBindingObserver {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late ChewieController _chewieController;
  var vFileName;
  var _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      playerTitle = widget.name;
      vFileName = widget.fileName;
    });
    print('local path1: ${localPath}');
    print('local path2: $localPath/$vFileName');
    // WidgetsBinding.instance!.addObserver(this);
    _videoPlayerController1 =
        VideoPlayerController.file(File('$localPath/$vFileName'));
    //  VideoPlayerController.file(File(
    //     "/data/user/0/com.netrecs.client/app_flutter/Download/WeAreGoingOnBullrun.mp4"));
    _initializeVideoPlayerFuture =
        _videoPlayerController1.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: _videoPlayerController1.value.aspectRatio,
        autoPlay: true,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.white.withOpacity(0.6),
          bufferedColor: Colors.white,
        ),
        placeholder: Container(
          color: Colors.black,
        ),
        // errorBuilder: (context, error) => Center(
        //     child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Icon(Icons.error),
        //     Text(error),
        //   ],
        // )),
        // autoInitialize: true,
      );
    });

    var r = _videoPlayerController1.value.aspectRatio;
    String os = Platform.operatingSystem;

    if (os == 'android') {
      setState(() {
        _platform = TargetPlatform.android;
      });
    } else {
      setState(() {
        _platform = TargetPlatform.iOS;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Chewie(
                  controller: _chewieController,
                  title: playerTitle,
                  downloadStatus: widget.downloadStatus,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ))
        ],
      ),
    );
  }
}
