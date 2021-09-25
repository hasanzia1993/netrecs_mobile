// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/common/styles.dart';
import 'package:nexthour/models/datum.dart';
import 'package:nexthour/models/episode.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:nexthour/providers/slider_provider.dart';
import 'package:nexthour/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<Datum>? showsMoviesList;

  Widget imageSlider() {
    final slider = Provider.of<SliderProvider>(context, listen: false);
    final movieTvList =
        Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
    return Stack(children: <Widget>[
      Container(
        child: slider.sliderModel!.slider!.length == 0
            ? SizedBox.shrink()
            : Swiper(
                scrollDirection: Axis.horizontal,
                loop: true,
                autoplay: true,
                duration: 500,
                autoplayDelay: 10000,
                autoplayDisableOnInteraction: true,
                itemCount: slider.sliderModel == null
                    ? 0
                    : slider.sliderModel!.slider!.length,
                itemBuilder: (BuildContext context, int index) {
                  var linkedTo =
                      slider.sliderModel!.slider![index].tvSeriesId != null
                          ? "shows/"
                          : slider.sliderModel!.slider![index].movieId != null
                              ? "movies/"
                              : "";
                  // debugPrint("${APIData.appSlider}" +
                  //     "$linkedTo" +
                  //     "${slider.sliderModel!.slider![index].slideImage}");
                  if (slider.sliderModel!.slider!.isEmpty) {
                    return SizedBox.shrink();
                  } else {
//                    if (slider.sliderModel!.slider![index].movieId == null) {
//                      if ("${APIData.silderImageUri}" + "shows/" + "${slider.sliderModel.slider[index].slideImage}" == "${APIData.silderImageUri}" + "shows/" + "null")
                    if ("${slider.sliderModel!.slider![index].slideImage}" ==
                        null) {
                      return SizedBox.shrink();
                    } else {
                      return InkWell(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                          // foregroundDecoration: BoxDecoration(
                          //   gradient: LinearGradient(
                          //     colors: [
                          //       Theme.of(context).primaryColorLight,
                          //       Colors.transparent,
                          //       Colors.transparent,
                          //       Theme.of(context).primaryColorLight,
                          //     ],
                          //     begin: Alignment.topCenter,
                          //     end: Alignment.bottomCenter,
                          //     stops: [0, 0.4, 0.7, 1],
                          //   ),
                          // ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("${APIData.appSlider}" +
                                  "$linkedTo" +
                                  "${slider.sliderModel!.slider![index].slideImage}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                // height: 350.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        Theme.of(context).primaryColorDark,
                                        // switchThemes
                                        // ? buildLightTheme()
                                        //     .primaryColorLight
                                        // : buildDarkTheme().primaryColorDark,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Theme.of(context).primaryColorDark,
                                        // Theme.of(context).primaryColorDark
                                        // switchThemes
                                        //     ? buildLightTheme()
                                        //         .primaryColorLight
                                        //     : buildDarkTheme().primaryColorDark,
                                      ],
                                      stops: [0.02, 0.4, 0.6, 1.0],
                                    )),
                              ),
                              SizedBox.shrink()
                            ],
                          ),
                          // child: new Image.network(
                          //   //                              "${APIData.silderImageUri}" +
                          //   //                                "shows/" + "${slider.sliderModel.slider[index].slideImage}",
                          //   "${APIData.appSlider}" +
                          //       "$linkedTo" +
                          //       "${slider.sliderModel!.slider![index].slideImage}",
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        // onTap: () {

                        // },
                      );
                    }
//                    }
//                    else {
////                      if ("${APIData.silderImageUri}" +
////                              "movies/" +
////                              "${slider.sliderModel.slider[index].slideImage}" ==
////                          "${APIData.silderImageUri}" + "movies/" + "null")
//                        if ("${slider.sliderModel!.slider![index].slideImage}" == null)
//                        {
//                        return SizedBox.shrink();
//                      } else {
//                        return InkWell(
//                          child: Padding(
//                            padding: const EdgeInsets.only(
//                                top: 0.0, bottom: 0.0, left: 3.0, right: 3.0),
//                            child: new Image.network(
////                              "${APIData.silderImageUri}" +
////                                  "movies/" +
////                                  "${slider.sliderModel.slider[index].slideImage}",
//                              "${APIData.appSlider}" +
//                                  "${slider.sliderModel!.slider![index].slideImage}",
//                              fit: BoxFit.cover,
//                            ),
//                          ),
//                          onTap: () {
//                            for(int i=0; i<movieTvList.length; i++){
//                              if(movieTvList[i].type == DatumType.M){
//                                if(movieTvList[i].id == slider.sliderModel!.slider![index].movieId){
//                                  Navigator.pushNamed(context, RoutePaths.videoDetail, arguments: VideoDetailScreen(movieTvList[i]));
//                                }
//                              }
//                            }
//                          },
//                        );
//                      }
//                    }
                  }
                },
//                viewportFraction: 0.93,

                // pagination: new SwiperPagination(
                //   margin: EdgeInsets.only(
                //     bottom: 30.0,
                //   ),
                //   builder: new DotSwiperPaginationBuilder(
                //     color: Colors.white,
                //     activeColor: activeDotColor,
                //   ),
                // ),
              ),
      ),
    ]);
  }

//   Widget carouseImagelSlider() {
//     final slider = Provider.of<SliderProvider>(context, listen: false);
//     final movieTvList =
//         Provider.of<MovieTVProvider>(context, listen: false).movieTvList;
//     return slider.sliderModel!.slider!.length == 0
//         ? SizedBox.shrink()
//         : CarouselSlider.builder(
//             itemCount: slider.sliderModel == null
//                 ? 0
//                 : slider.sliderModel!.slider!.length,
//             options: CarouselOptions(
//               // aspectRatio: 2.0,
//               enlargeCenterPage: true,
//               autoPlay: true,
//             ),
//             itemBuilder: (BuildContext context, int index, realIdx) {
//               var linkedTo =
//                   slider.sliderModel!.slider![index].tvSeriesId != null
//                       ? "shows/"
//                       : slider.sliderModel!.slider![index].movieId != null
//                           ? "movies/"
//                           : "";
//               // debugPrint("${APIData.appSlider}" +
//               //     "$linkedTo" +
//               //     "${slider.sliderModel!.slider![index].slideImage}");
//               if (slider.sliderModel!.slider!.isEmpty) {
//                 return SizedBox.shrink();
//               } else {
// //                    if (slider.sliderModel!.slider![index].movieId == null) {
// //                      if ("${APIData.silderImageUri}" + "shows/" + "${slider.sliderModel.slider[index].slideImage}" == "${APIData.silderImageUri}" + "shows/" + "null")
//                 if ("${slider.sliderModel!.slider![index].slideImage}" ==
//                     null) {
//                   return SizedBox.shrink();
//                 } else {
//                   return InkWell(
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
//                       child: new Image.network(
//                         //                              "${APIData.silderImageUri}" +
//                         //                                "shows/" + "${slider.sliderModel.slider[index].slideImage}",
//                         "${APIData.appSlider}" +
//                             "$linkedTo" +
//                             "${slider.sliderModel!.slider![index].slideImage}",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     onTap: () {
//                       for (int i = 0; i < movieTvList.length; i++) {
//                         if (movieTvList[i].type == DatumType.T) {
//                           if (movieTvList[i].id ==
//                               slider.sliderModel!.slider![index].tvSeriesId) {
//                             Navigator.pushNamed(context, RoutePaths.videoDetail,
//                                 arguments: VideoDetailScreen(movieTvList[i]));
//                           }
//                         } else if (movieTvList[i].type == DatumType.M) {
//                           if (movieTvList[i].id ==
//                               slider.sliderModel!.slider![index].movieId) {
//                             Navigator.pushNamed(context, RoutePaths.videoDetail,
//                                 arguments: VideoDetailScreen(movieTvList[i]));
//                           }
//                         }
//                       }
//                     },
//                   );
//                 }
//               }
//             },
//           );
//   }

  @override
  Widget build(BuildContext context) {
    final slider =
        Provider.of<SliderProvider>(context, listen: false).sliderModel!;
    return slider.slider == null
        ? SizedBox.shrink()
        : Container(
            // margin: EdgeInsets.only(bottom: 20.0),
            // height: MediaQuery.of(context).size.height * Constants.sliderHeight,
            child:
                // carouseImagelSlider()
                imageSlider(),
          );
  }
}
