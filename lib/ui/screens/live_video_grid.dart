import 'package:flutter/material.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/models/episode.dart';
import 'package:nexthour/providers/menu_data_provider.dart';
import 'package:nexthour/ui/screens/video_detail_screen.dart';
import 'package:nexthour/ui/shared/appbar.dart';
import 'package:provider/provider.dart';

class LiveVideoGrid extends StatefulWidget {
  @override
  _LiveVideoGridState createState() => _LiveVideoGridState();
}

class _LiveVideoGridState extends State<LiveVideoGrid> {

  @override
  Widget build(BuildContext context) {
    var liveVideoList = Provider.of<MenuDataProvider>(context, listen: false).liveDataList;
    return Scaffold(
      appBar: customAppBar(context, "Live") as PreferredSizeWidget?,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: GridView.builder(
          itemCount: liveVideoList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 5/7.0
          ),
          itemBuilder: (BuildContext context, int index){
            return InkWell(
              child: Material(
                borderRadius: new BorderRadius.circular(5.0),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(5.0),
                  child: liveVideoList[index].thumbnail == null ? Image.asset("assets/placeholder_box.jpg",
                    height: 200,
                    width: 60.0,
                    fit: BoxFit.cover,) : FadeInImage.assetNetwork(
                    image: liveVideoList[index].type == DatumType.M ? "${APIData.movieImageUri}${liveVideoList[index].thumbnail}" :
                    "${APIData.tvImageUriTv}${liveVideoList[index].thumbnail}",
                    placeholder: "assets/placeholder_box.jpg",
                    height: 200,
                    width: 60.0,
                    imageScale: 1.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: (){
                Navigator.pushNamed(context, RoutePaths.videoDetail, arguments: VideoDetailScreen(liveVideoList[index]));
              },
            );
          },
        ),
      ),
    );
  }

}
