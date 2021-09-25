import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nexthour/models/user_profile_model.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/providers/login_provider.dart';
import 'package:nexthour/providers/main_data_provider.dart';
import 'package:nexthour/providers/menu_data_provider.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:nexthour/ui/shared/actors_horizontal_list.dart';
import 'package:nexthour/ui/shared/heading1.dart';
import 'package:nexthour/ui/shared/image_slider.dart';
import 'package:nexthour/ui/screens/horizental_genre_list.dart';
import 'package:nexthour/ui/screens/horizontal_movies_list.dart';
import 'package:nexthour/ui/screens/horizontal_tvseries_list.dart';
import 'package:nexthour/ui/screens/top_video_list.dart';
import 'package:nexthour/ui/shared/live_video_list.dart';
import 'package:nexthour/ui/widgets/blog_view.dart';
import 'package:provider/provider.dart';

class VideosPage extends StatefulWidget {
  VideosPage({Key? key, this.menuId}) : super(key: key);
  final menuId;

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  GlobalKey _keyRed = GlobalKey();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var meData;
  ScrollController controller = ScrollController(initialScrollOffset: 0.0);
  bool _visible = false;
  var menuDataList;
  var moviesList;
  var tvSeriesList;
  var liveDataList;
  var topVideosList;
  var blogList;
  var actorsList;
  var actorsListLen;
  var topVideosListLen;
  var liveDataListLen;
  var moviesListLen;
  var tvSeriesListLen;
  var blogListLen;

  MenuDataProvider menuDataProvider = MenuDataProvider();
  MovieTVProvider movieTvDataProvider = MovieTVProvider();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuDataList = [];
    moviesList = [];
    tvSeriesList = [];
    liveDataList = [];
    topVideosList = [];
    blogList = null;
    actorsList = [];

    // controller = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      try {
        menuDataProvider =
            Provider.of<MenuDataProvider>(context, listen: false);
        await menuDataProvider.getMenusData(context, widget.menuId);

        movieTvDataProvider =
            Provider.of<MovieTVProvider>(context, listen: false);
        moviesList = menuDataProvider.menuCatMoviesList;
        tvSeriesList = menuDataProvider.menuCatTvSeriesList;
        liveDataList = menuDataProvider.liveDataList;
        menuDataList = menuDataProvider.menuDataList;
        topVideosList = movieTvDataProvider.topVideoList;
        blogList =
            Provider.of<AppConfig>(context, listen: false).appModel!.blogs;
        actorsList =
            Provider.of<MainProvider>(context, listen: false).actorList;
        setState(() {
          actorsListLen = actorsList.length;
          topVideosListLen = topVideosList.length;
          liveDataListLen = liveDataList.length;
          moviesListLen = moviesList.length;
          tvSeriesListLen = tvSeriesList.length;
          blogListLen = blogList.length;
        });
      } catch (err) {
        return null;
      }
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    getMenuData();
  }

  getMenuData() async {
    try {
      menuDataProvider = Provider.of<MenuDataProvider>(context, listen: false);
      await menuDataProvider.getMenusData(context, widget.menuId);

      movieTvDataProvider =
          Provider.of<MovieTVProvider>(context, listen: false);
      moviesList = menuDataProvider.menuCatMoviesList;
      tvSeriesList = menuDataProvider.menuCatTvSeriesList;
      liveDataList = menuDataProvider.liveDataList;
      menuDataList = menuDataProvider.menuDataList;
      topVideosList = movieTvDataProvider.topVideoList;
      blogList = Provider.of<AppConfig>(context, listen: false).appModel!.blogs;
      actorsList = Provider.of<MainProvider>(context, listen: false).actorList;
      setState(() {
        actorsListLen = actorsList.length;
        topVideosListLen = topVideosList.length;
        liveDataListLen = liveDataList.length;
        moviesListLen = moviesList.length;
        tvSeriesListLen = tvSeriesList.length;
        blogListLen = blogList.length;
      });
    } catch (err) {
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshList,
      color: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).primaryColorLight,
      child: Container(
        child: _visible == false
            ? Center(
                child: CircularProgressIndicator(),
              )
            : menuDataList.length == 0
                ? Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )
                : Container(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      // controller: controller,
                      child: Column(
                        key: _keyRed,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // ImageSlider(),
                          SizedBox(
                            height: 20.0,
                          ),
                          HorizontalGenreList(),
                          SizedBox(
                            height: 15.0,
                          ),
                          actorsListLen == 0
                              ? SizedBox.shrink()
                              : Heading1("Artist", "Actor"),
                          actorsListLen == 0
                              ? SizedBox.shrink()
                              : SizedBox(
                                  height: 15.0,
                                ),
                          actorsListLen == 0
                              ? SizedBox.shrink()
                              : ActorsHorizontalList(),
                          SizedBox(
                            height: 15.0,
                          ),
                          topVideosListLen == 0
                              ? SizedBox.shrink()
                              : Heading1("Top Movies & TV Series", "Top"),
                          topVideosListLen == 0
                              ? SizedBox.shrink()
                              : SizedBox(
                                  height: 15.0,
                                ),
                          topVideosListLen == 0
                              ? SizedBox.shrink()
                              : Container(
                                  height: 350,
                                  child: TopVideoList(),
                                ),
                          liveDataListLen == 0
                              ? SizedBox.shrink()
                              : SizedBox(
                                  height: 15.0,
                                ),
                          liveDataListLen == 0
                              ? SizedBox.shrink()
                              : Heading2("LIVE", "Live"),
                          liveDataListLen == 0
                              ? SizedBox.shrink()
                              : LiveVideoList(),
                          SizedBox(
                            height: 15.0,
                          ),
                          tvSeriesListLen == 0
                              ? SizedBox.shrink()
                              : Heading1("TV Series", "TV"),
                          tvSeriesListLen == 0
                              ? SizedBox.shrink()
                              : TvSeriesList(),
                          SizedBox(
                            height: 15.0,
                          ),
                          moviesListLen == 0
                              ? SizedBox.shrink()
                              : Heading1("Movies", "Mov"),
                          moviesListLen == 0 ? SizedBox.shrink() : MoviesList(),
                          SizedBox(
                            height: 15.0,
                          ),
                          blogListLen == 0
                              ? SizedBox.shrink()
                              : Heading1("Our Blog Posts", "Blog"),
                          blogListLen == 0
                              ? SizedBox.shrink()
                              : SizedBox(
                                  height: 15.0,
                                ),
                          blogListLen == 0 ? SizedBox.shrink() : BlogView(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
