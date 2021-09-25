import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_ip/get_ip.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/ui/screens/bottom_navigations_bar.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MultiScreen extends StatefulWidget {
  @override
  _MultiScreenState createState() => _MultiScreenState();
}

class _MultiScreenState extends State<MultiScreen> {
  Widget appBar() {
    var appConfig = Provider.of<AppConfig>(context, listen: false).appModel!;
    return AppBar(
      title: Image.network(
        '${APIData.logoImageUri}${appConfig.config!.logo}',
        scale: 1.7,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.edit,
            size: 30,
            color: Colors.white,
          ),
          padding: EdgeInsets.only(right: 15.0),
          onPressed: () => Navigator.pushNamed(
            context,
            RoutePaths.createScreen,
          ),
        ),
      ],
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Color.fromRGBO(34, 34, 34, 1.0).withOpacity(0.98),
    );
  }

  Future<void> initPlatformState() async {
    String ipAddress;
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = 'Failed to get ipAddress.';
    }
    if (!mounted) return;
    setState(() {
      ip = ipAddress;
    });
  }

  updateScreens(screen, count, index) async {
    final updateScreensResponse =
        await http.post(Uri.parse(APIData.updateScreensApi), body: {
      "macaddress": '$ip',
      "screen": '$screen',
      "count": '$count',
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    if (updateScreensResponse.statusCode == 200) {
      storage.write(
          key: "screenName", value: "${screenList[index].screenName}");
      storage.write(key: "screenStatus", value: "YES");
      storage.write(key: "screenCount", value: "${screenList[index].id + 1}");
      storage.write(
          key: "activeScreen", value: "${screenList[index].screenName}");
      Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
    } else {
      Fluttertoast.showToast(msg: "Error in selecting profile");
      throw "Can't select profile";
    }
  }

  Future<String?> getAllScreens() async {
    final getAllScreensResponse =
        await http.get(Uri.parse(APIData.showScreensApi), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      // "Accept": "application/json"
    });
    if (getAllScreensResponse.statusCode == 200) {
      var screensRes = json.decode(getAllScreensResponse.body);
      print(screensRes);
      setState(() {
        screen1 = screensRes['screen']['screen1'] == null
            ? "Screen1"
            : screensRes['screen']['screen1'];
        screen2 = screensRes['screen']['screen2'] == null
            ? "Screen2"
            : screensRes['screen']['screen2'];
        screen3 = screensRes['screen']['screen3'] == null
            ? "Screen3"
            : screensRes['screen']['screen3'];
        screen4 = screensRes['screen']['screen4'] == null
            ? "Screen4"
            : screensRes['screen']['screen4'];

        activeScreen = screensRes['screen']['activescreen'];
        screenUsed1 = screensRes['screen']['screen_1_used'];
        screenUsed2 = screensRes['screen']['screen_2_used'];
        screenUsed3 = screensRes['screen']['screen_3_used'];
        screenUsed4 = screensRes['screen']['screen_4_used'];
        screenList = [
          ScreenProfile(0, screen1, screenUsed1),
          ScreenProfile(1, screen2, screenUsed2),
          ScreenProfile(2, screen3, screenUsed3),
          ScreenProfile(3, screen4, screenUsed4),
        ];
        print(screenList);
        print(screenList[0]);
      });
    } else if (getAllScreensResponse.statusCode == 401) {
      storage.deleteAll();
      Navigator.pushNamed(context, RoutePaths.login);
    } else {
      throw "Can't get screens data";
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAllScreens();
    if (!kIsWeb) {
      initPlatformState();
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;

    return WillPopScope(
        child: Scaffold(
          appBar:
              customAppBar(context, "Select Profile") as PreferredSizeWidget?,
          body: screenList.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 30.0, bottom: 30.0),
                                  child: Text(
                                    "Who's Watching?",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return InkWell(
                                child: Container(
                                  width: 110.0,
                                  height: 110.0,
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/avatar.png',
                                        width: 100.0,
                                        height: 80.0,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "${screenList[index].screenName}",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                Colors.white.withOpacity(0.7)),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  if ("${screenList[index].screenStatus}" ==
                                      "YES") {
                                    Fluttertoast.showToast(
                                        msg: "Profile already in use.");
                                  } else {
                                    setState(() {
                                      myActiveScreen =
                                          screenList[index].screenName;
                                      screenCount = index + 1;
                                    });
                                    updateScreens(
                                        myActiveScreen, screenCount, index);
                                  }
                                },
                              );
                            },
                            childCount: int.parse(userProfile?.screen),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        onWillPop: onWillPopS as Future<bool> Function()?);
  }
}

class ScreenProfile {
  int id;
  String? screenName;
  String? screenStatus;

  ScreenProfile(this.id, this.screenName, this.screenStatus);
}
