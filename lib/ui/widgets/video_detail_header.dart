import 'dart:io';
import 'dart:ui';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/models/datum.dart';
import 'package:nexthour/models/episode.dart';
import 'package:nexthour/player/iframe_player.dart';
import 'package:nexthour/player/m_player.dart';
import 'package:nexthour/player/player.dart';
import 'package:nexthour/player/playerMovieTrailer.dart';
import 'package:nexthour/player/player_episodes.dart';
import 'package:nexthour/player/trailer_cus_player.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/ui/widgets/video_header_diagonal.dart';
import 'package:nexthour/ui/widgets/video_item_box.dart';
import 'package:provider/provider.dart';

class VideoDetailHeader extends StatefulWidget {
  VideoDetailHeader(this.videoDetail);

  final Datum? videoDetail;

  @override
  VideoDetailHeaderState createState() => VideoDetailHeaderState();
}

class VideoDetailHeaderState extends State<VideoDetailHeader>
    with WidgetsBindingObserver {
  var dMsg = '';
  var hdUrl;
  var sdUrl;
  var mReadyUrl,
      mIFrameUrl,
      mUrl360,
      mUrl480,
      mUrl720,
      mUrl1080,
      youtubeUrl,
      vimeoUrl;

  getAllScreens(mVideoUrl, type) async {
    if (type == "CUSTOM") {
      addHistory(widget.videoDetail!.type, widget.videoDetail!.id);
      var router = new MaterialPageRoute(
          builder: (BuildContext context) => new MyCustomPlayer(
                url: mVideoUrl,
                title: widget.videoDetail!.title,
                downloadStatus: 1,
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
        builder: (BuildContext context) => PlayerMovie(
            id: widget.videoDetail!.id, type: widget.videoDetail!.type),
      );
      Navigator.of(context).push(router);
    }
  }

  Future<String?> addHistory(vType, id) async {
    var type = vType == DatumType.M ? "M" : "T";
    final response = await http.get(
        Uri.parse("${APIData.addWatchHistory}/$type/$id"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    if (response.statusCode == 200) {
    } else {
      throw "can't added to history";
    }
    return null;
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
    var videoLinks;
    var episodeUrl;
    var episodeTitle;
    episodeUrl = widget.videoDetail!.seasons![newSeasonIndex].episodes;
    episodeTitle = episodeUrl![0].title;
    videoLinks = episodeUrl![0].videoLink;
    print("eee: ${videoLinks!.iframeurl}");

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
                  videoLinks.url360 == null
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
                              print("season Url: ${videoLinks.url360}");
                              var hdUrl = videoLinks.url360;
                              var hdTitle = episodeTitle;
                              freeTrial(hdUrl, "CUSTOM", hdTitle);
                            },
                          ),
                        ),
                  videoLinks.url480 == null
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
                              print("season Url: ${videoLinks.url480}");
                              var hdUrl = videoLinks.url480;
                              var hdTitle = episodeTitle;
                              freeTrial(hdUrl, "CUSTOM", hdTitle);
                            },
                          ),
                        ),
                  videoLinks.url720 == null
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
                              print("season Url: ${videoLinks.url720}");
                              var hdUrl = videoLinks.url720;
                              var hdTitle = episodeTitle;
                              freeTrial(hdUrl, "CUSTOM", hdTitle);
                            },
                          ),
                        ),
                  videoLinks.url1080 == null
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
                              print("season Url: ${videoLinks.url1080}");
                              var hdUrl = videoLinks.url1080;
                              var hdTitle = episodeTitle;
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

  void _onTapPlay() {
    if (widget.videoDetail!.type == DatumType.T) {
      var videoLinks;
      var episodeUrl;
      var episodeTitle;
      episodeUrl = widget.videoDetail!.seasons![newSeasonIndex].episodes;
      episodeTitle = episodeUrl![0].title;
      videoLinks = episodeUrl![0].videoLink;
      print("eee: ${videoLinks!.iframeurl}");

      mReadyUrl = videoLinks.readyUrl;
      mUrl360 = videoLinks.url360;
      mUrl480 = videoLinks.url480;
      mUrl720 = videoLinks.url720;
      mUrl1080 = videoLinks.url1080;
      mIFrameUrl = videoLinks.iframeurl;
      var title = episodeTitle;

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
            getAllScreens(newurl, "CUSTOM");
          } else {
            getAllScreens(mIFrameUrl, "EMD");
          }
        } else if (mReadyUrl != null) {
          var checkMp4 = videoLinks.readyUrl.substring(mReadyUrl.length - 4);
          var checkMpd = videoLinks.readyUrl.substring(mReadyUrl.length - 4);
          var checkWebm = videoLinks.readyUrl.substring(mReadyUrl.length - 5);
          var checkMkv = videoLinks.readyUrl.substring(mReadyUrl.length - 4);
          var checkM3u8 = videoLinks.readyUrl.substring(mReadyUrl.length - 5);

          if (videoLinks.readyUrl.substring(0, 18) == "https://vimeo.com/") {
            getAllScreens(episodeUrl[0]['id'], "JS");
          } else if (videoLinks.readyUrl.substring(0, 29) ==
              'https://www.youtube.com/embed') {
            getAllScreens(mReadyUrl, "EMD");
          } else if (videoLinks.readyUrl.substring(0, 23) ==
              'https://www.youtube.com') {
            getAllScreens(episodeUrl[0]['id'], "JS");
          } else if (checkMp4 == ".mp4" ||
              checkMpd == ".mpd" ||
              checkWebm == ".webm" ||
              checkMkv == ".mkv" ||
              checkM3u8 == ".m3u8") {
            getAllScreens(mReadyUrl, "CUSTOM");
          } else {
            getAllScreens(episodeUrl[0]['id'], "JS");
          }
        } else if (mUrl360 != null ||
            mUrl480 != null ||
            mUrl720 != null ||
            mUrl1080 != null) {
          _showDialog(0);
        } else {
          getAllScreens(seasonEpisodeData[0]['id'], "JS");
        }
      } else {
        Fluttertoast.showToast(msg: "Video URL doesn't exist");
      }
    } else {
      var videoLink = widget.videoDetail!.videoLink!;

      var xyz = videoLink.toJson();
      print("eee: $xyz");
      mIFrameUrl = videoLink.iframeurl;
      print("Iframe: $mIFrameUrl");
      mReadyUrl = videoLink.readyUrl;
      print("Ready Url: $mReadyUrl");
      mUrl360 = videoLink.url360;
      print("Url 360: $mUrl360");
      mUrl480 = videoLink.url480;
      print("Url 480: $mUrl480");
      mUrl720 = videoLink.url720;
      print("Url 720: $mUrl720");
      mUrl1080 = videoLink.url1080;
      print("Url 1080: $mUrl1080");
      if (mIFrameUrl == null &&
          mReadyUrl == null &&
          mUrl360 == null &&
          mUrl480 == null &&
          mUrl720 == null &&
          mUrl1080 == null) {
        Fluttertoast.showToast(msg: "Video not available");
      } else {
        if (mUrl360 != null ||
            mUrl480 != null ||
            mUrl720 != null ||
            mUrl1080 != null) {
          _showQualityDialog(mUrl360, mUrl480, mUrl720, mUrl1080);
        } else {
          if (mIFrameUrl != null) {
            var matchIFrameUrl = mIFrameUrl.substring(0, 24);
            if (matchIFrameUrl == 'https://drive.google.com') {
              var ind = mIFrameUrl.lastIndexOf('d/');
              var t = "$mIFrameUrl".trim().substring(ind + 2);
              var rep = t.replaceAll('/preview', '');
              var newurl =
                  "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
              getAllScreens(newurl, "CUSTOM");
            } else {
              var router = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      IFramePlayerPage(url: mIFrameUrl));
              Navigator.of(context).push(router);
            }
          } else if (mReadyUrl != null) {
            var matchUrl = mReadyUrl.substring(0, 23);
            var checkMp4 = mReadyUrl.substring(mReadyUrl.length - 4);
            var checkMpd = mReadyUrl.substring(mReadyUrl.length - 4);
            var checkWebm = mReadyUrl.substring(mReadyUrl.length - 5);
            var checkMkv = mReadyUrl.substring(mReadyUrl.length - 4);
            var checkM3u8 = mReadyUrl.substring(mReadyUrl.length - 5);

            if (matchUrl.substring(0, 18) == "https://vimeo.com/") {
              var router = new MaterialPageRoute(
                builder: (BuildContext context) => PlayerMovie(
                    id: widget.videoDetail!.id, type: widget.videoDetail!.type),
              );
              Navigator.of(context).push(router);
            } else if (matchUrl == 'https://www.youtube.com/embed') {
              var url = '$mReadyUrl';
              var router = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      IFramePlayerPage(url: url));
              Navigator.of(context).push(router);
            } else if (matchUrl.substring(0, 23) == 'https://www.youtube.com') {
              getAllScreens(mReadyUrl, "JS");
            } else if (checkMp4 == ".mp4" ||
                checkMpd == ".mpd" ||
                checkWebm == ".webm" ||
                checkMkv == ".mkv" ||
                checkM3u8 == ".m3u8") {
              getAllScreens(mReadyUrl, "CUSTOM");
            } else {
              getAllScreens(mReadyUrl, "JS");
            }
          }
        }
      }
    }
  }

  void _showQualityDialog(mUrl360, mUrl480, mUrl720, mUrl1080) {
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
                    "Available video Format in which you want to play video.",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7), fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  mUrl360 == null
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
                              getAllScreens(mUrl360, "CUSTOM");
                            },
                          ),
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                  mUrl480 == null
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
                              getAllScreens(mUrl480, "CUSTOM");
                            },
                          ),
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                  mUrl720 == null
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
                              child: Text("720"),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              getAllScreens(mUrl720, "CUSTOM");
                            },
                          ),
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                  mUrl1080 == null
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
                              child: Text("1080"),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              getAllScreens(mUrl1080, "CUSTOM");
                            },
                          ),
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _onTapTrailer() {
    var trailerUrl;
    if (widget.videoDetail!.type == DatumType.T) {
      trailerUrl = widget.videoDetail!.seasons![newSeasonIndex].strailerUrl;
    } else {
      trailerUrl = widget.videoDetail!.trailerUrl;
    }
    if (trailerUrl == null) {
      Fluttertoast.showToast(msg: "Trailer not available");
    } else {
      var checkMp4 = trailerUrl.substring(trailerUrl.length - 4);
      var checkMpd = trailerUrl.substring(trailerUrl.length - 4);
      var checkWebm = trailerUrl.substring(trailerUrl.length - 5);
      var checkMkv = trailerUrl.substring(trailerUrl.length - 4);
      var checkM3u8 = trailerUrl.substring(trailerUrl.length - 5);
      if (trailerUrl.substring(0, 23) == 'https://www.youtube.com') {
        var router = new MaterialPageRoute(
            builder: (BuildContext context) => new PlayerMovieTrailer(
                id: widget.videoDetail!.id, type: widget.videoDetail!.type));
        Navigator.of(context).push(router);
      } else if (checkMp4 == ".mp4" ||
          checkMpd == ".mpd" ||
          checkWebm == ".webm" ||
          checkMkv == ".mkv" ||
          checkM3u8 == ".m3u8") {
        var router = new MaterialPageRoute(
            builder: (BuildContext context) => new TrailerCustomPlayer(
                  url: trailerUrl,
                  title: widget.videoDetail!.title,
                  downloadStatus: 1,
                ));
        Navigator.of(context).push(router);
      } else {
        var router = new MaterialPageRoute(
            builder: (BuildContext context) => new PlayerMovieTrailer(
                id: widget.videoDetail!.id, type: widget.videoDetail!.type));
        Navigator.of(context).push(router);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(bottom: 130.0),
          child: _buildDiagonalImageBackground(context),
        ),
        headerDecorationContainer(),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
        new Positioned(
          top: 180.0,
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: headerRow(theme),
        ),
      ],
    );
  }

  Widget headerRow(theme) {
    var dW = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var ratingCaptionStyle = textTheme.caption!.copyWith(
        color: Colors.white70, fontSize: 10.0, fontWeight: FontWeight.w500);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: new Hero(
              tag: "${widget.videoDetail!.title} ${widget.videoDetail!.id}",
              child: VideoItemBox(
                context,
                widget.videoDetail,
                height: 240.0,
              )),
        ),
        Expanded(
          flex: dW > 900 ? 1 : 2,
          child: new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dW > 900
                    ? Text(
                        widget.videoDetail!.title!,
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      )
                    : Expanded(
                        flex: 2,
                        child: Text(
                          widget.videoDetail!.title!,
                          style: Theme.of(context).textTheme.headline6,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                widget.videoDetail!.rating == null
                    ? SizedBox.shrink()
                    : SizedBox(
                        height: 10.0,
                      ),
                Expanded(
                    flex: dW > 900 ? 1 : 3,
                    child: widget.videoDetail!.rating == null
                        ? SizedBox.shrink()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 3.5,
                                    right: 3.5,
                                    top: 3.0,
                                    bottom: 3.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: new Text(
                                        "${widget.videoDetail!.rating}", //add 2
                                        style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: new Text(
                                          'TMDB',
                                          style: ratingCaptionStyle,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: RatingBar.builder(
                                  initialRating: widget.videoDetail!.rating ==
                                          null
                                      ? 0.0
                                      : double.parse(
                                          "${widget.videoDetail!.rating}"), //add 2
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 25,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ),
                            ],
                          )),
                dW > 900
                    ? Expanded(
                        flex: 2,
                        child: header(theme),
                      )
                    : header(theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget headerDecorationContainer() {
    return Container(
      height: 262.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
            Theme.of(context).primaryColorDark.withOpacity(0.1),
            Theme.of(context).primaryColorDark
          ],
              stops: [
            0.3,
            0.8
          ])),
    );
  }

  Widget header(theme) {
    var dW = MediaQuery.of(context).size.width;
    final userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel!;
    return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: dW > 900
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                          overlayColor: MaterialStateProperty.all(
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.1)),
                          // shadowColor: Colors.red,
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(0, 10.0, 0.0, 10.0)),
                          textStyle: MaterialStateProperty.all(
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontFamily: 'Lato',
                                  ))),
                      onPressed:
                          userDetails.active == "1" || userDetails.active == 1
                              ? _onTapPlay
                              : _showMsg,
                      icon: Icon(Icons.play_arrow,
                          size: 30.0, color: Theme.of(context).accentColor),
                      label: Text('Watch Now'),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor.withOpacity(0.2)),
                          overlayColor: MaterialStateProperty.all(
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.1)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(0, 10.0, 0.0, 10.0)),
                          textStyle: MaterialStateProperty.all(
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontFamily: 'Lato',
                                  ))),
                      onPressed: _onTapTrailer,
                      icon: Icon(Icons.play_arrow_outlined,
                          size: 30.0, color: Theme.of(context).accentColor),
                      label: Text('Preview'),
                    ),
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  OutlineButton(
                    onPressed:
                        userDetails.active == "1" || userDetails.active == 1
                            ? _onTapPlay
                            : _showMsg,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: Icon(Icons.play_arrow,
                              color: Color.fromRGBO(72, 163, 198, 1.0)),
                        ),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        ),
                        Expanded(
                          flex: 1,
                          child: new Text(
                            "Play",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.9,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(6.0, 0.0, 12.0, 0.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    borderSide: new BorderSide(
                        color: Color.fromRGBO(72, 163, 198, 1.0), width: 2.0),
                    color: theme.primaryColor,
                    highlightColor: theme.primaryColor.withOpacity(0.1),
                    highlightedBorderColor: theme.primaryColor,
                    splashColor: Colors.black12,
                    highlightElevation: 0.0,
                  ),
                  OutlineButton(
                    onPressed: _onTapTrailer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child:
                              new Icon(Icons.play_arrow, color: Colors.white70),
                        ),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        ),
                        Expanded(
                          flex: 1,
                          child: new Text(
                            "Trailer",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(6.0, 0.0, 12.0, 0.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white70, width: 2.0),
                    highlightColor: theme.primaryColorLight,
                    highlightedBorderColor: theme.accentColor,
                    splashColor: Colors.black12,
                    highlightElevation: 0.0,
                  )
                ],
              ));
  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return widget.videoDetail!.poster == null
        ? Image.asset(
            "assets/placeholder_cover.jpg",
            height: 225.0,
            width: screenWidth,
            fit: BoxFit.cover,
          )
        : DiagonallyCutColoredImage(
            FadeInImage.assetNetwork(
              image: widget.videoDetail!.type == DatumType.M
                  ? "${APIData.movieImageUriPosterMovie}${widget.videoDetail!.poster}"
                  : "${APIData.tvImageUriPosterTv}${widget.videoDetail!.poster}",
              placeholder: "assets/placeholder_cover.jpg",
              width: screenWidth,
              height: 225.0,
              fit: BoxFit.cover,
            ),
            color: const Color(0x00FFFFFF),
          );
  }
}
