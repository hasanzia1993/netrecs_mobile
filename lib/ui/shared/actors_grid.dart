import 'package:flutter/material.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/providers/main_data_provider.dart';
import 'package:nexthour/ui/screens/actors_movies_grid.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:provider/provider.dart';

class ActorsGrid extends StatefulWidget {
  @override
  _ActorsGridState createState() => _ActorsGridState();
}

class _ActorsGridState extends State<ActorsGrid> {
  List<Widget>? videoList;

  @override
  Widget build(BuildContext context) {
    var actorsList = Provider.of<MainProvider>(context, listen: false).actorList;
    return Scaffold(
      appBar: customAppBar(context, "Artist") as PreferredSizeWidget?,
      body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: GridView.builder(
              itemCount: actorsList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
//            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 5/6.0
              ),
              itemBuilder: (BuildContext context, int index){
                return Column(
                    children: [
                        Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(width: 2.0, color: Colors.white)),
                          child: Material(
                            borderRadius: new BorderRadius.circular(100.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100.0),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(100.0),
                                child: new FadeInImage.assetNetwork(
                                  image: "${APIData.actorsImages}${actorsList[index].image}",
                                  placeholder: "assets/placeholder_box.jpg",
                                  imageScale: 1.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: (){
                                Navigator.pushNamed(context, RoutePaths.actorMoviesGrid, arguments: ActorMoviesGrid(actorsList[index]));
                              },
                            ),
                          ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "${actorsList[index].name}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                );
              },
            )),
    );
  }
}
