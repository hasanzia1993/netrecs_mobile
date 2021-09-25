import 'dart:io';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/custom_player/chewie.dart';
import 'package:flutter/material.dart';
import 'package:nexthour/custom_player/video_data.dart';
import 'package:nexthour/custom_player/vlc_player_with_controls.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class MyCustomPlayer extends StatefulWidget {
  MyCustomPlayer({this.title, this.url, this.downloadStatus});

  final String? title;
  final String? url;
  final int? downloadStatus;

  @override
  State<StatefulWidget> createState() {
    return _MyCustomPlayerState();
  }
}

class _MyCustomPlayerState extends State<MyCustomPlayer>
    with WidgetsBindingObserver {
  TargetPlatform? platform;
  VideoPlayerController? _videoPlayerController1;
  // late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  DateTime? currentBackPressTime;
  var _initializeVideoPlayerFuture;

  VlcPlayerController? _controller;
  final _key = GlobalKey<VlcPlayerWithControlsState>();
  List<VideoData>? listVideos;
  int? selectedVideoIndex;
  bool showPlayerControls = true;
  void stopScreenLock() async {
    Wakelock.enable();
  }

  //  Handle back press
  Future<bool> onWillPopS() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Navigator.pop(context);
      return Future.value(true);
    }
    return Future.value(true);
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _chewieController!.pause();
        debugPrint("Inactive");
        break;
      case AppLifecycleState.resumed:
        _chewieController!.pause();
        break;
      case AppLifecycleState.paused:
        _chewieController!.pause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // this.stopScreenLock();
    setState(() {
      playerTitle = widget.title;
    });

    WidgetsBinding.instance!.addObserver(this);
    _videoPlayerController1 = VideoPlayerController.network(widget.url!);
    _initializeVideoPlayerFuture =
        _videoPlayerController1!.initialize().then((_) {
      _chewieController = ChewieController(
        allowedScreenSleep: false,
        allowFullScreen: true,
        fullScreenByDefault: true,
        videoPlayerController: _videoPlayerController1!,
        aspectRatio: _videoPlayerController1!.value.aspectRatio,
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
      );
    });

    _controller = VlcPlayerController.network(
      widget.url!,
      hwAcc: HwAcc.FULL,
      autoPlay: false,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );

    String os = Platform.operatingSystem;

    if (os == 'android') {
      setState(() {
        platform = TargetPlatform.android;
      });
    } else {
      setState(() {
        platform = TargetPlatform.iOS;
      });
    }
  }

  @override
  void dispose() async {
    _videoPlayerController1!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColorDark,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _videoPlayerController1!.value.aspectRatio,
                        child: Chewie(
                          controller: _chewieController!,
                          title: playerTitle,
                          downloadStatus: widget.downloadStatus,
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        onWillPop: onWillPopS);
  }
}
