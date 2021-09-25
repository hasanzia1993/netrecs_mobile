import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/ui/widgets/grid_movie_tv.dart';

class Heading1 extends StatefulWidget {
  final String heading;
  final String type;
  Heading1(this.heading, this.type);

  @override
  _Heading1State createState() => _Heading1State();
}

class _Heading1State extends State<Heading1>
// with ChangeNotifier
{
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.heading,
            style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              child: Text(
                "View All",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.amber),
              ),
              onTap: () {
                if (widget.type == "Top") {
                  Navigator.pushNamed(context, RoutePaths.topVideos);
                } else if (widget.type == "TV") {
                  Navigator.pushNamed(context, RoutePaths.gridVideos,
                      arguments: GridMovieTV("T"));
                } else if (widget.type == "Mov") {
                  Navigator.pushNamed(context, RoutePaths.gridVideos,
                      arguments: GridMovieTV("M"));
                } else if (widget.type == "Blog") {
                  Navigator.pushNamed(context, RoutePaths.blogList);
                } else if (widget.type == "Actor") {
                  Navigator.pushNamed(context, RoutePaths.actorsGrid);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Heading2 extends StatefulWidget {
  final String heading;
  final String type;
  Heading2(this.heading, this.type);

  @override
  _Heading2State createState() => _Heading2State();
}

class _Heading2State extends State<Heading2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "${widget.heading}",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.red),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                CupertinoIcons.dot_radiowaves_right,
                color: Colors.red,
                size: 20.0,
              )
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              child: Text(
                "View All",
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.amber),
              ),
              onTap: () {
                if (widget.type == "Live") {
                  Navigator.pushNamed(context, RoutePaths.liveGrid);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
