import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BlankWatchHistory extends StatefulWidget {
  @override
  _BlankWatchHistoryState createState() => _BlankWatchHistoryState();
}

class _BlankWatchHistoryState extends State<BlankWatchHistory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.solidPlayCircle,
              size: 150,
              color: Theme.of(context).cardColor.withOpacity(0.5),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                "Let's watch the most recent motion pictures,"
                    " elite TV appears at simply least cost.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),),
            ],
          ),
        )
      ],
    );
  }
}
