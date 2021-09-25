import 'package:flutter/material.dart';

Widget toast = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Colors.red,
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.close, color: Colors.white,),
      SizedBox(
        width: 12.0,
      ),
      Text("The user credentials were incorrect..!", style: TextStyle(color: Colors.white),),
    ],
  ),
);