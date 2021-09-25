// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:nexthour/providers/menu_data_provider.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:nexthour/ui/shared/grid_video_container.dart';
import 'package:provider/provider.dart';

class GridMovieTV extends StatelessWidget {
  final String type;
  GridMovieTV(this.type);

  late List<Widget> videoList;
  @override
  Widget build(BuildContext context) {
    var moviesList = Provider.of<MenuDataProvider>(context).menuCatMoviesList;
    var tvSeriesList = Provider.of<MenuDataProvider>(context).menuCatTvSeriesList;
    videoList = List.generate( type == "M" ? moviesList.length : tvSeriesList.length,
            (index) {
          return type == "M" ? GridVideoContainer(context, moviesList[index]) : GridVideoContainer(context, tvSeriesList[index]);
        });

    return Scaffold(
      appBar: customAppBar(context, type == "M"? "Movies" : "TV Series") as PreferredSizeWidget?,
      body: GridView.count(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 18/28,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 8.0,
          children: videoList
      ),
    );
  }
}