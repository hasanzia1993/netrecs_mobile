import 'package:flutter/material.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/models/datum.dart';
import 'package:nexthour/ui/screens/video_detail_screen.dart';

import 'grid_video_box.dart';
class GridVideoContainer extends StatelessWidget {
  GridVideoContainer(this.buildContext, this.videoWatch);
  final BuildContext buildContext;
  final Datum videoWatch;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: new BorderRadius.circular(5.0),
      onTap: () => _goGameDetailsPage(context, videoWatch),
      child: videoColumn(context),
    );
  }

  void _goGameDetailsPage(BuildContext context, Datum videosList) {
    Navigator.pushNamed(context, RoutePaths.videoDetail, arguments: VideoDetailScreen(videosList));
  }

  Widget videoColumn(context){
    return Hero(
      tag: Text("hero2"),
      child: new GridVideoBox(context, videoWatch),
    );
  }
}