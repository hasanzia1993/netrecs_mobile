import 'dart:async';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/custom_player/src/chewie_player.dart';
import 'package:nexthour/custom_player/src/chewie_progress_colors.dart';
import 'package:nexthour/custom_player/src/material_progress_bar.dart';
import 'package:nexthour/custom_player/src/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'animanted_play_pause.dart';
import 'center_play_button.dart';

class MaterialControls extends StatefulWidget {
  const MaterialControls({Key? key, this.title, this.downloadStatus})
      : super(key: key);
  final title;
  final downloadStatus;

  @override
  State<StatefulWidget> createState() {
    return _MaterialControlsState();
  }
}

class _MaterialControlsState extends State<MaterialControls>
    with SingleTickerProviderStateMixin {
  late VideoPlayerValue _latestValue;
  double? _latestVolume;
  bool _hideStuff = true;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  final barHeight = 48.0;
  final marginSize = 5.0;

  late VideoPlayerController controller;
  ChewieController? _chewieController;
  // We know that _chewieController is set in didChangeDependencies
  ChewieController get chewieController => _chewieController!;

  @override
  Widget build(BuildContext context) {
    print('ssssssss : $_latestValue');
    if (_latestValue.hasError) {
      return chewieController.errorBuilder?.call(
            context,
            chewieController.videoPlayerController.value.errorDescription!,
          ) ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
                size: 42,
              ),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "${_latestValue.errorDescription}",
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              )),
              Container(
                alignment: Alignment.center,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Go Back',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
    }

    void _closePlayer() {
      bool isFinished = _latestValue.position >= _latestValue.duration;
      setState(() {
        if (controller.value.isPlaying) {
          _hideStuff = false;
          _hideTimer?.cancel();
          controller.pause();
        } else {
          _cancelAndRestartTimer();

          if (!controller.value.isInitialized) {
            controller.initialize().then((_) {
              controller.play();
            });
          } else {
            if (isFinished) {
              controller.seekTo(Duration(seconds: 0));
            }
            controller.play();
          }
        }
      });
      Navigator.pop(context);
    }

    GestureDetector _buildCloseBack() {
      return GestureDetector(
        onTap: _closePlayer,
        child: Container(
          height: barHeight,
          color: Colors.transparent,
          margin: EdgeInsets.only(left: 3.0, right: 4.0),
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
          ),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 22,
          ),
        ),
      );
    }

    Widget _buildTitle() {
      return Padding(
        padding: EdgeInsets.only(right: 24.0),
        child: playerTitle == null
            ? SizedBox.shrink()
            : Text(
                '$playerTitle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
      );
    }

    AnimatedOpacity _buildTopBar(
      BuildContext context,
    ) {
      return AnimatedOpacity(
          opacity: _hideStuff ? 0.0 : 1.0,
          duration: Duration(milliseconds: 300),
          child: SafeArea(
            child: Container(
              height: barHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.0, 0.3, 0.6, 1.0],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.35),
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
              child: Row(
                children: <Widget>[
                  _buildCloseBack(),
                  _buildTitle(),
                ],
              ),
            ),
          ));
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () => _cancelAndRestartTimer(),
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                color: _hideStuff
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.3),
              ),
              Column(
                children: <Widget>[
                  // if (_latestValue.isBuffering)
                  //   const Expanded(
                  //     child: Center(
                  //       child: CircularProgressIndicator(),
                  //     ),
                  //   )
                  // else
                  _buildTopBar(context),
                  _buildHitArea(),
                  _buildBottomBar(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = _chewieController;
    _chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.button!.color;

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
          height: barHeight,
          margin: EdgeInsets.only(bottom: 30.0),
          // color: Theme.of(context).primaryColor.withOpacity(0.2),
          // color: Theme.of(context).dialogBackgroundColor,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    // _buildPlayPause(controller),
                    // if (chewieController.isLive)
                    //   const Expanded(
                    //       child: Padding(
                    //     padding: EdgeInsets.only(
                    //       left: 10.0,
                    //     ),
                    //     child: Text('LIVE'),
                    //   ))
                    // else
                    //   _buildPosition(iconColor),
                    if (chewieController.isLive)
                      const SizedBox()
                    else
                      _buildProgressBar(),
                    // if (chewieController.allowPlaybackSpeedChanging)
                    //   _buildSpeedButton(controller),
                    // if (chewieController.allowMuting)
                    //   _buildMuteButton(controller),
                    // if (chewieController.allowFullScreen) _buildExpandButton(),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (chewieController.isLive)
                        const Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(
                            left: 20.0,
                          ),
                          child: Text('LIVE'),
                        ))
                      else
                        _buildPosition(iconColor),
                      Row(
                        children: [
                          if (chewieController.allowPlaybackSpeedChanging)
                            _buildSpeedButton(controller),
                          if (chewieController.allowMuting)
                            _buildMuteButton(controller),
                          if (chewieController.allowFullScreen)
                            _buildExpandButton(),
                        ],
                      )
                    ],
                  )),
            ],
          )),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: const EdgeInsets.only(right: 12.0),
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Icon(
              chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _skipForward() {
    _cancelAndRestartTimer();
    final end = _latestValue.duration.inMilliseconds;
    final skip = (_latestValue.position + Duration(seconds: 10)).inMilliseconds;
    controller.seekTo(Duration(milliseconds: math.min(skip, end)));
  }

  GestureDetector _buildSkipForward(Color iconColor, double barHeight) {
    return GestureDetector(
      onTap: _skipForward,
      child: Container(
//        height: barHeight,
          color: Colors.transparent,
//        padding: EdgeInsets.only(
//          left: 6.0,
//          right: 8.0,
//        ),
//        margin: EdgeInsets.only(
//          right: 8.0,
//        ),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Icon(
                Icons.timer_10,
                size: 14.0,
                color: iconColor,
              ),
            ),
            Icon(
              OpenIconicIcons.reload,
              color: iconColor,
              size: 35.0,
            ),
          ])),
    );
  }

  GestureDetector _buildSkipBack(Color iconColor, double barHeight) {
    return GestureDetector(
      onTap: _skipBack,
      child: Container(
//        height: barHeight,
          color: Colors.transparent,
//        margin: EdgeInsets.only(left: 10.0),
//        padding: EdgeInsets.only(
//          left: 6.0,
//          right: 6.0,
//        ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.timer_10,
                  size: 14.0,
                  color: iconColor,
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.skewY(0.0)
                  ..rotateX(math.pi)
                  ..rotateZ(math.pi),
                child: Icon(
                  OpenIconicIcons.reload,
                  color: iconColor,
                  size: 35.0,
                ),
              ),
            ],
          )),
    );
  }

  void _skipBack() {
    _cancelAndRestartTimer();
    final beginning = Duration(seconds: 0).inMilliseconds;
    final skip = (_latestValue.position - Duration(seconds: 10)).inMilliseconds;
    controller.seekTo(Duration(milliseconds: math.max(skip, beginning)));
  }

  Expanded _buildHitArea() {
    final bool isFinished = _latestValue.position >= _latestValue.duration;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_latestValue.isPlaying) {
            if (_displayTapped) {
              setState(() {
                _hideStuff = true;
              });
            } else {
              _cancelAndRestartTimer();
            }
          } else {
            // _playPause();

            setState(() {
              _hideStuff = true;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity: _hideStuff ? 0.0 : 1.0,
//              opacity:
//                  _latestValue != null && !_latestValue.isPlaying && !_dragging
//                      ? 1.0
//                      : 0.0,
              duration: Duration(milliseconds: 300),
              child: GestureDetector(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
//                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(48.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: _latestValue.isBuffering
                            ? SizedBox.shrink()
                            : _buildSkipBack(Colors.white, barHeight),
                      ),
                    ),

                    SizedBox(
                      width: 15.0,
                    ),

//                    _buildPlay(controller),

                    Container(
                      decoration: BoxDecoration(
//                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(48.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: _latestValue.isBuffering
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                // Always set the iconSize on the IconButton, not on the Icon itself:
                                // https://github.com/flutter/flutter/issues/52980
                                child: CircularProgressIndicator(),
                              )
                            : CenterPlayButton(
                                iconColor: Colors.white,
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.0),
                                isFinished: isFinished,
                                isPlaying: controller.value.isPlaying,
                                show: true,
                                // show: !_latestValue.isPlaying && !_dragging,
                                onPressed: _playPause,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
//                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(48.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: _latestValue.isBuffering
                            ? SizedBox.shrink()
                            : _buildSkipForward(Colors.white, barHeight),
                      ),
                    ),
//                    _buildSkipForward(Colors.black87, barHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
        //  CenterPlayButton(
        //   backgroundColor: Theme.of(context).dialogBackgroundColor,
        //   isFinished: isFinished,
        //   isPlaying: controller.value.isPlaying,
        //   show: !_latestValue.isPlaying && !_dragging,
        //   onPressed: _playPause,
        // ),
      ),
    );
  }

  Widget _buildSpeedButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () async {
        _hideTimer?.cancel();

        final chosenSpeed = await showModalBottomSheet<double>(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (context) => _PlaybackSpeedDialog(
            speeds: chewieController.playbackSpeeds,
            selected: _latestValue.playbackSpeed,
          ),
        );

        if (chosenSpeed != null) {
          controller.setPlaybackSpeed(chosenSpeed);
        }

        if (_latestValue.isPlaying) {
          _startHideTimer();
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: const Icon(
              Icons.speed,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Icon(
              _latestValue.volume > 0 ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: const EdgeInsets.only(left: 8.0, right: 4.0),
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: AnimatedPlayPause(
          playing: controller.value.isPlaying,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPosition(Color? iconColor) {
    final position = _latestValue.position;
    final duration = _latestValue.duration;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 24.0),
      child: Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<void> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if (controller.value.isPlaying || chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer =
          Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    final isFinished = _latestValue.position >= _latestValue.duration;

    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.isInitialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(const Duration());
          }
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: MaterialVideoProgressBar(controller, onDragStart: () {
          setState(() {
            _dragging = true;
          });

          _hideTimer?.cancel();
        }, onDragEnd: () {
          setState(() {
            _dragging = false;
          });

          _startHideTimer();
        },
            colors: ChewieProgressColors(
                playedColor: Theme.of(context).primaryColor,
                handleColor: Theme.of(context).primaryColor,
                bufferedColor: Theme.of(context).accentColor,
                backgroundColor: Theme.of(context).disabledColor)
            // chewieController.materialProgressColors ??
            //     ChewieProgressColors(
            //         playedColor: Theme.of(context).accentColor,
            //         handleColor: Theme.of(context).accentColor,
            //         bufferedColor: Theme.of(context).backgroundColor,
            //         backgroundColor: Theme.of(context).disabledColor),
            ),
      ),
    );
  }
}

class _PlaybackSpeedDialog extends StatelessWidget {
  const _PlaybackSpeedDialog({
    Key? key,
    required List<double> speeds,
    required double selected,
  })   : _speeds = speeds,
        _selected = selected,
        super(key: key);

  final List<double> _speeds;
  final double _selected;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).primaryColor;

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final _speed = _speeds[index];
        return ListTile(
          dense: true,
          title: Row(
            children: [
              if (_speed == _selected)
                Icon(
                  Icons.check,
                  size: 20.0,
                  color: selectedColor,
                )
              else
                Container(width: 20.0),
              const SizedBox(width: 16.0),
              Text(_speed.toString()),
            ],
          ),
          selected: _speed == _selected,
          onTap: () {
            Navigator.of(context).pop(_speed);
          },
        );
      },
      itemCount: _speeds.length,
    );
  }
}
