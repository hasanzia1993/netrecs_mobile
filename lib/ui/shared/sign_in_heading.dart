import 'package:flutter/material.dart';

Widget signInHeadingText() {
  return Padding(
    padding: EdgeInsets.only(left: 10.0, right: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Sign In!",
          style: TextStyle(
              color: Color.fromRGBO(34, 34, 34, 1.0),
              fontSize: 22,
              fontWeight: FontWeight.w800),
          textAlign: TextAlign.start,
        )
      ],
    ),
  );
}