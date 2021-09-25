import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/providers/main_data_provider.dart';
import 'package:nexthour/providers/menu_data_provider.dart';
import 'package:nexthour/providers/menu_provider.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/ui/shared/actors_horizontal_list.dart';
import 'package:nexthour/ui/shared/back_press.dart';
import 'package:nexthour/ui/screens/video_page.dart';
import 'package:nexthour/ui/shared/heading1.dart';
import 'package:nexthour/ui/shared/image_slider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:nexthour/common/apipath.dart';

import 'horizental_genre_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController? _scrollViewController;
  // TabController _tabController;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TargetPlatform? platform;
  bool? notificationPermission;

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      PermissionStatus permission = await Permission.notification.status;
//      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.notification);
      if (permission != PermissionStatus.granted) {
        Map<Permission, PermissionStatus> permissions =
//            await PermissionHandler()
            await [Permission.notification].request();
//        await PermissionHandler().requestPermissions([PermissionGroup.notification]);
        if (permissions[Permission.notification] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  getPermission() async {
    notificationPermission = await _checkPermission();
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    Firebase.initializeApp();
    _firebaseMessaging.getToken().then((value) => print("Token: $value"));
//    _firebaseMessaging.configure(
//        onMessage: (Map<String, dynamic> message) async{
//        },
//        onResume: (Map<String, dynamic> message) async{
//        },
//        onLaunch: (Map<String, dynamic> message) async {
//          Navigator.pushNamed(context, RoutePaths.notifications);
//        }
//    );
//    _firebaseMessaging.requestPermission(
//
//    )
    _scrollViewController = new ScrollController();
    // WidgetsBinding.instance!.addPostFrameCallback((timestamp) {
    // final menus = Provider.of<MenuProvider>(context, listen: false);
    // List menusItemList = menus.menuList;
    // menusItemList.removeWhere((item) => item.name == "");
    // _tabController = TabController(
    //   vsync: this,
    //   length: menusItemList.length,
    //   initialIndex: 0,
    // );
    // });
  }

  //  When menu length is 0.
  Widget safeAreaMenuNull() {
    return SafeArea(
      child: Scaffold(body: scaffoldBodyMenuNull()),
    );
  }

  //  Scaffold body when menu length is 0.
  Widget scaffoldBodyMenuNull() {
    return Center(
      child: Text("No data Available"),
    );
  }

  //  Sliver app bar
  Widget _sliverAppBar(innerBoxIsScrolled, myModel, menus) {
    bool type = false;
    var dWidth = MediaQuery.of(context).size.width;
    var isPortrait =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (dWidth > 900 || isPortrait) {
      print("is : $isPortrait");
      type = true;
    } else {
      type = false;
    }
    var logo =
        Provider.of<AppConfig>(context, listen: false).appModel!.config!.logo;
    return SliverAppBar(
      elevation: 0.0,
      stretch: true,
      expandedHeight:
          MediaQuery.of(context).size.height * Constants.sliderHeight,
      flexibleSpace: FlexibleSpaceBar(
          stretchModes: [
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle
          ],
          background: Container(
            // foregroundDecoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [
            //       Theme.of(context).primaryColorLight,
            //       Colors.transparent,
            //       Colors.transparent,
            //       Theme.of(context).primaryColorLight,
            //     ],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     stops: [0, 0.4, 0.7, 1],
            //   ),
            // ),
            // child: Image.network(
            //   'https://i.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68',
            //   fit: BoxFit.cover,
            // ),
            child: ImageSlider(),
          )),
      title: Row(
        children: [
          Expanded(
            flex: type == true ? 1 : 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: type == true
                    ? EdgeInsets.only(left: 15.0, right: 15.0)
                    : EdgeInsets.only(left: 5.0, right: 5.0),
                child: Image.asset(
                  'assets/logo.png',
                  
                  // fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Expanded(
              flex: type == true ? 4 : 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Color.fromRGBO(125, 183, 91, 1.0),
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  labelColor: Theme.of(context).textSelectionColor,
                  unselectedLabelColor: Theme.of(context).hintColor,
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                  isScrollable: true,
                  tabs: List.generate(
                    menus.length,
                    (int index) {
                      return menus[index].name.toString().length == 0
                          ? Container(
                              width: 0.0,
                            )
                          : Tab(
                              child: new Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 2.0, right: 2.0),
                                child: new Text(
                                  '${menus[index].name}',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 15.0,
                                    // fontWeight: FontWeight.w800,
                                    letterSpacing: 0.9,
                                    // color: Colors.white
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ))
        ],
      ),

      backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.8),

      pinned: true,
      floating: true,
      forceElevated: innerBoxIsScrolled,
      automaticallyImplyLeading: false,
      // actions: [
      //   IconButton(
      //       icon: Icon(
      //         Icons.notifications,
      //         size: 18,
      //       ),
      //       splashRadius: 22,
      //       onPressed: () {
      //         Navigator.pushNamed(context, RoutePaths.notifications);
      //       })
      // ],

//   Tabs used on home page
//       bottom: TabBar(
//         indicatorSize: TabBarIndicatorSize.tab,
//         indicatorColor: Color.fromRGBO(125, 183, 91, 1.0),
//         labelColor: switchThemes
//             ? buildLightTheme().textSelectionColor
//             : buildDarkTheme().textSelectionColor,
//         unselectedLabelColor: Theme.of(context).hintColor,
//         indicator: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.transparent,
//               width: 0,
//             ),
//           ),
//         ),
// //        controller: tabController,
//         isScrollable: true,
//         tabs: List.generate(
//           menus.length,
//           (int index) {
//             // print("tabnames: ${menus.menuList[index].name.toString().length}");
//             return menus[index].name.toString().length == 0
//                 ? Container(
//                     width: 0.0,
//                   )
//                 : Tab(
//                     child: new Container(
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.only(left: 5.0, right: 5.0),
//                       child: new Text(
//                         '${menus[index].name}',
//                         style: TextStyle(
//                           fontFamily: 'Lato',
//                           fontSize: 15.0,
//                           // fontWeight: FontWeight.w800,
//                           letterSpacing: 0.9,
//                           // color: Colors.white
//                         ),
//                       ),
//                     ),
//                   );
//           },
//         ),
//       ),
    );
  }

//  Scaffold body
  Widget _scaffoldBody(myModel, menus) {
    return NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _sliverAppBar(innerBoxIsScrolled, myModel, menus),
        ];
      },
      body: TabBarView(
        children: List<Widget>.generate(menus.length, (int index) {
          menuId = menus[index].id;
          // return Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => VideosPage(
          //             menuId: menuId,
          //           )),
          // );
          // MenuDataProvider menuDataProvider =
          //     Provider.of<MenuDataProvider>(context, listen: false);
          // menuDataProvider.getMenusData(context, menuId);
          // try {
          //   MenuDataProvider menuDataProvider =
          //       Provider.of<MenuDataProvider>(context, listen: false);
          //   menuDataProvider.getMenusData(context, menuId);
          //   var actorsList =
          //       Provider.of<MainProvider>(context, listen: false).actorList;
          //   return SingleChildScrollView(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         SizedBox(
          //           height: 20.0,
          //         ),
          //         HorizontalGenreList(),
          //         // SizedBox(
          //         //   height: 15.0,
          //         // ),
          //         // actorsList.length == 0
          //         //     ? SizedBox.shrink()
          //         //     : Heading1("Artist", "Actor"),
          //         // actorsList.length == 0
          //         //     ? SizedBox.shrink()
          //         //     : SizedBox(
          //         //         height: 15.0,
          //         //       ),
          //         // actorsList.length == 0
          //         //     ? SizedBox.shrink()
          //         //     : ActorsHorizontalList(),
          //         SizedBox(
          //           height: 15.0,
          //         ),
          //       ],
          //     ),
          //   );
          // return Container(
          //   child: Text('Ok'),
          // );
          // } catch (err) {
          //   return Container(
          //     child: Text('Error'),
          //   );
          // }
          return VideosPage(
            menuId: menuId,
          );
        }),
      ),
    );
  }

  //  When menu length is not 0
  Widget safeArea(myModel, menus) {
    return SafeArea(
      child: WillPopScope(
          child: DefaultTabController(
            length: menus == null ? 0 : menus.length,
            child: Scaffold(
              key: _scaffoldKey,
              body: _scaffoldBody(myModel, menus),
              backgroundColor: Theme.of(context).primaryColorDark,
            ),
          ),
          onWillPop: OnBackPress.onWillPopS as Future<bool> Function()?),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProfileProvider>(context, listen: false);
    final menus = Provider.of<MenuProvider>(context, listen: false);
    final myModel = Provider.of<AppConfig>(context, listen: false);
    List menusItemList = menus.menuList;
    menusItemList.removeWhere((item) {
      return item.name.toString().length == 0;
    });
    //  CustomTabView(
    //   initPosition: initPosition,
    //   stub: SizedBox.shrink(),
    //   itemCount: menus.length,
    //   tabBuilder: (context, index) => Tab(text: menus[index].name),
    //   pageBuilder: (context, index) => VideosPage(
    //     menuId: menus[index].id,
    //   ),
    //   onPositionChange: (index) {
    //     print('current position: $index');
    //     initPosition = index;
    //   },
    //   onScroll: (position) => print('$position'),
    // ),
    return safeArea(myModel, menusItemList);
  }

  @override
  // @override
  // Future<void> dispose() async {
  //   await getPermission();
  //   await checkConnectionStatus();
  //   await _checkPermission();

  //   super.dispose();
  // }
  void dispose() {
    super.dispose();
    _scrollViewController!.dispose();
    // tabController.dispose();
  }
}
