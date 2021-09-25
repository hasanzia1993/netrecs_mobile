import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/global.dart';
import 'package:nexthour/models/comment.dart';
import 'package:nexthour/models/datum.dart';
import 'package:nexthour/models/episode.dart';
import 'package:nexthour/models/seasons.dart';
import 'package:nexthour/models/watch_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:nexthour/providers/main_data_provider.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:provider/provider.dart';

class WatchHistoryProvider with ChangeNotifier {
  List<Datum> tvWishList = [];
  WatchHistoryModel? watchHistoryModel;

  Future<WatchHistoryModel?> getWatchHistory(BuildContext context) async {
    var token = await storage.read(key: "authToken");
    final response = await http.get(Uri.parse(APIData.watchHistory), headers: {
      // HttpHeaders.contentTypeHeader: "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    if (response.statusCode == 200) {
      watchHistoryModel =
          WatchHistoryModel.fromJson(json.decode(response.body));
    } else {
      throw "Can't get watch history data";
    }
    notifyListeners();
    return watchHistoryModel;
  }

//  fetchWishList(moviesTvList, wishListModel, genreList) {
//    for(int i=0; i<moviesTvList.length; i++){
//      for(int j=0; j<wishListModel.wishlist.length; j++){
//        if(moviesTvList[i].type == DatumType.M){
//          if(moviesTvList[i].id == wishListModel.wishlist[j].movieId){
//            var genreData = moviesTvList[i].genreId == null ? null : moviesTvList[i].genreId.split(",").toList();
//            moviesWishList.add(Datum(
//              id: moviesTvList[i].id,
//              actorId: moviesTvList[i].actorId,
//              title: moviesTvList[i].title,
//              trailerUrl: moviesTvList[i].trailerUrl,
//              status: moviesTvList[i].status,
//              keyword: moviesTvList[i].keyword,
//              description: moviesTvList[i].description,
//              duration: moviesTvList[i].duration,
//              thumbnail: moviesTvList[i].thumbnail,
//              poster: moviesTvList[i].poster,
//              directorId: moviesTvList[i].directorId,
//              detail: moviesTvList[i].detail,
//              rating: moviesTvList[i].rating,
//              maturityRating: moviesTvList[i].maturityRating,
//              publishYear: moviesTvList[i].publishYear,
//              released: moviesTvList[i].released,
//              uploadVideo: moviesTvList[i].uploadVideo,
//              featured: moviesTvList[i].featured,
//              series: moviesTvList[i].series,
//              aLanguage: moviesTvList[i].aLanguage,
//              live: moviesTvList[i].live,
//              createdBy: moviesTvList[i].createdBy,
//              createdAt: moviesTvList[i].createdAt,
//              updatedAt: moviesTvList[i].updatedAt,
//              userRating: moviesTvList[i].userRating,
//              movieSeries: moviesTvList[i].movieSeries,
//              videoLink: moviesTvList[i].videoLink,
//              genre: List.generate(genreData == null ? 0 : genreData.length,
//                      (int genreIndex) {
//                    return "${genreData[genreIndex]}";
//                  }),
//              genres: List.generate(genreList.length,
//                      (int gIndex) {
//                    var genreId2 = genreList[gIndex].id.toString();
//                    var genreNameList = List.generate(genreData == null ? 0 : genreData.length,
//                            (int nameIndex) {
//                          return "${genreData[nameIndex]}";
//                        });
//                    var isAv2 = 0;
//                    for (var y in genreNameList) {
//                      if (genreId2 == y) {
//                        isAv2 = 1;
//                        break;
//                      }
//                    }
//                    if (isAv2 == 1) {
//                      if (genreList[gIndex].name == null) {
//                        return null;
//                      } else {
//                        return "${genreList[gIndex].name}";
//                      }
//                    }
//                    return null;
//                  }),
//              comments: List.generate(moviesTvList[i].comments == null ? 0 : moviesTvList[i].comments.length, (cIndex) {
//                return Comment(
//                  id: moviesTvList[i].comments[cIndex].id,
//                  name: moviesTvList[i].comments[cIndex].name,
//                  email: moviesTvList[i].comments[cIndex].email,
//                  movieId: moviesTvList[i].comments[cIndex].movieId,
//                  tvSeriesId: moviesTvList[i].comments[cIndex].tvSeriesId,
//                  comment: moviesTvList[i].comments[cIndex].comment,
//                  subcomments: moviesTvList[i].comments[cIndex].subcomments,
//                  createdAt: moviesTvList[i].comments[cIndex].createdAt,
//                  updatedAt: moviesTvList[i].comments[cIndex].updatedAt,
//                );
//              }),
//              episodeRuntime: moviesTvList[i].episodeRuntime,
//              genreId: moviesTvList[i].genreId,
//              type: moviesTvList[i].type,
//              tmdbId: moviesTvList[i].tmdbId,
//              tmdb: moviesTvList[i].tmdb,
//              fetchBy: moviesTvList[i].fetchBy,
//            ));
//          }
//        }
//        else{
//          var seasonData = moviesTvList[i].seasons;
//          for(int k = 0; k<seasonData.length; k++){
//            if(seasonData[k].id == wishListModel.wishlist[j].seasonId) {
//              var genreData = moviesTvList[i].genreId == null ? null : moviesTvList[i].genreId.split(",").toList();
//              tvWishList.add(Datum(
//                id: moviesTvList[i].id,
//                actorId: moviesTvList[i].actorId,
//                title: moviesTvList[i].title,
//                trailerUrl: moviesTvList[i].trailerUrl,
//                status: moviesTvList[i].status,
//                keyword: moviesTvList[i].keyword,
//                description: moviesTvList[i].description,
//                duration: moviesTvList[i].duration,
//                thumbnail: moviesTvList[i].thumbnail,
//                poster: moviesTvList[i].poster,
//                directorId: moviesTvList[i].directorId,
//                detail: moviesTvList[i].detail,
//                rating: moviesTvList[i].rating,
//                maturityRating: moviesTvList[i].maturityRating,
//                publishYear: moviesTvList[i].publishYear,
//                released: moviesTvList[i].released,
//                uploadVideo: moviesTvList[i].uploadVideo,
//                featured: moviesTvList[i].featured,
//                series: moviesTvList[i].series,
//                aLanguage: moviesTvList[i].aLanguage,
//                live: moviesTvList[i].live,
//                createdBy: moviesTvList[i].createdBy,
//                createdAt: moviesTvList[i].createdAt,
//                updatedAt: moviesTvList[i].updatedAt,
//                userRating: moviesTvList[i].userRating,
//                movieSeries: moviesTvList[i].movieSeries,
//                videoLink: moviesTvList[i].videoLink,
//                genre: List.generate(genreData == null ? 0 : genreData.length,
//                        (int genreIndex) {
//                      return "${genreData[genreIndex]}";
//                    }),
//                genres: List.generate(genreList.length,
//                        (int gIndex) {
//                      var genreId2 = genreList[gIndex].id.toString();
//                      var genreNameList = List.generate(genreData == null ? 0 : genreData.length,
//                              (int nameIndex) {
//                            return "${genreData[nameIndex]}";
//                          });
//                      var isAv2 = 0;
//                      for (var y in genreNameList) {
//                        if (genreId2 == y) {
//                          isAv2 = 1;
//                          break;
//                        }
//                      }
//                      if (isAv2 == 1) {
//                        if (genreList[gIndex].name == null) {
//                          return null;
//                        } else {
//                          return "${genreList[gIndex].name}";
//                        }
//                      }
//                      return null;
//                    }),
//                comments: List.generate(
//                    moviesTvList[i].comments == null ? 0 : moviesTvList[i]
//                        .comments.length, (cIndex) {
//                  return Comment(
//                    id: moviesTvList[i].comments[cIndex].id,
//                    name: moviesTvList[i].comments[cIndex].name,
//                    email: moviesTvList[i].comments[cIndex].email,
//                    movieId: moviesTvList[i].comments[cIndex].movieId,
//                    tvSeriesId: moviesTvList[i].comments[cIndex].tvSeriesId,
//                    comment: moviesTvList[i].comments[cIndex].comment,
//                    subcomments: moviesTvList[i].comments[cIndex].subcomments,
//                    createdAt: moviesTvList[i].comments[cIndex].createdAt,
//                    updatedAt: moviesTvList[i].comments[cIndex].updatedAt,
//                  );
//                }),
//                episodeRuntime: moviesTvList[i].episodeRuntime,
//                genreId: moviesTvList[i].genreId,
//                type: moviesTvList[i].type,
//                seasons: List.generate(
//                    moviesTvList[i].seasons == null ? 0 : moviesTvList[i].seasons
//                        .length, (sIndex) {
//                  return Season(
//                    id: moviesTvList[i].seasons[sIndex].id,
//                    thumbnail: moviesTvList[i].seasons[sIndex].thumbnail,
//                    poster: moviesTvList[i].seasons[sIndex].poster,
//                    publishYear: moviesTvList[i].seasons[sIndex].publishYear,
//                    episodes: List.generate(
//                        moviesTvList[i].seasons[sIndex].episodes == null
//                            ? 0
//                            : moviesTvList[i].seasons[sIndex].episodes.length,
//                            (eIndex) {
//                          return Episode(
//                            id: moviesTvList[i].seasons[sIndex].episodes[eIndex]
//                                .id,
//                            thumbnail: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].thumbnail,
//                            title: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].title,
//                            detail: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].detail,
//                            duration: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].duration,
//                            createdAt: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].createdAt,
//                            updatedAt: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].updatedAt,
//                            episodeNo: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].episodeNo,
//                            aLanguage: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].aLanguage,
//                            released: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].released,
//                            seasonsId: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].seasonsId,
//                            videoLink: moviesTvList[i].seasons[sIndex]
//                                .episodes[eIndex].videoLink,
//                          );
//                        }),
//
//                    actorId: moviesTvList[i].seasons[sIndex].actorId,
//                    aLanguage: moviesTvList[i].seasons[sIndex].aLanguage,
//                    createdAt: moviesTvList[i].seasons[sIndex].createdAt,
//                    updatedAt: moviesTvList[i].seasons[sIndex].updatedAt,
//                    featured: moviesTvList[i].seasons[sIndex].featured,
//                    tmdb: moviesTvList[i].seasons[sIndex].tmdb,
//                    tmdbId: moviesTvList[i].seasons[sIndex].tmdbId,
//                    subtitle: moviesTvList[i].seasons[sIndex].subtitle,
//                    subtitleList: moviesTvList[i].seasons[sIndex].subtitleList,
//                  );
//                }),
//                tmdbId: moviesTvList[i].tmdbId,
//                tmdb: moviesTvList[i].tmdb,
//                fetchBy: moviesTvList[i].fetchBy,
//              ));
//            }
//          }
//        }
//      }
//    }
//  }
}
