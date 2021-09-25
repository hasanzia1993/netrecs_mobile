import 'dart:convert';
import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/models/comment.dart';
import 'package:nexthour/models/datum.dart';
import 'package:nexthour/models/episode.dart';
import 'package:nexthour/models/task_info.dart';
import 'package:nexthour/player/iframe_player.dart';
import 'package:nexthour/player/m_player.dart';
import 'package:nexthour/player/player_episodes.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/providers/menu_data_provider.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/services/download/download_episode_page.dart';
import 'package:nexthour/services/download/download_page.dart';
import 'package:nexthour/ui/shared/artist_list.dart';
import 'package:nexthour/ui/shared/color_loader.dart';
import 'package:nexthour/ui/shared/container_border.dart';
import 'package:nexthour/ui/shared/description_text.dart';
import 'package:nexthour/ui/shared/rate_us.dart';
import 'package:nexthour/ui/shared/seasons_artist_list.dart';
import 'package:nexthour/ui/shared/share_page.dart';
import 'package:nexthour/ui/shared/tab_widget.dart';
import 'package:nexthour/ui/shared/wishlist.dart';
import 'package:nexthour/ui/widgets/seasons_tab.dart';
import 'package:nexthour/ui/widgets/video_detail_header.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

int episodesCounting = 0;
int cSeasonIndex = 0;

class VideoDetailScreen extends StatefulWidget {
  final Datum? videoDetail;
  VideoDetailScreen(this.videoDetail);
  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen>
    with TickerProviderStateMixin, RouteAware {
  var mReadyUrl,
      mIFrameUrl,
      mUrl360,
      mUrl480,
      mUrl720,
      mUrl1080,
      youtubeUrl,
      vimeoUrl;
  var screenUsed1, screenUsed2, screenUsed3, screenUsed4;
  ScrollController? _scrollController;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex2 = 0;
  late TabController _tabController;
  late TabController _episodeTabController;
  TabController? _seasonsTabController;
  TextEditingController commentsController = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  var dMsg = '';
  List<Comment>? commentList = [];

  Widget heading(heading) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        heading,
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: Colors.white),
      ),
    );
  }

  // Sliver app bar tabs
  Widget _sliverAppBar(innerBoxIsScrolled) => SliverAppBar(
        titleSpacing: 0.00,
        elevation: 0.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomBorder(),
            TabBar(
                onTap: (currentIndex) {
                  setState(() {
                    cSeasonIndex = currentIndex;
                  });
                },
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      // color: Color.fromRGBO(125, 183, 91, 1.0),
                      color: Theme.of(context).primaryColor,
                      width: 2.5),
                  insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 46.0),
                ),
                indicatorColor: Colors.orangeAccent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                indicatorPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                unselectedLabelColor: Color.fromRGBO(95, 95, 95, 1.0),
                tabs: [
                  TabWidget('MORE LIKE THIS'),
                  TabWidget('MORE DETAILS'),
                ]),
          ],
        ),
        pinned: true,
        floating: true,
        forceElevated: innerBoxIsScrolled,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColorDark,
      );

  Widget movieSliverList() {
    final platform = Theme.of(context).platform;
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int j) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoDetailHeader(widget.videoDetail),
              widget.videoDetail!.description == null ||
                      widget.videoDetail!.description == ""
                  ? SizedBox.shrink()
                  : DescriptionText(widget.videoDetail!.description),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WishListView(widget.videoDetail),
                  RateUs(widget.videoDetail!.type, widget.videoDetail!.id),
                  SharePage(APIData.shareMovieUri, widget.videoDetail!.id),
                  widget.videoDetail!.type == DatumType.M
                      ? DownloadPage(widget.videoDetail!, platform)
                      : SizedBox.shrink(),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              widget.videoDetail!.actors!.length == 0
                  ? SizedBox.shrink()
                  : heading("Artist"),
              SizedBox(
                height: 5.0,
              ),
              ArtistList(widget.videoDetail),
            ],
          ),
        );
      }, childCount: 1),
    );
  }

  // Tab bar for similar movies or tv series
  Widget _tabBarView(moreLikeThis) {
    return TabBarView(children: <Widget>[
      new ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          tapOnMoreLikeThis(moreLikeThis),
        ],
      ),
      moreDetails()
    ]);
  }

  Widget tapOnMoreLikeThis(moreLikeThis) {
    return Container(
      height: 300.0,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        scrollDirection: Axis.horizontal,
        children: List<Padding>.generate(
            moreLikeThis == null ? 0 : moreLikeThis.length, (int index) {
          return Padding(
            padding: EdgeInsets.only(right: 2.5, left: 2.5, bottom: 5.0),
            child: moreLikeThis[index] == null
                ? Container()
                : cusPlaceHolder(moreLikeThis, index),
          );
        }),
      ),
    );
  }

  Widget moreDetails() {
    var commentsStatus = Provider.of<AppConfig>(context, listen: false)
        .appModel!
        .config!
        .comments;
    widget.videoDetail!.genres!.removeWhere((value) => value == null);
    String genres = widget.videoDetail!.genres.toString();
    genres = genres.replaceAll("[", "").replaceAll("]", "");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.videoDetail!.type == DatumType.T
              ? TabBar(
                  onTap: (currentIndex2) {
                    setState(() {
                      _currentIndex2 = currentIndex2;
                    });
                  },
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        // color: Color.fromRGBO(125, 183, 91, 1.0),
                        color: Theme.of(context).primaryColor,
                        width: 2.5),
                    insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 46.0),
                  ),
                  indicatorColor: Colors.orangeAccent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3.0,
                  unselectedLabelColor: Color.fromRGBO(95, 95, 95, 1.0),
                  tabs: [
                      TabWidget('EPISODES'),
                      TabWidget('MORE DETAILS'),
                    ])
              : SizedBox(
                  width: 0.0,
                ),
          genresDetailsContainer(widget.videoDetail, genres),
          commentsStatus == 1 || "$commentsStatus" == "1"
              ? comments()
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget comments() {
    return Container(
      color: Color.fromRGBO(45, 45, 45, 1.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Comments",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              RaisedButton(
                onPressed: () {
                  addComment(context);
                },
                child: Text("Add"),
                color: activeDotColor,
              ),
            ],
          ),
          getCommentsList(commentList!),
        ],
      ),
    );
  }

  Widget getCommentsList(List<Comment> comments) {
    List<Widget> list = [];
    for (int i = 0; i < comments.length; i++) {
      list.add(Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comments[i].name!,
                style: TextStyle(
                    fontSize: 16.0, color: Colors.white.withOpacity(0.9))),
            SizedBox(
              height: 6.0,
            ),
            Text(
                DateFormat.yMMMd().format(
                  DateTime.parse("${comments[i].createdAt}"),
                ),
                style: TextStyle(
                    fontSize: 12.0, color: Colors.white.withOpacity(0.6))),
            SizedBox(
              height: 10.0,
            ),
            Text(comments[i].comment!,
                style: TextStyle(
                    fontSize: 14.0, color: Colors.white.withOpacity(0.7))),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

  Future<void> addComment(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.only(left: 25.0, right: 25.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          title: Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Add Comments',
              style:
                  TextStyle(color: activeDotColor, fontWeight: FontWeight.w600),
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextFormField(
                      controller: commentsController,
                      maxLines: 4,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                        hintText: "Comment",
                        errorStyle: TextStyle(fontSize: 10),
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.4), fontSize: 18),
                      ),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 18),
                      validator: (val) {
                        if (val!.length == 0) {
                          return "Comment can not be blank.";
                        }
                        return null;
                      },
                      onSaved: (val) => commentsController.text = val!,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                InkWell(
                  child: Container(
                    color: activeDotColor,
                    height: 45.0,
                    width: 100.0,
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                    child: Center(
                      child: Text(
                        "Post",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () {
                    final form = _formKey.currentState!;
                    form.save();
                    if (form.validate() == true) {
                      postComment();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> postComment() async {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel!;
    var type = widget.videoDetail!.type == DatumType.M ? "M" : "T";
    final postCommentResponse =
        await http.post(Uri.parse(APIData.postBlogComment), body: {
      "type": '$type',
      "id": '${widget.videoDetail!.id}',
      "comment": '${commentsController.text}',
      "name": '${userDetails.user!.name}',
      "email": '${userDetails.user!.email}',
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    if (postCommentResponse.statusCode == 200) {
      commentList!.add(
        Comment(
          id: widget.videoDetail!.id,
          name: "${userDetails.user!.name}",
          email: "${userDetails.user!.email}",
          comment: commentsController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      setState(() {});
      commentsController.text = '';
      Fluttertoast.showToast(msg: "Commented Successfully");
      commentsController.text = '';
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Error in commenting");
      commentsController.text = '';
      Navigator.pop(context);
    }
    return null;
  }

  Widget genresDetailsContainer(videoDetail, genres) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "About",
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              height: 8.0,
            ),
            genreNameRow(videoDetail),
            genresRow(genres),
            videoDetail.type == DatumType.T
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Details:',
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 13.0),
                          ),
                        ),
                        genreDetailsText(videoDetail),
                      ],
                    ))
                : SizedBox(
                    width: 0.0,
                  ),
            audioLangRow(widget.videoDetail),
          ],
        ),
      ),
      color: Theme.of(context).primaryColorLight,
    );
  }

  Widget audioLangRow(videoDetail) {
    if (widget.videoDetail!.audios != null ||
        "${widget.videoDetail!.audios}" != "null") {
      widget.videoDetail!.audios!.removeWhere((element) => element == null);
    }
    var audioLang = widget.videoDetail!.audios.toString();
    var w = audioLang.replaceAll("[", "");
    var s = w.replaceAll("]", "");
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                'Audio Language:',
                style: TextStyle(
                    color: Theme.of(context).hintColor, fontSize: 13.0),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  "$s",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 13.0),
                ),
              ),
            ),
          ],
        ));
  }

  Widget genresRow(genres) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                'Genres:',
                style: TextStyle(
                    color: Theme.of(context).hintColor, fontSize: 13.0),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  "$genres",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 13.0),
                ),
              ),
            ),
          ],
        ));
  }

  Widget genreNameRow(videoDetail) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                'Name:',
                style: TextStyle(
                    color: Theme.of(context).hintColor, fontSize: 13.0),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  "${videoDetail.title}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 13.0),
                ),
              ),
            ),
          ],
        ));
  }

  //  Genre details text
  Widget genreDetailsText(videoDetail) {
    return Expanded(
      flex: 5,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          "${videoDetail.seasons[cSeasonIndex].detail}",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }

  //  Customer also watched videos place holder
  Widget cusPlaceHolder(moreLikeThis, index) {
    return InkWell(
      child: moreLikeThis[index].thumbnail == null
          ? Image.asset(
              'assets/placeholder_box.jpg',
              height: 150.0,
              fit: BoxFit.cover,
            )
          : FadeInImage.assetNetwork(
              image: "${APIData.movieImageUri}${moreLikeThis[index].thumbnail}",
              placeholder: 'assets/placeholder_box.jpg',
              height: 150.0,
              fit: BoxFit.cover,
            ),
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.videoDetail,
            arguments: VideoDetailScreen(moreLikeThis[index]));
      },
    );
  }

//   Getting list of episodes of different seasons
  Future<String?> getData(currentIndex) async {
    setState(() {
      seasonEpisodeData = null;
    });
    final episodesResponse = await http.get(
        Uri.parse(APIData.episodeDataApi +
            "${widget.videoDetail!.seasons![currentIndex].id}"),
        headers: {
          // ignore: deprecated_member_use
          HttpHeaders.authorizationHeader: "Bearer $authToken"
        });
    var episodesData = json.decode(episodesResponse.body);
    if (this.mounted) {
      setState(() {
        seasonEpisodeData = episodesData['episodes'];
      });
    }
    episodesCount = episodesData['episodes'].length;
    _prepare();
    return null;
  }

//  Scaffold that contains overall UI of his page
  Widget scaffold(moreLikeThis) {
    return Scaffold(
      key: _scaffoldKey,
      body: widget.videoDetail!.type == DatumType.T
          ? _seasonsScrollView()
          : _movieScrollView(moreLikeThis),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }

  Widget _movieScrollView(moreLikeThis) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          movieSliverList(),
          _sliverAppBar(innerBoxIsScrolled),
        ];
      },
      body: _tabBarView(moreLikeThis),
    );
  }

  //  Detailed page for tv series
  Widget _seasonsScrollView() {
    var videoDetailCheck = widget.videoDetail;
    var allSeasonsCheck = videoDetailCheck!.seasons![0];
    return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            sliverList(),
            sliverAppbarSeasons(innerBoxIsScrolled),
          ];
        },
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.0,
            ),
            allSeasonsCheck.actorList == null
                ? SizedBox.shrink()
                : heading("Artist"),
            SizedBox(
              height: 10.0,
            ),
            allSeasonsCheck.actorList == null
                ? SizedBox.shrink()
                : SeasonsArtistList(widget.videoDetail),
            SizedBox(
              height: 25.0,
            ),
            _currentIndex2 == 0 ? allEpisodes() : moreDetails(),
          ],
        )));
  }

  /*
    This widget show the list of all episodes of particular seasons .
    This widget should not be declared outside of this page other play creating issues.
*/
  Widget allEpisodes() {
    var tvSeriesList = Provider.of<MovieTVProvider>(context).tvSeriesList;
    if (seasonEpisodeData == null) {
      return Container(
        height: 200.0,
        alignment: Alignment.center,
        child: ColorLoader(),
      );
    } else {
      List moreLikeThis = new List<Datum?>.generate(
          tvSeriesList == null ? 0 : tvSeriesList.length, (int index) {
        var genreIds2Count = tvSeriesList[index].genre!.length;
        var genreIds2All = tvSeriesList[index].genre;
        for (var j = 0; j < genreIds2Count; j++) {
          var genreIds2 = genreIds2All![j];
          var isAv = 0;
          for (var i = 0; i < widget.videoDetail!.genre!.length; i++) {
            var genreIds = widget.videoDetail!.genre![i].toString();

            if (genreIds2 == genreIds) {
              isAv = 1;
              break;
            }
          }
          if (isAv == 1) {
            if (widget.videoDetail!.type == tvSeriesList[index].type) {
              if (widget.videoDetail!.id != tvSeriesList[index].id) {
                return tvSeriesList[index];
              }
            }
          }
        }
        return null;
      });

      moreLikeThis.removeWhere((item) => item == null);
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tabBar(),
            episodesList(),
            cusAlsoWatchedText(),
            moreLikeThisSeasons(moreLikeThis),
          ],
        ),
        color: Theme.of(context).primaryColorDark,
      );
    }
  }

  Widget cusAlsoWatchedText() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 25.0, 0, 5.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [heading("Customers also watched")]),
    );
  }

  //  More like this video for seasons
  Widget moreLikeThisSeasons(moreLikeThis) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          height: 300.0,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            scrollDirection: Axis.horizontal,
            children: List<Padding>.generate(
                moreLikeThis == null ? 0 : moreLikeThis.length, (int index) {
              return new Padding(
                padding: EdgeInsets.only(right: 2.5, left: 2.5, bottom: 5.0),
                child: moreLikeThis[index] == null
                    ? Container()
                    : InkWell(
                        child: moreLikeThis[index].thumbnail == null
                            ? Image.asset(
                                'assets/placeholder_box.jpg',
                                height: 150.0,
                                fit: BoxFit.cover,
                              )
                            : FadeInImage.assetNetwork(
                                image:
                                    "${APIData.tvImageUriTv}${moreLikeThis[index].thumbnail}",
                                placeholder: 'assets/placeholder_box.jpg',
                                height: 150.0,
                                fit: BoxFit.cover,
                              ),
                        onTap: () => Navigator.pushNamed(
                            context, RoutePaths.videoDetail,
                            arguments: VideoDetailScreen(moreLikeThis[index])),
                      ),
              );
            }),
          ),
        )
      ],
    );
  }

  //  Episode title
  Widget episodeTitle(i) {
    return Text('Episode ${seasonEpisodeData[i]['episode_no']}',
        style: TextStyle(fontSize: 14.0, color: Colors.white));
  }

  //  Episode subtitle
  Widget episodeSubtitle(i) {
    return Text(
      '${seasonEpisodeData[i]['title']}',
      style: TextStyle(
        fontSize: 12.0,
      ),
    );
  }

  //  Episodes details like released date and description
  Widget episodeDetails(i) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              '${seasonEpisodeData[i]['detail']}',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                  'Released: ' + '${seasonEpisodeData[i]['released']}',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  //  Play button for particular episode.
  Widget gestureDetector(i) {
    var userDetails =
        Provider.of<UserProfileProvider>(context).userProfileModel;
    return GestureDetector(
      child: Icon(
        Icons.play_circle_outline,
        color: Colors.white,
        size: 35.0,
      ),
      onTap: () {
        if (userDetails!.active == "1" || userDetails.active == 1) {
          mReadyUrl = seasonEpisodeData[i]['video_link']['ready_url'];
          mUrl360 = seasonEpisodeData[i]['video_link']['url_360'];
          mUrl480 = seasonEpisodeData[i]['video_link']['url_480'];
          mUrl720 = seasonEpisodeData[i]['video_link']['url_720'];
          mUrl1080 = seasonEpisodeData[i]['video_link']['url_1080'];
          mIFrameUrl = seasonEpisodeData[i]['video_link']['iframeurl'];
          var title = seasonEpisodeData[i]['title'];

          if (mIFrameUrl != null ||
              mReadyUrl != null ||
              mUrl360 != null ||
              mUrl480 != null ||
              mUrl720 != null ||
              mUrl1080 != null) {
            if (mIFrameUrl != null) {
              var matchIFrameUrl = mIFrameUrl.substring(0, 24);
              if (matchIFrameUrl == 'https://drive.google.com') {
                var ind = mIFrameUrl.lastIndexOf('d/');
                var t = "$mIFrameUrl".trim().substring(ind + 2);
                var rep = t.replaceAll('/preview', '');
                var newurl =
                    "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
                getAllScreens(newurl, "CUSTOM", title);
              } else {
                getAllScreens(mIFrameUrl, "EMD", title);
              }
            } else if (mReadyUrl != null) {
              var checkMp4 = seasonEpisodeData[i]['video_link']['ready_url']
                  .substring(mReadyUrl.length - 4);
              var checkMpd = seasonEpisodeData[i]['video_link']['ready_url']
                  .substring(mReadyUrl.length - 4);
              var checkWebm = seasonEpisodeData[i]['video_link']['ready_url']
                  .substring(mReadyUrl.length - 5);
              var checkMkv = seasonEpisodeData[i]['video_link']['ready_url']
                  .substring(mReadyUrl.length - 4);
              var checkM3u8 = seasonEpisodeData[i]['video_link']['ready_url']
                  .substring(mReadyUrl.length - 5);

              if (seasonEpisodeData[i]['video_link']['ready_url']
                      .substring(0, 18) ==
                  "https://vimeo.com/") {
                getAllScreens(seasonEpisodeData[i]['id'], "JS", title);
              } else if (seasonEpisodeData[i]['video_link']['ready_url']
                      .substring(0, 29) ==
                  'https://www.youtube.com/embed') {
                getAllScreens(mReadyUrl, "EMD", title);
              } else if (seasonEpisodeData[i]['video_link']['ready_url']
                      .substring(0, 23) ==
                  'https://www.youtube.com') {
                getAllScreens(seasonEpisodeData[i]['id'], "JS", title);
              } else if (checkMp4 == ".mp4" ||
                  checkMpd == ".mpd" ||
                  checkWebm == ".webm" ||
                  checkMkv == ".mkv" ||
                  checkM3u8 == ".m3u8") {
                getAllScreens(mReadyUrl, "CUSTOM", title);
              } else {
                getAllScreens(seasonEpisodeData[i]['id'], "JS", title);
              }
            } else if (mUrl360 != null ||
                mUrl480 != null ||
                mUrl720 != null ||
                mUrl1080 != null) {
              _showDialog(i);
            } else {
              getAllScreens(seasonEpisodeData[i]['id'], "JS", title);
            }
          } else {
            Fluttertoast.showToast(msg: "Video URL doesn't exist");
          }
        } else {
          _showMsg();
        }
      },
    );
  }

  void _showMsg() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel!;
    if (userDetails.paypal!.length == 0 ||
        userDetails.user!.subscriptions == null ||
        userDetails.user!.subscriptions!.length == 0) {
      dMsg = "Watch unlimited movies, TV shows and videos in HD or SD quality."
          " You don't have subscribe.";
    } else {
      dMsg = "Watch unlimited movies, TV shows and videos in HD or SD quality."
          " You don't have any active subscription plan.";
    }
    // set up the button
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: activeDotColor, fontSize: 16.0),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget subscribeButton = FlatButton(
      child: Text(
        "Subscribe",
        style: TextStyle(color: activeDotColor, fontSize: 16.0),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, RoutePaths.subscriptionPlans);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding:
          EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0, bottom: 0.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Subscribe Plans",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      content: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Text(
              "$dMsg",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      actions: [
        subscribeButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showDialog(i) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
            title: Text(
              "Video Quality",
              style: TextStyle(
                  color: Color.fromRGBO(72, 163, 198, 1.0),
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select Video Format in which you want to play video.",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7), fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  seasonEpisodeData[i]['video_link']['url_360'] == null
                      ? SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: RaisedButton(
                            hoverColor: Colors.red,
                            splashColor: Color.fromRGBO(49, 131, 41, 1.0),
                            highlightColor: Color.fromRGBO(72, 163, 198, 1.0),
                            color: activeDotColor,
                            child: Container(
                              alignment: Alignment.center,
                              width: 100.0,
                              height: 30.0,
                              child: Text("360"),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              print(
                                  "season Url: ${seasonEpisodeData[i]['video_link']['url_360']}");
                              var hdUrl =
                                  seasonEpisodeData[i]['video_link']['url_360'];
                              var hdTitle = seasonEpisodeData[i]['title'];
                              freeTrial(hdUrl, "CUSTOM", hdTitle);
                            },
                          ),
                        ),
                  seasonEpisodeData[i]['video_link']['url_480'] == null
                      ? SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: RaisedButton(
                            color: activeDotColor,
                            hoverColor: Colors.red,
                            splashColor: Color.fromRGBO(49, 131, 41, 1.0),
                            highlightColor: Color.fromRGBO(72, 163, 198, 1.0),
                            child: Container(
                              alignment: Alignment.center,
                              width: 100.0,
                              height: 30.0,
                              child: Text("480"),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              print(
                                  "season Url: ${seasonEpisodeData[i]['video_link']['url_480']}");
                              var hdUrl =
                                  seasonEpisodeData[i]['video_link']['url_480'];
                              var hdTitle = seasonEpisodeData[i]['title'];
                              freeTrial(hdUrl, "CUSTOM", hdTitle);
                            },
                          ),
                        ),
                  seasonEpisodeData[i]['video_link']['url_720'] == null
                      ? SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: RaisedButton(
                            hoverColor: Colors.red,
                            splashColor: Color.fromRGBO(49, 131, 41, 1.0),
                            highlightColor: Color.fromRGBO(72, 163, 198, 1.0),
                            color: activeDotColor,
                            child: Container(
                              alignment: Alignment.center,
                              width: 100.0,
                              height: 30.0,
                              child: Text("720"),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              print(
                                  "season Url: ${seasonEpisodeData[i]['video_link']['url_720']}");
                              var hdUrl =
                                  seasonEpisodeData[i]['video_link']['url_720'];
                              var hdTitle = seasonEpisodeData[i]['title'];
                              freeTrial(hdUrl, "CUSTOM", hdTitle);
                            },
                          ),
                        ),
                  seasonEpisodeData[i]['video_link']['url_1080'] == null
                      ? SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: RaisedButton(
                            hoverColor: Colors.red,
                            splashColor: Color.fromRGBO(49, 131, 41, 1.0),
                            highlightColor: Color.fromRGBO(72, 163, 198, 1.0),
                            color: activeDotColor,
                            child: Container(
                              alignment: Alignment.center,
                              width: 100.0,
                              height: 30.0,
                              child: Text("1080"),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              print(
                                  "season Url: ${seasonEpisodeData[i]['video_link']['url_1080']}");
                              var hdUrl = seasonEpisodeData[i]['video_link']
                                  ['url_1080'];
                              var hdTitle = seasonEpisodeData[i]['title'];
                              freeTrial(hdUrl, "CUSTOM", hdTitle);
                            },
                          ),
                        ),
                ],
              ),
            ));
      },
    );
  }

  Future<String?> addHistory(vType, id) async {
    var type = vType == DatumType.M ? "M" : "S";
    final response = await http.post(
        Uri.parse("${APIData.addWatchHistory}/$type/$id"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    print(response.statusCode);
    if (response.statusCode == 200) {
    } else {
      throw "can't added to history";
    }
    return null;
  }

  getAllScreens(mVideoUrl, type, title) async {
    if (type == "CUSTOM") {
      addHistory(widget.videoDetail!.type, widget.videoDetail!.id);
      var router = new MaterialPageRoute(
          builder: (BuildContext context) => MyCustomPlayer(
                url: mVideoUrl,
                title: title,
              ));
      Navigator.of(context).push(router);
    } else if (type == "EMD") {
      addHistory(widget.videoDetail!.type, widget.videoDetail!.id);
      var router = new MaterialPageRoute(
          builder: (BuildContext context) => IFramePlayerPage(url: mVideoUrl));
      Navigator.of(context).push(router);
    } else if (type == "JS") {
      addHistory(widget.videoDetail!.type, widget.videoDetail!.id);
      var router = new MaterialPageRoute(
        builder: (BuildContext context) => PlayerEpisode(
          id: mVideoUrl,
        ),
      );
      Navigator.of(context).push(router);
    }
  }

  freeTrial(videoURL, type, title) {
    if (type == "EMD") {
      addHistory(widget.videoDetail!.type, widget.videoDetail!.id);
      var router = new MaterialPageRoute(
          builder: (BuildContext context) => IFramePlayerPage(url: mIFrameUrl));
      Navigator.of(context).push(router);
    } else if (type == "CUSTOM") {
      addHistory(widget.videoDetail!.type, widget.videoDetail!.id);
      var router1 = new MaterialPageRoute(
          builder: (BuildContext context) => MyCustomPlayer(
                url: videoURL,
                title: title,
                downloadStatus: 1,
              ));
      Navigator.of(context).push(router1);
    } else {
      addHistory(widget.videoDetail!.type, widget.videoDetail!.id);
      var router = new MaterialPageRoute(
        builder: (BuildContext context) => PlayerEpisode(
          id: videoURL,
        ),
      );
      Navigator.of(context).push(router);
    }
  }

  //  Generate list of episodes
  Widget episodesList() {
    final platform = Theme.of(context).platform;
    return Padding(
      padding:
          const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
      child: Column(
        children: List.generate(
            seasonEpisodeData == null ? 0 : seasonEpisodeData.length, (int i) {
          dTasks = [];
          dItems = [];
          dTasks!.add(
            TaskInfo(
                eIndex: i,
                name: "${seasonEpisodeData[i]['title']}",
                ifLink: "${seasonEpisodeData[i]['video_link']['iframeurl']}",
                hdLink: "${seasonEpisodeData[i]['video_link']['ready_url']}",
                link360: "${seasonEpisodeData[i]['video_link']['url_360']}",
                link480: "${seasonEpisodeData[i]['video_link']['url_480']}",
                link720: "${seasonEpisodeData[i]['video_link']['url_720']}",
                link1080: "${seasonEpisodeData[i]['video_link']['url_1080']}"),
          );
          dItems!.add(ItemHolder(name: dTasks![0].name, task: dTasks![0]));
          return Container(
            child: Column(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(34, 34, 34, 1.0),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: gestureDetector(i),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          episodeTitle(i),
                          episodeSubtitle(i),
                          episodeDetails(i),
                        ],
                      ),
                    ),
                    DownloadEpisodePage(
                        widget.videoDetail,
                        widget.videoDetail!.seasons![cSeasonIndex].id,
                        seasonEpisodeData[i],
                        dTasks,
                        dItems,
                        TaskInfo(
                            eIndex: i,
                            name: "${seasonEpisodeData[i]['title']}",
                            ifLink:
                                "${seasonEpisodeData[i]['video_link']['iframeurl']}",
                            hdLink:
                                "${seasonEpisodeData[i]['video_link']['ready_url']}",
                            link360:
                                "${seasonEpisodeData[i]['video_link']['url_360']}",
                            link480:
                                "${seasonEpisodeData[i]['video_link']['url_480']}",
                            link720:
                                "${seasonEpisodeData[i]['video_link']['url_720']}",
                            link1080:
                                "${seasonEpisodeData[i]['video_link']['url_1080']}"),
                        platform)
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Color.fromRGBO(72, 163, 198, 0.4).withOpacity(0.0),
                  Color.fromRGBO(72, 163, 198, 0.3).withOpacity(0.1),
                  Color.fromRGBO(72, 163, 198, 0.2).withOpacity(0.2),
                  Color.fromRGBO(72, 163, 198, 0.1).withOpacity(0.3),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();
    tasks?.forEach((task) {
      for (TaskInfo info in dTasks!) {
        if (info.hdLink == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  //  Tab bar for seasons page and episodes and more details tabs
  Widget tabBar() {
    return TabBar(
        onTap: (currentIndex2) {
          setState(() {
            _currentIndex2 = currentIndex2;
          });
        },
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
              // color: Color.fromRGBO(125, 183, 91, 1.0),
              color: Theme.of(context).primaryColor,
              width: 2.5),
          insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 46.0),
        ),
        indicatorColor: Colors.orangeAccent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        unselectedLabelColor: Color.fromRGBO(95, 95, 95, 1.0),
        tabs: [
          TabWidget('EPISODES'),
          TabWidget('MORE DETAILS'),
        ]);
  }

  //  Sliver app bar that contains tab bar
  Widget sliverAppbarSeasons(innerBoxIsScrolled) {
    return SliverAppBar(
      elevation: 0.0,
      title: seasonsTabBar(),
      pinned: false,
      floating: true,
      forceElevated: innerBoxIsScrolled,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }

  //  Seasons tab bar
  Widget seasonsTabBar() {
    return TabBar(
      onTap: (currentIndex) {
        setState(() {
          cSeasonIndex = currentIndex;
          newSeasonIndex = currentIndex;
          seasonId = widget.videoDetail!.seasons![currentIndex].id;
          ser = widget.videoDetail!.seasons![currentIndex].id;
        });
        getData(currentIndex);
      },
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BubbleTabIndicator(
        indicatorHeight: 35.0,
        indicatorColor: activeDotColor,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
      ),
      controller: _seasonsTabController,
      isScrollable: true,
      tabs: List<Tab>.generate(
        widget.videoDetail!.seasons == null
            ? 0
            : widget.videoDetail!.seasons!.length,
        (int index) {
          return Tab(
            child: SeasonsTab(widget.videoDetail!.seasons![index].seasonNo),
          );
        },
      ),
    );
  }

  //  SliverList including detail header and row of my list, rate, share and download.
  Widget sliverList() {
    final platform = Theme.of(context).platform;
    if (widget.videoDetail!.seasons!.length != 0) {
      return SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int j) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoDetailHeader(widget.videoDetail),
              widget.videoDetail!.description == null ||
                      widget.videoDetail!.description == ""
                  ? SizedBox.shrink()
                  : DescriptionText(widget.videoDetail!.description),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WishListView(widget.videoDetail),
                  RateUs(widget.videoDetail!.type, widget.videoDetail!.id),
                  SharePage(APIData.shareMovieUri, widget.videoDetail!.id),
                  widget.videoDetail!.type == DatumType.M
                      ? DownloadPage(widget.videoDetail!, platform)
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        );
      }, childCount: 1));
    } else {
      return SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int j) {
        return Container(
          color: Color.fromRGBO(34, 34, 34, 1.0),
          child: Column(
            children: <Widget>[
              VideoDetailHeader(widget.videoDetail),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: new DescriptionText(widget.videoDetail!.description)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 26.0, 16.0, 0.0),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
              )
            ],
          ),
        );
      }, childCount: 1));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    newSeasonIndex = 0;
    setState(() {
      cSeasonIndex = 0;
      _currentIndex2 = 0;
      seasonEpisodeData = null;
    });

    if (widget.videoDetail!.type == DatumType.T) {
      if (widget.videoDetail!.seasons!.length != 0) {
        this.getData(cSeasonIndex);
      }
    }
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    _seasonsTabController = TabController(
        vsync: this,
        length: widget.videoDetail!.seasons == null
            ? 0
            : widget.videoDetail!.seasons!.length,
        initialIndex: 0);
    _episodeTabController =
        TabController(vsync: this, length: 2, initialIndex: 0);
    commentList = widget.videoDetail!.comments;
  }

  @override
  Widget build(BuildContext context) {
    var moreLikeThis = Provider.of<MenuDataProvider>(context).menuCatMoviesList;
    return DefaultTabController(
      length: 2,
      child: scaffold(moreLikeThis),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    commentsController.dispose();
    _scrollController!.dispose();
    _episodeTabController.dispose();
    _seasonsTabController!.dispose();
  }
}
