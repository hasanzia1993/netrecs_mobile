import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? platform;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTheme();
  }

// user name
  Widget userName(activeUsername) {
    return Text(activeUsername,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14.0,
            fontWeight: FontWeight.w400));
  }

  // Manage Profile
  Widget manageProfile(width, context) {
    return Container(
        width: width,
        color: Theme.of(context).primaryColorLight,
        child: Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, RoutePaths.manageProfile),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.edit, size: 15, color: Colors.white70),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Manage Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )));
  }

  Widget profileImage() {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel!;
    return Column(
      children: <Widget>[
        Container(
          height: 50.0,
          width: 50.0,
          child: Image.asset(
            "assets/avatar.png",
            scale: 1.7,
            fit: BoxFit.cover,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.0)),
        ),
        Text("${userDetails.user!.name}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400)),
      ],
    );
  }

  updateScreens(screen, count, index) async {
    final updateScreensResponse =
        await http.post(Uri.parse(APIData.updateScreensApi), body: {
      "macaddress": '$ip',
      "screen": '$screen',
      "count": '$count',
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    print("screen $screen");
    print("count $count");
    print(updateScreensResponse.statusCode);
    if (updateScreensResponse.statusCode == 200) {
      storage.write(
          key: "screenName", value: "${screenList[index].screenName}");
      storage.write(key: "screenStatus", value: "YES");
      storage.write(key: "screenCount", value: "${index + 1}");
      storage.write(
          key: "activeScreen", value: "${screenList[index].screenName}");
    } else {
      Fluttertoast.showToast(msg: "Error in selecting profile");
      throw "Can't select profile";
    }
  }

//  Drawer Header
  Widget drawerHeader(width) {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel!;
    // print("screntest: ${screenList[0].id + 1}");
    // print("screntest2: ${screenCount}");
    return Container(
        width: width,
        child: DrawerHeader(
          margin: EdgeInsets.fromLTRB(0, 0.0, 0, 0),
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              userDetails.active == "1" || userDetails.active == 1
                  ? userDetails.payment == "Free"
                      ? profileImage()
                      : Expanded(
                          child: Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: int.parse(userDetails.screen),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: "${screenList[index].id + 1}" ==
                                          '$screenCount'
                                      ? Column(
                                          children: <Widget>[
                                            Container(
                                              height: 70.0,
                                              margin:
                                                  EdgeInsets.only(right: 10.0),
                                              width: 70,
                                              child: userDetails.user!.image !=
                                                      null
                                                  ? Image.network(
                                                      "${APIData.profileImageUri}" +
                                                          "${userDetails.user!.image}",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      "assets/avatar.png",
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4.5,
                                                      fit: BoxFit.cover,
                                                    ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.0)),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              screenList[index].screenName!,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.white
                                                      .withOpacity(0.7)),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 12.0),
                                              height: 60.0,
                                              width: 60.0,
                                              child: userDetails.user!.image !=
                                                      null
                                                  ? Image.network(
                                                      "${APIData.profileImageUri}" +
                                                          "${userDetails.user!.image}",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      "assets/avatar.png",
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4.5,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            userName(
                                                screenList[index].screenName),
                                          ],
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
                              }),
                        ))
                  : profileImage(),
              SizedBox(
                height: 15.0,
              ),
              Container(
                  width: width,
                  color: Theme.of(context).primaryColorLight,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutePaths.manageProfile);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.edit, size: 15, color: Colors.white70),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Manage Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ))),
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
          ),
        ));
  }

//  Notification
  Widget notification() {
    return Container(
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.notifications);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.notifications, size: 15, color: Colors.white70),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Notifications",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Theme.of(context).primaryColorLight,
          width: 3.0,
        ),
      )),
    );
  }

//  App settings
  Widget appSettings() {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.appSettings);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "App Settings",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  //  watch  history
  Widget watchHistory() {
    return Container(
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.watchHistory);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.solidPlayCircle,
                    size: 15, color: Colors.white70),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Watch History",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Theme.of(context).primaryColorLight,
          width: 3.0,
        ),
      )),
    );
  }

//  Account
  Widget account() {
    return InkWell(
        onTap: () {
          _onButtonPressed();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

//  Subscribe
  Widget subscribe() {
    return InkWell(
        onTap: () => Navigator.pushNamed(context, RoutePaths.subscriptionPlans),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Subscribe",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

//  Help
  Widget help() {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.faq);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "FAQ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  // Blog
  Widget blog() {
    return InkWell(
        onTap: () => Navigator.pushNamed(context, RoutePaths.blogList),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Blog",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  // Donate
  Widget donate() {
    return InkWell(
        onTap: () => Navigator.pushNamed(context, RoutePaths.donation),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Donate",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

//  Rate Us
  Widget rateUs() {
    return InkWell(
        onTap: () {
          String os = Platform.operatingSystem; //in your code
          if (os == 'android') {
            if (APIData.androidAppId != '') {
              LaunchReview.launch(
                androidAppId: APIData.androidAppId,
              );
            } else {
              Fluttertoast.showToast(msg: 'PlayStore id not available');
            }
          } else {
            if (APIData.iosAppId != '') {
              LaunchReview.launch(
                  androidAppId: APIData.androidAppId,
                  iOSAppId: APIData.iosAppId);

              LaunchReview.launch(
                  writeReview: false, iOSAppId: APIData.iosAppId);
            } else {
              Fluttertoast.showToast(msg: 'AppStore id not available');
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Rate Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

//  Share app
  Widget shareApp() {
    return InkWell(
        onTap: () {
          String os = Platform.operatingSystem; //in your code
          if (os == 'android') {
            if (APIData.androidAppId != '') {
              Share.share(APIData.shareAndroidAppUrl);
            } else {
              Fluttertoast.showToast(msg: 'PlayStore id not available');
            }
          } else {
            if (APIData.iosAppId != '') {
              Share.share(APIData.iosAppId);
            } else {
              Fluttertoast.showToast(msg: 'AppStore id not available');
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Share app",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  _saveTheme() async {
    SharedPreferences pref = await prefsTheme;
    pref.setBool('theme', switchThemes);
  }

  _getTheme() async {
//    var _lightF;
//    _lightF = _prefs.then((SharedPreferences prefs) {
//      return prefs.getBool('theme') != null ? prefs.getBool('theme') : true;
//    });
    SharedPreferences pref = await prefsTheme;
    print("test: ${pref.getBool('theme')}");
//    _light = await _lightF;
    setState(() {
      switchThemes =
          (pref.getBool('theme') != null ? pref.getBool('theme') : false)!;
    });
    print("test2: $switchThemes");
  }

// Change Themes
  Widget changeThemes() {
    return InkWell(
        child: Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Switch Theme",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white70,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
          Switch(
              value: switchThemes,
              onChanged: (state) {
                setState(() {
                  switchThemes = state;
                });
                _saveTheme();
                print(state);
              }),
        ],
      ),
    ));
  }

//  Sign Out
  Widget signOut() {
    return InkWell(
        onTap: () {
          _signOutDialog();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Text(
                  "Sign Out",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Expanded(
                flex: 1,
                child:
                    Icon(Icons.settings_power, size: 15, color: Colors.white70),
              )
            ],
          ),
        ));
  }

  // Bottom Sheet after on tapping account
  Widget _buildBottomSheet() {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Membership'),
            onTap: () => Navigator.pushNamed(context, RoutePaths.membership),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
          ),
          ListTile(
            title: Text('Payment History'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.paymentHistory);
            },
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(50.0),
          topRight: const Radius.circular(50.0),
        ),
      ),
    );
  }

//  Drawer body container
  Widget drawerBodyContainer(height2) {
    var appConfig = Provider.of<AppConfig>(context, listen: false).appModel!;
    return Container(
      height: height2,
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          notification(),
          watchHistory(),
          appSettings(),
          account(),
          appConfig.config!.donation == 1 ||
                  "${appConfig.config!.donation}" == "1"
              ? donate()
              : SizedBox.shrink(),
          appConfig.blogs!.length != 0 ? blog() : SizedBox.shrink(),
          subscribe(),
          help(),
          rateUs(),
          shareApp(),
          signOut(),
          // changeThemes(),
        ],
      ),
    );
  }

//  Navigation drawer
  Widget drawer(width, height2) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                drawerHeader(width),
                drawerBodyContainer(height2),
              ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double height2 = (height * 76.75) / 100;
    var userProfile = Provider.of<UserProfileProvider>(context, listen: false);
    return SizedBox(
      width: width,
      child: drawer(width, height2),
    );
  }

  void _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 150.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(34, 34, 34, 1.0),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: _buildBottomSheet()),
          );
        });
  }

  _signOutDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(34, 34, 34, 1.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Sign Out?",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
                    child: Text(
                      "Are you sure that you want to logout?",
                      style:
                          TextStyle(color: Color.fromRGBO(155, 155, 155, 1.0)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.white70,
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        "Cancel",
                        style:
                            TextStyle(color: Color.fromRGBO(34, 34, 34, 1.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      screenLogout();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight,
                          stops: [0.1, 0.5, 0.7, 0.9],
                          colors: [
                            Colors.amber.withOpacity(0.4),
                            Colors.amber.withOpacity(0.5),
                            Colors.amber.withOpacity(0.6),
                            Colors.amber.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool isShowing = true;

  screenLogout() async {
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel!;
    setState(() {
      isShowing = false;
    });
    var screenLogOutResponse, screenCount, actScreen;

    if (userDetails.active == "1" || userDetails.active == 1) {
      if (userDetails.payment == "Free") {
        screenLogOutResponse = await http.post(
            Uri.parse(APIData.screenLogOutApi),
            headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
      } else {
        screenCount = await storage.read(key: "screenCount");
        actScreen = await storage.read(key: "activeScreen");
        screenLogOutResponse =
            await http.post(Uri.parse(APIData.screenLogOutApi), body: {
          "screen": '$actScreen',
          "count": '$screenCount',
          "macaddress": '$ip',
        }, headers: {
          HttpHeaders.authorizationHeader: "Bearer $authToken"
        });
      }
    } else {
      screenLogOutResponse = await http.post(Uri.parse(APIData.screenLogOutApi),
          headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    }
    if (screenLogOutResponse.statusCode == 200) {
      setState(() {
        isShowing = true;
      });
      await storage.deleteAll();
      Navigator.pushNamed(context, RoutePaths.loginHome);
    } else {
      setState(() {
        isShowing = true;
      });
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  goToDialog() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).backgroundColor),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      "Loading ..",
                      style:
                          TextStyle(color: Theme.of(context).backgroundColor),
                    )
                  ],
                ),
              ),
              onWillPop: () async => false));
    } else {
      Navigator.pop(context);
    }
  }
}
