import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/common/styles.dart';
import 'package:nexthour/models/login_model.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/providers/faq_provider.dart';
import 'package:nexthour/providers/login_provider.dart';
import 'package:nexthour/providers/main_data_provider.dart';
import 'package:nexthour/providers/menu_provider.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:nexthour/providers/slider_provider.dart';
import 'package:nexthour/providers/user_profile_provider.dart';
import 'package:nexthour/services/firebase_auth.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:nexthour/ui/shared/logo.dart';
import 'package:nexthour/ui/widgets/register_here.dart';
import 'package:nexthour/ui/widgets/reset_alert_container.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _isHidden = true;
  String msg = '';
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isLoggedIn = false;
  var profileData;
  var facebookLogin = FacebookLogin();
  bool isShowing = false;
  late LoginModel loginModel;

  // Initialize login with facebook
  void initiateFacebookLogin() async {
    var facebookLoginResult;
    var facebookLoginResult2 = await facebookLogin.isLoggedIn;
    print(facebookLoginResult2);
    if (facebookLoginResult2 == true) {
      facebookLoginResult = await facebookLogin.currentAccessToken;

      var graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.token}'));

      var profile = json.decode(graphResponse.body);
      setState(() {
        isShowing = true;
      });
      var name = profile['name'];
      var email = profile['email'];
      var code = profile['id'];
      var password = "password";
      goToDialog();
      socialLogin(APIData.fbLoginApi, email, password, code, name, "code");

      onLoginStatusChanged(true, profileData: profile);
    } else {
      facebookLoginResult = await facebookLogin.logIn(['email']);

      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.cancelledByUser:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.loggedIn:
          var graphResponse = await http.get(Uri.parse(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}'));

          var profile = json.decode(graphResponse.body);
          var name = profile['name'];
          var email = profile['email'];
          var code = profile['id'];
          var password = "password";
          socialLogin(APIData.fbLoginApi, email, password, code, name, "code");
          onLoginStatusChanged(true, profileData: profile);
          break;
      }
    }
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  Future<String?> socialLogin(url, email, password, code, name, uid) async {
    final accessTokenResponse = await http.post(url, body: {
      "email": email,
      "password": password,
      "$uid": code,
      "name": name,
    });
    print(accessTokenResponse.statusCode);
    print(accessTokenResponse.body);
    if (accessTokenResponse.statusCode == 200) {
      loginModel = LoginModel.fromJson(json.decode(accessTokenResponse.body));
      var refreshToken = loginModel.refreshToken!;
      var mToken = loginModel.accessToken!;
      debugPrint("storing-data-started");
      await storage.write(key: "login", value: "true");
      await storage.write(key: "authToken", value: mToken);
      await storage.write(key: "refreshToken", value: refreshToken);
      debugPrint("data-stored");
      setState(() {
        authToken = mToken;
      });
      fetchAppData(context);
    } else {
      setState(() {
        isShowing = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error in login");
    }
    return null;
  }

  Future<void> fetchAppData(ctx) async {
    MenuProvider menuProvider = Provider.of<MenuProvider>(ctx, listen: false);
    UserProfileProvider userProfileProvider =
        Provider.of<UserProfileProvider>(ctx, listen: false);
    MainProvider mainProvider = Provider.of<MainProvider>(ctx, listen: false);
    SliderProvider sliderProvider =
        Provider.of<SliderProvider>(ctx, listen: false);
    MovieTVProvider movieTVProvider =
        Provider.of<MovieTVProvider>(ctx, listen: false);
    FAQProvider faqProvider = Provider.of<FAQProvider>(ctx, listen: false);
    await menuProvider.getMenus(ctx);
    await sliderProvider.getSlider();
    await userProfileProvider.getUserProfile(ctx);
    await faqProvider.fetchFAQ(ctx);
    await mainProvider.getMainApiData(ctx);
    await movieTVProvider.getMoviesTVData(ctx);
    setState(() {
      isShowing = false;
    });
    setState(() {
      isShowing = false;
    });
    Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      print("sss1:");
      await loginProvider.login(
          _emailController.text, _passwordController.text, context);
      print("sss2:");
      if (loginProvider.loginStatus == true) {
        print("sss3:");
        final userDetails =
            Provider.of<UserProfileProvider>(context, listen: false)
                .userProfileModel!;
        if (userDetails.payment == "Free") {
          Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
        } else if (userDetails.active == 1 || userDetails.active == "1") {
          Navigator.pushNamed(context, RoutePaths.multiScreen);
        } else {
          Navigator.pushNamed(context, RoutePaths.bottomNavigationHome);
        }
      } else if (loginProvider.emailVerify == false) {
        print("sss4:");
        setState(() {
          setState(() {
            _isLoading = false;
            _emailController.text = '';
            _passwordController.text = '';
          });
        });
        showAlertDialog(context, loginProvider.emailVerifyMsg);
      } else {
        print("sss5:");
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "The user credentials were incorrect..!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error) {
      print("sss: $error");
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text(
            'An error occurred!',
            style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.blueAccent,
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  showAlertDialog(BuildContext context, String msg) {
    var msg1 = msg.replaceAll('"', "");
    Widget okButton = FlatButton(
      color: Colors.amber,
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(
        "Verify Email!",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.amber, fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
      content: Text("$msg1 Verify email sent on your register email.",
          style: TextStyle(
            color: Theme.of(context).backgroundColor,
            fontSize: 16.0,
          )),
      actions: [
        okButton,
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
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.amber),
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

  resetPasswordAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: ResetAlertBoxContainer(),
          );
        });
  }

// Toggle for visibility
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Widget msgTitle() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        "Login to watch latest movies TV series, comedy shows and entertainment videos",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: TextFormField(
        controller: _emailController,
        validator: (value) {
          if (value!.length == 0) {
            return 'Email can not be empty';
          } else {
            if (!value.contains('@')) {
              return 'Invalid Email';
            } else {
              return null;
            }
          }
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail_outline,
            color: Colors.amber,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding:
          EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 20.0),
      child: TextFormField(
        controller: _passwordController,
        validator: (value) {
          if (value!.length < 6) {
            if (value.length == 0) {
              return 'Password can not be empty';
            } else {
              return 'Password too short';
            }
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.text,
        obscureText: _isHidden == true ? true : false,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.amber,
          ),
          suffixIcon: IconButton(
            onPressed: _toggleVisibility,
            icon: _isHidden
                ? Text(
                    "Show",
                    style: TextStyle(fontSize: 10.0, color: Colors.white),
                  )
                : Text(
                    "Hide",
                    style: TextStyle(fontSize: 10.0, color: Colors.white),
                  ),
          ),
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var myModel = Provider.of<AppConfig>(context).appModel == null
        ? null
        : Provider.of<AppConfig>(context).appModel;
    var type = MediaQuery.of(context).size.width;
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: type > 900
          ? Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          registerHereText(context),
                          logoImage(context, myModel, 0.9, 63.0, 200.0),
                          msgTitle(),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: emailField(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: passwordField(),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    onPressed: resetPasswordAlertBox,
                                    child: Text(
                                      'Forgot Password ?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        primary: Colors.amber,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.0),
                                      ),
                                      // padding: EdgeInsets.symmetric(vertical: 15.0),

                                      child: _isLoading == true
                                          ? SizedBox(
                                              height: 20.0,
                                              width: 20.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.amber),
                                              ),
                                            )
                                          : Text(
                                              'SIGN IN',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                      onPressed:
                                          _isLoading == true ? null : _saveForm,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 65.0,
                            ),
                            myModel!.config!.googleLogin == 1 ||
                                    "${myModel.config!.googleLogin}" == "1"
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: ButtonTheme(
                                              height: 50.0,
                                              child: RaisedButton.icon(
                                                  icon: Image.asset(
                                                    "assets/google_logo.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  label: Text(
                                                    "Google Sign In",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .backgroundColor,
                                                        fontSize: 16.0),
                                                  ),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    signInWithGoogle()
                                                        .then((result) {
                                                      if (result != null) {
                                                        setState(() {
                                                          isShowing = true;
                                                        });
                                                        var email =
                                                            result.email;
                                                        var password =
                                                            "password";
                                                        var code = result.uid;
                                                        var name =
                                                            result.displayName;
                                                        goToDialog();
                                                        socialLogin(
                                                            APIData
                                                                .googleLoginApi,
                                                            email,
                                                            password,
                                                            code,
                                                            name,
                                                            "uid");
                                                      }
                                                    });
                                                  }),
                                            )),
                                      ],
                                    ))
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 15.0,
                            ),
                            myModel.config!.fbLogin == 1 ||
                                    "${myModel.config!.fbLogin}" == "1"
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: ButtonTheme(
                                            height: 50.0,
                                            child: RaisedButton.icon(
                                                icon: Icon(
                                                  FontAwesomeIcons.facebook,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                                label: Text(
                                                  "Facebook Sign In",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0),
                                                ),
                                                color: Color.fromRGBO(
                                                    60, 90, 153, 1.0),
                                                onPressed: () {
                                                  initiateFacebookLogin();
                                                }),
                                          ),
                                        ),
                                      ],
                                    ))
                                : SizedBox.shrink(),
                          ],
                        ),
                      ))
                ],
              ),
            )
          : Scaffold(
              appBar: customAppBar(context, "Login") as PreferredSizeWidget?,
              body: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        logoImage(context, myModel, 0.9, 63.0, 200.0),
                        msgTitle(),
                        emailField(),
                        passwordField(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                onPressed: resetPasswordAlertBox,
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    primary: Colors.amber,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                  ),
                                  // padding: EdgeInsets.symmetric(vertical: 15.0),

                                  child: _isLoading == true
                                      ? SizedBox(
                                          height: 20.0,
                                          width: 20.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.amber),
                                          ),
                                        )
                                      : Text(
                                          'SIGN IN',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                  onPressed:
                                      _isLoading == true ? null : _saveForm,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 40.0,
                        // ),
                        //       myModel != null
                        //           ? myModel.config!.googleLogin == 1 ||
                        //                   "${myModel.config!.googleLogin}" == "1"
                        //               ? Padding(
                        //                   padding:
                        //                       EdgeInsets.symmetric(horizontal: 15.0),
                        //                   child: Row(
                        //                     children: [
                        //                       Expanded(
                        //                           flex: 1,
                        //                           child: ButtonTheme(
                        //                             height: 50.0,
                        //                             child: RaisedButton.icon(
                        //                                 icon: Image.asset(
                        //                                   "assets/google_logo.png",
                        //                                   height: 30,
                        //                                   width: 30,
                        //                                 ),
                        //                                 label: Text(
                        //                                   "Google Sign In",
                        //                                   style: TextStyle(
                        //                                       color: Theme.of(context)
                        //                                           .backgroundColor,
                        //                                       fontSize: 16.0),
                        //                                 ),
                        //                                 color: Colors.white,
                        //                                 onPressed: () {
                        //                                   signInWithGoogle()
                        //                                       .then((result) {
                        //                                     if (result != null) {
                        //                                       setState(() {
                        //                                         isShowing = true;
                        //                                       });
                        //                                       var email =
                        //                                           result.email;
                        //                                       var password =
                        //                                           "password";
                        //                                       var code = result.uid;
                        //                                       var name =
                        //                                           result.displayName;
                        //                                       goToDialog();
                        //                                       socialLogin(
                        //                                           APIData
                        //                                               .googleLoginApi,
                        //                                           email,
                        //                                           password,
                        //                                           code,
                        //                                           name,
                        //                                           "uid");
                        //                                     }
                        //                                   });
                        //                                 }),
                        //                           )),
                        //                     ],
                        //                   ))
                        //               : SizedBox.shrink()
                        //           : SizedBox.shrink(),
                        //       SizedBox(
                        //         height: 15.0,
                        //       ),
                        //       myModel != null
                        //           ? myModel.config!.fbLogin == 1 ||
                        //                   "${myModel.config!.fbLogin}" == "1"
                        //               ? Padding(
                        //                   padding:
                        //                       EdgeInsets.symmetric(horizontal: 15.0),
                        //                   child: Row(
                        //                     children: [
                        //                       Expanded(
                        //                         flex: 1,
                        //                         child: ButtonTheme(
                        //                           height: 50.0,
                        //                           child: RaisedButton.icon(
                        //                               icon: Icon(
                        //                                 FontAwesomeIcons.facebook,
                        //                                 color: Colors.white,
                        //                                 size: 28,
                        //                               ),
                        //                               label: Text(
                        //                                 "Facebook Sign In",
                        //                                 style: TextStyle(
                        //                                     color: Colors.white,
                        //                                     fontSize: 16.0),
                        //                               ),
                        //                               color: Color.fromRGBO(
                        //                                   60, 90, 153, 1.0),
                        //                               onPressed: () {
                        //                                 initiateFacebookLogin();
                        //                               }),
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ))
                        //               : SizedBox.shrink()
                        //           : SizedBox.shrink()
                      ],
                    ),
                  ),
                  registerHereText(context),
                ],
              )),
    );
  }
}
