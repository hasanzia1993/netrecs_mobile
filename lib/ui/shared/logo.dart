import 'package:flutter/material.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:provider/provider.dart';

//    Logo image on login page
Widget logoImage(context, myModel, scale, height, width) {
  var logo = Provider.of<AppConfig>(context).appModel == null
      ? null
      : Provider.of<AppConfig>(context).appModel!.config!.logo;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      logo != null
          ? Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20.0),
              child: Container(
                child: Image.network(
                  '${APIData.logoImageUri}$logo',
                  scale: scale,
                  height: height,
                  width: width,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20.0),
              child: Container(
                child: Image.asset(
                  'assets/logo.png',
                  scale: scale,
                  height: height,
                  width: width,
                ),
              ),
            )
    ],
  );
}
