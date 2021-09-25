import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/models/blog_model.dart';
import 'package:nexthour/providers/app_config.dart';
import 'package:nexthour/ui/screens/blog_screen.dart';
import 'package:provider/provider.dart';

class BlogView extends StatefulWidget {
  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  Widget getBlogContents(List<Blog> blogs) {
    List<Widget> list = [];
    if (blogs.length < 3) {
      for (var i = 0; i < blogs.length; i++) {
        if (blogs[i].isActive == 1) {
          list.add(Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              height: 60,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Ink(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "${APIData.blogImageUri}${blogs[i].image}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${blogs[i].title}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    DateFormat.yMMMd().format(
                                      DateTime.parse("${blogs[i].createdAt}"),
                                    ),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 13.0),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.blog,
                        arguments: BlogScreen(i));
                  },
                ),
              )));
        }
      }
      list = list.reversed.toList();
    } else {
      for (var i = blogs.length - 1; i > blogs.length - 4; i--) {
        if (blogs[i].isActive == 1) {
          list.add(Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              height: 60,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Ink(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "${APIData.blogImageUri}${blogs[i].image}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${blogs[i].title}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    DateFormat.yMMMd().format(
                                      DateTime.parse("${blogs[i].createdAt}"),
                                    ),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 13.0),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  onTap: () {},
                ),
              )));
        }
      }
    }

    return Column(
      children: list.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var blog = Provider.of<AppConfig>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: getBlogContents(blog.appModel!.blogs!),
    );
  }
}
