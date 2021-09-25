import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/providers/main_data_provider.dart';
import 'package:nexthour/providers/menu_provider.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:nexthour/providers/slider_provider.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/ui/screens/multi_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashScreen extends StatefulWidget {
  SplashScreen({this.token});

  final String? token;

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  // ignore: unused_field
  String _debugLabelString = "";

  // ignore: unused_field
  bool _enableConsentButton = false;

  bool _flexibleUpdateAvailable = false;
  bool _requireConsent = true;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  late AppUpdateInfo _updateInfo;
  TargetPlatform? platform;
  @override
  initState() {
    super.initState();
    // In app update and it works only in live mode after deploying on PlayStore
    // checkForUpdate();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // setLocalPath();
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          setLocalPath();
          checkLoginStatus();
        }
      } on SocketException catch (_) {
        setLocalPath();
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushNamed(context, RoutePaths.download);
        });
        Fluttertoast.showToast(msg: "You’re Offline!");
        print('not connected');
      }
    });
  }

  Future<Null> setLocalPath() async {
    print('sms');
    var deviceLocalPath =
        (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    print('local path: $deviceLocalPath');
    setState(() {
      localPath = deviceLocalPath;
      dLocalPath = deviceLocalPath;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) => _showError(e));
    if (_updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.startFlexibleUpdate().then((_) {
        setState(() {
          _flexibleUpdateAvailable = true;
        });
      }).catchError((e) => _showError(e));
    }
    if (!_flexibleUpdateAvailable) {
      InAppUpdate.completeFlexibleUpdate().then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success!')));
        // _scaffoldKey.currentState!
        //     .showSnackBar(SnackBar(content: Text('Success!')));
      }).catchError((e) => _showError(e));
    }
  }

  _showError(dynamic exception) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(exception.toString())));
    // _scaffoldKey.currentState!
    //     .showSnackBar(SnackBar(content: Text(exception.toString())));
  }

  // For One Signal notification
  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: false,
      OSiOSSettings.inAppLaunchUrl: false
    };
//
    // OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
    //   this.setState(() {
    //     _debugLabelString =
    //         "Received notification: \n${event.jsonRepresentation().replaceAll("\\n", "\n")}";
    //   });
    // });
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      this.setState(() {
        _debugLabelString =
            "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {});

    OneSignal.shared
        .setPermissionObserver((OSPermissionStateChanges changes) {});

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {});

    await OneSignal.shared.init(APIData.onSignalAppId, iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    this.setState(() {
      _enableConsentButton = requiresConsent;
    });
    oneSignalInAppMessagingTriggerExamples();
  }

  oneSignalInAppMessagingTriggerExamples() async {
    OneSignal.shared.addTrigger("trigger_1", "one");

    Map<String, Object> triggers = new Map<String, Object>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    OneSignal.shared.removeTriggerForKey("trigger_2");

    // ignore: unused_local_variable
    Object triggerValue =
        (await OneSignal.shared.getTriggerValueForKey("trigger_3"))!;
    List<String> keys = [];
    keys.add("trigger_1");
    keys.add("trigger_3");
    OneSignal.shared.removeTriggersForKeys(keys);

    OneSignal.shared.pauseInAppMessages(false);
  }

  // For One Signal permission
  void _handleConsent() {
    OneSignal.shared.consentGranted(true);
    this.setState(() {
      _enableConsentButton = false;
    });
  }

  Widget logoImage(myModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            // width: 250.0,
            // height: 100.0,
          ),
        )
      ],
    );
  }

  Future checkLoginStatus() async {
    print('here-1');
    final appConfig = Provider.of<AppConfig>(context, listen: false);

    await appConfig.getHomeData(context);

    var all;
    if (kIsWeb) {
      all = false;
    } else {
      all = await storage.read(key: "login");
    }

    if (all == "true") {
      _handleConsent();
      initPlatformState();
      var token = await storage.read(key: "authToken");
      setState(() {
        authToken = token;
      });
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      final userProfileProvider =
          Provider.of<UserProfileProvider>(context, listen: false);
      final mainProvider = Provider.of<MainProvider>(context, listen: false);
      final sliderProvider =
          Provider.of<SliderProvider>(context, listen: false);
      final movieTVProvider =
          Provider.of<MovieTVProvider>(context, listen: false);
      await userProfileProvider.getUserProfile(context);
      await menuProvider.getMenus(context);
      await sliderProvider.getSlider();
      await mainProvider.getMainApiData(context);
      await movieTVProvider.getMoviesTVData(context);
      var userDetails =
          Provider.of<UserProfileProvider>(context, listen: false);
      if (userDetails.userProfileModel!.active == "1" ||
          userDetails.userProfileModel!.active == 1) {
        if (userDetails.userProfileModel!.payment == "Free") {
          Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
        } else {
          var activeScreen = await storage.read(key: "activeScreen");
          var actScreenCount = await storage.read(key: "screenCount");
          if (activeScreen == null) {
            Navigator.pushNamed(context, RoutePaths.multiScreen);
          } else {
            setState(() {
              myActiveScreen = activeScreen;
              screenCount = actScreenCount;
            });
            getAllScreens();
            Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
          }
        }
      } else {
        Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
      }
    } else {
      if (appConfig.slides.length == 0) {
        Navigator.pushNamed(context, RoutePaths.loginHome);
      } else {
        // Navigator.pushNamed(context, RoutePaths.loginHome);
        Navigator.pushNamed(context, RoutePaths.introSlider);
      }
    }
  }

  Future<String?> getAllScreens() async {
    final getAllScreensResponse =
        await http.get(Uri.parse(APIData.showScreensApi), headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    if (getAllScreensResponse.statusCode == 200) {
      var screensRes = json.decode(getAllScreensResponse.body);
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
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var hi = MediaQuery.of(context).size.height;

    final myModel = Provider.of<AppConfig>(context, listen: false);
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Image.asset(
            //   "assets/netflix.jpeg",
            //   // "assets/splash.png",
            //   fit: BoxFit.cover,
            //   // height: double.infinity,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).primaryColorLight.withOpacity(0.5),
            //     image: DecorationImage(
            //       colorFilter: new ColorFilter.mode(
            //           Colors.black.withOpacity(0.25), BlendMode.dstATop),
            //       image: AssetImage("assets/netflix2.jpeg"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Container(
                alignment: Alignment.center,
                color: Theme.of(context).primaryColorDark,
                // width: wi * 0.6,
                // height: hi * 0.1,
                // margin: EdgeInsets.only(
                //   left: 20.0,
                //   right: 20.0,
                // ),
                // // padding: EdgeInsets.only(
                // //     left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(15)),
                //     color: switchThemes
                //         ? buildLightTheme().canvasColor
                //         : buildDarkTheme().canvasColor),
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                  // width: 250.0,
                  // height: 100.0,
                )
                // logoImage(myModel),
                ),
            // SizedBox(
            //   height: 20.0,
            // ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              heightFactor: 10,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: CircularProgressIndicator(),
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [

            //     // Expanded(
            //     //   child: Align(
            //     //     alignment: Alignment.bottomCenter,
            //     //     child: CircularProgressIndicator(),
            //     //   ),
            //     // ),
            //   ],
            // ),
          ],
        ));
  }
}
