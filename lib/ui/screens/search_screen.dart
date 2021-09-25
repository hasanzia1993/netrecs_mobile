import 'package:flutter/material.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/models/episode.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:nexthour/ui/screens/video_detail_screen.dart';
import 'package:nexthour/ui/shared/card_seperator.dart';
import 'package:nexthour/ui/shared/ratings.dart';
import 'package:provider/provider.dart';
// import 'bottom_navigations_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  late String filter;
  var focusNode = new FocusNode();
  bool descTextShowFlag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var found = false;

  // No result found page ui container
  Widget noResultFound() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "No Result Found.",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    Text(
                      "We can't find any item matching your search.",
                      style: TextStyle(fontSize: 14.0, color: Colors.white54),
                      textAlign: TextAlign.left,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // Default search page UI container
  Widget defaultSearchPage() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Find what to watch next.",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    Text(
                      "Search for shows for the commute, movies to help unwind, or your go-to genres.",
                      style: TextStyle(fontSize: 14.0, color: Colors.white54),
                      textAlign: TextAlign.left,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // Default place holder image
  Widget defaultPlaceHolderImage(index) {
    var movieTvList = Provider.of<MovieTVProvider>(context).movieTvList;
    return Container(
      alignment: FractionalOffset.centerLeft,
      child: new Hero(
        tag: "planet-hero-${movieTvList[index].title}",
        child: new ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: movieTvList[index].thumbnail == null
              ? Image.asset(
                  "assets/placeholder_box.jpg",
                  height: 140.0,
                  width: 110.0,
                  fit: BoxFit.cover,
                )
              : FadeInImage.assetNetwork(
                  image: movieTvList[index].type == DatumType.T
                      ? "${APIData.tvImageUriTv}${movieTvList[index].thumbnail}"
                      : "${APIData.movieImageUri}${movieTvList[index].thumbnail}",
                  placeholder: "assets/placeholder_box.jpg",
                  height: 140.0,
                  width: 110.0,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  // search item column
  Widget searchItemColumn(index) {
    var movieTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(height: 4.0),
        new Text(
          movieTvList[index].title!,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
          maxLines: 1,
        ),
        new Container(height: 10.0),
        new Text(
          movieTvList[index].description!,
          style: TextStyle(color: Colors.white54),
          maxLines: 2,
        ),
        new Separator(),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                flex: 1,
                child: new Container(
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new RatingInformationSearch(movieTvList[index])
                      ]),
                )),
            new Container(
              width: 32.0,
            ),
          ],
        ),
      ],
    );
  }

  // List container
  Widget listContainer(index) {
    var movieTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            new Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                constraints: BoxConstraints.expand(),
                child: searchItemColumn(index),
              ),
              height: 140.0,
              margin: new EdgeInsets.only(left: 46.0),
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(8.0),
                // boxShadow: <BoxShadow>[
                //   new BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 10.0,
                //     offset: new Offset(0.0, 10.0),
                //   ),
                // ],
              ),
            ),
            defaultPlaceHolderImage(index),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.videoDetail,
              arguments: VideoDetailScreen(movieTvList[index]));
        },
      ),
    );
  }

  // Search result item column
  Widget searchResultItemColumn() {
    var movieTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    return Column(
      children: <Widget>[
        new Expanded(
            child: searchController.text == ''
                ? defaultSearchPage()
                : Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                      itemCount: movieTvList.length,
                      itemBuilder: (context, index) {
                        return '${movieTvList[index].title}'
                                .toLowerCase()
                                .contains(filter.toLowerCase())
                            ? listContainer(index)
                            : Container();
                      },
                    ))),
      ],
    );
  }

  // Search TexField
  Widget searchField() {
    return TextField(
      focusNode: focusNode,
      controller: searchController,
      style: TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        hintText: 'Search for a show, movie, etc.',
        border: InputBorder.none,
      ),
    );
  }

  //  App bar
  Widget appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: searchField(),
      backgroundColor: Theme.of(context).primaryColorLight,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: searchController.text == ''
              ? new IconButton(
                  icon: new Icon(Icons.search,
                      color: Colors.grey.withOpacity(0.3)),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                )
              : new IconButton(
                  icon: new Icon(Icons.clear,
                      color: Colors.white.withOpacity(1.0)),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var movieTVList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    if (searchController.text == '' || searchController.text == null) {
      found = true;
    } else {
      for (var i = 0; i < movieTVList.length; i++) {
        var watchName = '${movieTVList[i].title}';
        var watchListItemName =
            watchName.toLowerCase().contains(filter.toLowerCase());
        if (watchListItemName == true) {
          found = true;
          break;
        } else {
          found = false;
        }
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar() as PreferredSizeWidget?,
      body: found == false ? noResultFound() : searchResultItemColumn(),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }
}
