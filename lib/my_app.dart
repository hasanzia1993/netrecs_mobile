import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/global.dart';
import 'providers/actor_movies_provider.dart';
import 'providers/app_config.dart';
import 'common/route_paths.dart';
import 'package:provider/provider.dart';
import 'common/styles.dart';
import 'providers/faq_provider.dart';
import 'providers/login_provider.dart';
import 'providers/main_data_provider.dart';
import 'providers/menu_data_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/movie_tv_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/payment_key_provider.dart';
import 'providers/slider_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/coupon_provider.dart';
import 'ui/route_generator.dart';
import 'ui/screens/splash_screen.dart';
import 'providers/watch_history_provider.dart';

class MyApp extends StatefulWidget {
  MyApp({this.token});
  final String? token;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setState(() {
      switchThemes = false;
    });
    getTheme();
  }

  Future<bool> getTheme() async {
    try {
      SharedPreferences pref = await prefsTheme;
      var currentTheme = pref.getBool('theme');
      setState(() {
        switchThemes = pref.getBool('theme')!;
      });
      return (currentTheme != null ? pref.getBool('theme') : false)!;
    } catch (e) {
      print(e);
      setState(() {
        switchThemes = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: switchThemes ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: switchThemes
            ? buildLightTheme().primaryColorLight
            : buildDarkTheme().primaryColorLight,
        systemNavigationBarIconBrightness:
            switchThemes ? Brightness.dark : Brightness.light,
        statusBarColor: switchThemes
            ? buildLightTheme().primaryColorDark
            : buildDarkTheme().primaryColorDark,
        statusBarIconBrightness:
            switchThemes ? Brightness.dark : Brightness.light));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppConfig()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
          ChangeNotifierProvider(create: (_) => MenuProvider()),
          ChangeNotifierProvider(create: (_) => SliderProvider()),
          ChangeNotifierProvider(create: (_) => MainProvider()),
          ChangeNotifierProvider(create: (_) => MovieTVProvider()),
          ChangeNotifierProvider(create: (_) => MenuDataProvider()),
          ChangeNotifierProvider(create: (_) => WishListProvider()),
          ChangeNotifierProvider(create: (_) => NotificationsProvider()),
          ChangeNotifierProvider(create: (_) => FAQProvider()),
          ChangeNotifierProvider(create: (_) => PaymentKeyProvider()),
          ChangeNotifierProvider(create: (_) => WatchHistoryProvider()),
          ChangeNotifierProvider(create: (_) => ActorMoviesProvider()),
          ChangeNotifierProvider(create: (_) => CouponProvider()),
        ],
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: RoutePaths.appTitle,
            theme: switchThemes ? buildLightTheme() : buildDarkTheme(),
            initialRoute: RoutePaths.splashScreen,
            onGenerateRoute: RouteGenerator.generateRoute,
            routes: {
              RoutePaths.splashScreen: (context) =>
                  SplashScreen(token: widget.token),
            },
          ),
        ));
  }
}
