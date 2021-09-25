import 'package:flutter/material.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/providers/menu_data_provider.dart';
import 'package:nexthour/ui/screens/video_detail_screen.dart';
import 'package:nexthour/ui/widgets/tvseries_item.dart';
import 'package:provider/provider.dart';

class TvSeriesList extends StatefulWidget {
  @override
  _TvSeriesListState createState() => _TvSeriesListState();
}

class _TvSeriesListState extends State<TvSeriesList> {
  @override
  Widget build(BuildContext context) {
    var menuByCat = Provider.of<MenuDataProvider>(context).menuCatTvSeriesList;
    return menuByCat.length == 0
        ? SizedBox.shrink()
        : Container(
            height: 170,
            margin: EdgeInsets.only(top: 15.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(left: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: menuByCat.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      margin: EdgeInsets.only(right: 15.0),
                      child: TVSeriesItem(menuByCat[index], context),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RoutePaths.videoDetail,
                          arguments: VideoDetailScreen(menuByCat[index]));
                    },
                  );
                }));
  }
}
