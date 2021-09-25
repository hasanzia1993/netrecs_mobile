import 'package:flutter/material.dart';
import 'package:nexthour/common/route_paths.dart';

Widget registerHereText(context) {
  return ListTile(
      title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: InkWell(
            child: new RichText(
              text: new TextSpan(children: [
                new TextSpan(
                  text: "If you don't have an account? ",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Sign Up ',
                  style: new TextStyle(
                      color: Colors.amber,
                      fontSize: 17.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                )
              ]),
            ),
            onTap: () => Navigator.pushNamed(context, RoutePaths.register),
          ),
        ),
      ]));
}

Widget loginHereText(context) {
  return ListTile(
      title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: InkWell(
            child: new RichText(
              text: new TextSpan(children: [
                new TextSpan(
                  text: "Already have an account? ",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Sign In ',
                  style: new TextStyle(
                      color: Colors.amber,
                      fontSize: 17.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                )
              ]),
            ),
            onTap: () => Navigator.pushNamed(context, RoutePaths.login),
          ),
        ),
      ]));
}
