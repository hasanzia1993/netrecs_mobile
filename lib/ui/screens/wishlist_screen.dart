import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/models/comment.dart';
import 'package:nexthour/models/datum.dart';
import 'package:nexthour/models/episode.dart';
import 'package:nexthour/models/genre_model.dart';
import 'package:nexthour/providers/main_data_provider.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:nexthour/providers/wishlist_provider.dart';
import 'package:nexthour/ui/screens/blank_wishlist.dart';
import 'package:nexthour/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  ScrollController? _scrollViewController;
  bool _visible = false;

  fetchWishList() async {
    tvWishList = [];
    moviesWishList = [];

    final moviesTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    final genreList =
        Provider.of<MainProvider>(context, listen: false).genreList;
    final audioList =
        Provider.of<MainProvider>(context, listen: false).audioList;
    final actorList =
        Provider.of<MainProvider>(context, listen: false).actorList;
    final directorList =
        Provider.of<MainProvider>(context, listen: false).directorList;
    final myWishList = Provider.of<WishListProvider>(context, listen: false);
    await myWishList.getWishList(context);
    final mWishList = Provider.of<WishListProvider>(context, listen: false)
        .wishListModel!
        .wishlist;
    for (int i = 0; i < moviesTvList.length; i++) {
      for (int j = 0; j < mWishList!.length; j++) {
        if (moviesTvList[i].type == DatumType.M) {
          if ("${moviesTvList[i].id}" == "${mWishList[j].movieId}") {
            var genreData = moviesTvList[i].genreId == null
                ? null
                : moviesTvList[i].genreId!.split(",").toList();
            var actors = moviesTvList[i].actorId == null
                ? null
                : moviesTvList[i].actorId!.split(",").toList();
            var directors = moviesTvList[i].directorId == null
                ? null
                : moviesTvList[i].directorId!.split(",").toList();
            var audios = moviesTvList[i].aLanguage == null
                ? null
                : moviesTvList[i].aLanguage!.split(",").toList();
            moviesWishList.add(Datum(
              id: moviesTvList[i].id,
              actorId: moviesTvList[i].actorId,
              title: moviesTvList[i].title,
              trailerUrl: moviesTvList[i].trailerUrl,
              status: moviesTvList[i].status,
              keyword: moviesTvList[i].keyword,
              description: moviesTvList[i].description,
              duration: moviesTvList[i].duration,
              thumbnail: moviesTvList[i].thumbnail,
              poster: moviesTvList[i].poster,
              directorId: moviesTvList[i].directorId,
              detail: moviesTvList[i].detail,
              rating: moviesTvList[i].rating,
              maturityRating: moviesTvList[i].maturityRating,
              publishYear: moviesTvList[i].publishYear,
              released: moviesTvList[i].released,
              uploadVideo: moviesTvList[i].uploadVideo,
              featured: moviesTvList[i].featured,
              series: moviesTvList[i].series,
              aLanguage: moviesTvList[i].aLanguage,
              live: moviesTvList[i].live,
              createdBy: moviesTvList[i].createdBy,
              createdAt: moviesTvList[i].createdAt,
              updatedAt: moviesTvList[i].updatedAt,
              userRating: moviesTvList[i].userRating,
              movieSeries: moviesTvList[i].movieSeries,
              videoLink: moviesTvList[i].videoLink,
              genre: List.generate(genreData == null ? 0 : genreData.length,
                  (int genreIndex) {
                return "${genreData![genreIndex]}";
              }),
              genres: List.generate(genreList.length, (int gIndex) {
                var genreId2 = genreList[gIndex].id.toString();
                var genreNameList = List.generate(
                    genreData == null ? 0 : genreData.length, (int nameIndex) {
                  return "${genreData![nameIndex]}";
                });
                var isAv2 = 0;
                for (var y in genreNameList) {
                  if (genreId2 == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (genreList[gIndex].name == null) {
                    return null;
                  } else {
                    return "${genreList[gIndex].name}";
                  }
                }
                return null;
              }),
              actor: List.generate(actors == null ? 0 : actors.length,
                  (int aIndex) {
                return "${actors![aIndex]}";
              }),
              actors: List.generate(actorList.length, (actIndex) {
                var actorsId = actorList[actIndex].id.toString();
                var actorsIdList = List.generate(
                    actors == null ? 0 : actors.length, (int idIndex) {
                  return "${actors![idIndex]}";
                });
                var isAv2 = 0;
                for (var y in actorsIdList) {
                  if (actorsId == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (actorList[actIndex].name == null) {
                    return null;
                  } else {
                    return Actor(
                      id: actorList[actIndex].id,
                      name: actorList[actIndex].name,
                      image: actorList[actIndex].image,
                      biography: actorList[actIndex].biography,
                      placeOfBirth: actorList[actIndex].placeOfBirth,
                      dob: actorList[actIndex].dob,
                      createdAt: actorList[actIndex].createdAt,
                      updatedAt: actorList[actIndex].updatedAt,
                    );
                  }
                }
                return null;
              }),
              directors: List.generate(directorList.length, (actIndex) {
                var directorsId = directorList[actIndex].id.toString();
                var actorsIdList = List.generate(
                    directors == null ? 0 : directors.length, (int idIndex) {
                  return "${directors![idIndex]}";
                });
                var isAv2 = 0;
                for (var y in actorsIdList) {
                  if (directorsId == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (directorList[actIndex].name == null) {
                    return null;
                  } else {
                    return Director(
                      id: directorList[actIndex].id,
                      name: directorList[actIndex].name,
                      image: directorList[actIndex].image,
                      biography: directorList[actIndex].biography,
                      placeOfBirth: directorList[actIndex].placeOfBirth,
                      dob: directorList[actIndex].dob,
                      createdAt: directorList[actIndex].createdAt,
                      updatedAt: directorList[actIndex].updatedAt,
                    );
                  }
                }
                return null;
              }),
              audios: List.generate(audioList.length, (actIndex) {
                var actorsId = audioList[actIndex].id.toString();
                var audioIdList = List.generate(
                    audios == null ? 0 : audios.length, (int idIndex) {
                  return "${audios![idIndex]}";
                });
                var isAv2 = 0;
                for (var y in audioIdList) {
                  if (actorsId == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (audioList[actIndex].language == null) {
                    return null;
                  } else {
                    return "${audioList[actIndex].language}";
                  }
                }
                return null;
              }),
              comments: List.generate(
                  moviesTvList[i].comments == null
                      ? 0
                      : moviesTvList[i].comments!.length, (cIndex) {
                return Comment(
                  id: moviesTvList[i].comments![cIndex].id,
                  name: moviesTvList[i].comments![cIndex].name,
                  email: moviesTvList[i].comments![cIndex].email,
                  movieId: moviesTvList[i].comments![cIndex].movieId,
                  tvSeriesId: moviesTvList[i].comments![cIndex].tvSeriesId,
                  comment: moviesTvList[i].comments![cIndex].comment,
                  subcomments: moviesTvList[i].comments![cIndex].subcomments,
                  createdAt: moviesTvList[i].comments![cIndex].createdAt,
                  updatedAt: moviesTvList[i].comments![cIndex].updatedAt,
                );
              }),
              episodeRuntime: moviesTvList[i].episodeRuntime,
              genreId: moviesTvList[i].genreId,
              type: moviesTvList[i].type,
              tmdbId: moviesTvList[i].tmdbId,
              tmdb: moviesTvList[i].tmdb,
              fetchBy: moviesTvList[i].fetchBy,
            ));
          }
        } else {
          print("wishlist : ${mWishList[j].seasonId} && ${moviesTvList[i].id}");
          if ("${moviesTvList[i].id}" == "${mWishList[j].seasonId}") {
            tvWishList.add(moviesTvList[i]);
          }
        }
      }
    }
    setState(() {
      _visible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _visible = false;
    });
    _scrollViewController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((timestamp) {
      fetchWishList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width * 0.04;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                // titleSpacing: 0.0,
                centerTitle: true,
                title: Text(
                  "Wishlist",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18.0, color: Colors.white, letterSpacing: 0.9),
                ),

                // centerTitle: true,
                backgroundColor: Theme.of(context).primaryColorDark,
                floating: true,
                pinned: true,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: Container(
                    margin: EdgeInsets.only(left: w, right: w),
                    decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        // border: Border.all(
                        //     color: Theme.of(context)
                        //         .primaryColor
                        //         .withOpacity(0.2)),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TabBar(
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.black,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.amber),
                      indicatorSize: TabBarIndicatorSize.tab,
                      // indicatorColor: Theme.of(context).primaryColor,
                      isScrollable: false,
                      tabs: [
                        new Tab(
                          child: Container(
                            // margin: EdgeInsets.only(left: w, right: w),
                            child: Text("Movies"),
                          ),
                        ),
                        new Tab(
                          child: Container(
                            // padding: EdgeInsets.only(left: w, right: w),
                            child: Text("TV Series"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              MoviesWishList(_visible),
              TVSeriesWishList(_visible),
            ],
          ),
        ),
      ),
    ));
  }
}

class MoviesWishList extends StatefulWidget {
  MoviesWishList(this._visible);
  final bool _visible;

  @override
  _MoviesWishListState createState() => _MoviesWishListState();
}

class _MoviesWishListState extends State<MoviesWishList> {
  Future<String?> removeWishList(vType, id) async {
    final response = await http.get(
        Uri.parse("${APIData.removeWatchlistMovie}$id"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    if (response.statusCode == 200) {
      moviesWishList
          .removeWhere((element) => element.type == vType && element.id == id);
      setState(() {});
    }
    return null;
  }

  // PlaceHolder image displayed on the watchlist item.
  Widget placeHolderImage(movies) {
    return Expanded(
      flex: 5,
      child: Container(
        child: new ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: new FadeInImage.assetNetwork(
            image: "${APIData.movieImageUri}${movies.thumbnail}",
            placeholder: "assets/placeholder_box.jpg",
            height: 115.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget watchlistItemDetails(movies, genres) {
    return Expanded(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 6.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movies.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '$genres',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                  ),
                ],
              ),
              IconButton(
                  icon: Icon(
                    CupertinoIcons.delete_simple,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: () {
                    removeWishList(movies.type, movies.id);
                  }),
            ],
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'RELEASE DATE:',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          movies.released != null
                              ? DateFormat('d-MM-y').format(movies.released)
                              : "N/A",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'RUNTIME:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        movies.duration != null
                            ? movies.duration != "0" && movies.duration != 0
                                ? movies.duration
                                : "N/A"
                            : "N/A",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //  Watchlist item all details like image, name,
  Widget watchlistItemContainer(movies, genres) {
    return Container(
      color: Colors.transparent,
      margin: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.videoDetail,
              arguments: VideoDetailScreen(movies));
        },
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              placeHolderImage(movies),
              SizedBox(
                width: 10.0,
                height: 0.0,
              ),
              watchlistItemDetails(movies, genres),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget._visible == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : moviesWishList.length == 0
            ? BlankWishList()
            : Container(
                child: ListView.builder(
                    itemCount: moviesWishList.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    itemBuilder: (BuildContext context, int index) {
                      moviesWishList[index]
                          .genres!
                          .removeWhere((value) => value == null);
                      String genres = moviesWishList[index].genres.toString();
                      genres = genres.replaceAll("[", "").replaceAll("]", "");
                      return watchlistItemContainer(
                          moviesWishList[index], genres);
                    }),
              );
  }
}

class TVSeriesWishList extends StatefulWidget {
  TVSeriesWishList(this._visible);
  final bool _visible;

  @override
  _TVSeriesWishListState createState() => _TVSeriesWishListState();
}

class _TVSeriesWishListState extends State<TVSeriesWishList> {
  Future<String?> removeWishList(vType, id) async {
    final response = await http.get(
        Uri.parse("${APIData.removeWatchlistSeason}$id"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    if (response.statusCode == 200) {
      tvWishList
          .removeWhere((element) => element.type == vType && element.id == id);
      setState(() {});
    }
    return null;
  }

  // PlaceHolder image displayed on the watchlist item.
  Widget placeHolderImage(tvSeries) {
    return Expanded(
      flex: 5,
      child: Container(
        child: new ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: new FadeInImage.assetNetwork(
            image: "${APIData.tvImageUriTv}${tvSeries.thumbnail}",
            placeholder: "assets/placeholder_box.jpg",
            height: 115.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget watchlistItemDetails(tvSeries, genres) {
    return Expanded(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 6.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tvSeries.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '$genres',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                  ),
                ],
              ),
              IconButton(
                  icon: Icon(
                    CupertinoIcons.delete_simple,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: () {
                    removeWishList(tvSeries.type, tvSeries.id);
                  }),
            ],
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'RELEASE DATE:',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      tvSeries.released == null
                          ? "N/A"
                          : DateFormat('d-MM-y').format(tvSeries.released),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'RUNTIME:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      tvSeries.duration != null
                          ? tvSeries.duration != "0" && tvSeries.duration != 0
                              ? tvSeries.duration
                              : "N/A"
                          : "N/A",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //  Watchlist item all details like image, name,
  Widget watchlistItemContainer(tvSeries, genres) {
    return Container(
      color: Colors.transparent,
      margin: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.videoDetail,
              arguments: VideoDetailScreen(tvSeries));
        },
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              placeHolderImage(tvSeries),
              SizedBox(
                width: 10.0,
                height: 0.0,
              ),
              watchlistItemDetails(tvSeries, genres),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("tv : ${tvWishList.length}");
    return widget._visible == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : tvWishList.length == 0
            ? BlankWishList()
            : Container(
                child: ListView.builder(
                    itemCount: tvWishList.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    itemBuilder: (BuildContext context, int index) {
                      tvWishList[index]
                          .genres!
                          .removeWhere((value) => value == null);
                      String genres = tvWishList[index].genres.toString();
                      genres = genres.replaceAll("[", "").replaceAll("]", "");
                      return watchlistItemContainer(tvWishList[index], genres);
                    }),
              );
  }
}
