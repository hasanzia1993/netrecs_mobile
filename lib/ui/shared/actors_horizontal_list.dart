import 'package:flutter/material.dart';
import 'package:nexthour/common/apipath.dart';
import 'package:nexthour/common/route_paths.dart';
import 'package:nexthour/models/comment.dart';
import 'package:nexthour/models/datum.dart';
import 'package:nexthour/models/episode.dart';
import 'package:nexthour/models/seasons.dart';
import 'package:nexthour/providers/main_data_provider.dart';
import 'package:nexthour/providers/movie_tv_provider.dart';
import 'package:nexthour/ui/screens/actors_movies_grid.dart';
import 'package:provider/provider.dart';

class ActorsHorizontalList extends StatefulWidget {
  @override
  _ActorsHorizontalListState createState() => _ActorsHorizontalListState();
}

class _ActorsHorizontalListState extends State<ActorsHorizontalList> {
  List<Datum> actorsDataList = [];

  getActorsData(id, movieTvList, actorsList) {
    actorsDataList = [];
    for (int p = 0; p < movieTvList.length; p++) {
      for (int j = 0; j < movieTvList[p].actors.length; j++) {
        if (movieTvList[p].actors == null || movieTvList[p].actors[j] == null) {
          break;
        } else {
          if (id == movieTvList[p].actors[j].id) {
            var genreData = movieTvList[p].genreId == null
                ? null
                : movieTvList[p].genreId.split(",").toList();
            actorsDataList.add(Datum(
              id: movieTvList[p].id,
              actorId: movieTvList[p].actorId,
              title: movieTvList[p].title,
              trailerUrl: movieTvList[p].trailerUrl,
              status: movieTvList[p].status,
              keyword: movieTvList[p].keyword,
              description: movieTvList[p].description,
              duration: movieTvList[p].duration,
              thumbnail: movieTvList[p].thumbnail,
              poster: movieTvList[p].poster,
              directorId: movieTvList[p].directorId,
              detail: movieTvList[p].detail,
              rating: movieTvList[p].rating,
              maturityRating: movieTvList[p].maturityRating,
              publishYear: movieTvList[p].publishYear,
              released: movieTvList[p].released,
              uploadVideo: movieTvList[p].uploadVideo,
              featured: movieTvList[p].featured,
              series: movieTvList[p].series,
              aLanguage: movieTvList[p].aLanguage,
              live: movieTvList[p].live,
              createdBy: movieTvList[p].createdBy,
              createdAt: movieTvList[p].createdAt,
              updatedAt: movieTvList[p].updatedAt,
              userRating: movieTvList[p].userRating,
              movieSeries: movieTvList[p].movieSeries,
              videoLink: movieTvList[p].videoLink,
              genre: List.generate(genreData == null ? 0 : genreData.length,
                  (int genreIndex) {
                return "${genreData[genreIndex]}";
              }),
              genres: List.generate(actorsList.length, (int gIndex) {
                var genreId2 = actorsList[gIndex].id.toString();
                var genreNameList = List.generate(
                    genreData == null ? 0 : genreData.length, (int nameIndex) {
                  return "${genreData[nameIndex]}";
                });
                var isAv2 = 0;
                for (var y in genreNameList) {
                  if (genreId2 == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if (actorsList[gIndex].name == null) {
                    return null;
                  } else {
                    return "${actorsList[gIndex].name}";
                  }
                }
                return null;
              }),
              comments: List.generate(
                  movieTvList[p].comments == null
                      ? 0
                      : movieTvList[p].comments.length, (cIndex) {
                return Comment(
                  id: movieTvList[p].comments[cIndex].id,
                  name: movieTvList[p].comments[cIndex].name,
                  email: movieTvList[p].comments[cIndex].email,
                  movieId: movieTvList[p].comments[cIndex].movieId,
                  tvSeriesId: movieTvList[p].comments[cIndex].tvSeriesId,
                  comment: movieTvList[p].comments[cIndex].comment,
                  createdAt: movieTvList[p].comments[cIndex].createdAt,
                  updatedAt: movieTvList[p].comments[cIndex].updatedAt,
                );
              }),
              episodeRuntime: movieTvList[p].episodeRuntime,
              genreId: movieTvList[p].genreId,
              type: movieTvList[p].type,
              seasons: List.generate(
                  movieTvList[p].seasons == null
                      ? 0
                      : movieTvList[p].seasons.length, (sIndex) {
                return Season(
                  id: movieTvList[p].seasons[sIndex].id,
                  thumbnail: movieTvList[p].seasons[sIndex].thumbnail,
                  poster: movieTvList[p].seasons[sIndex].poster,
                  publishYear: movieTvList[p].seasons[sIndex].publishYear,
                  episodes: List.generate(
                      movieTvList[p].seasons[sIndex].episodes == null
                          ? 0
                          : movieTvList[p].seasons[sIndex].episodes.length,
                      (eIndex) {
                    return Episode(
                      id: movieTvList[p].seasons[sIndex].episodes[eIndex].id,
                      thumbnail: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .thumbnail,
                      title:
                          movieTvList[p].seasons[sIndex].episodes[eIndex].title,
                      detail: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .detail,
                      duration: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .duration,
                      createdAt: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .createdAt,
                      updatedAt: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .updatedAt,
                      episodeNo: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .episodeNo,
                      aLanguage: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .aLanguage,
                      released: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .released,
                      seasonsId: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .seasonsId,
                      videoLink: movieTvList[p]
                          .seasons[sIndex]
                          .episodes[eIndex]
                          .videoLink,
                    );
                  }),
                  actorId: movieTvList[p].seasons[sIndex].actorId,
                  aLanguage: movieTvList[p].seasons[sIndex].aLanguage,
                  createdAt: movieTvList[p].seasons[sIndex].createdAt,
                  updatedAt: movieTvList[p].seasons[sIndex].updatedAt,
                  featured: movieTvList[p].seasons[sIndex].featured,
                  tmdb: movieTvList[p].seasons[sIndex].tmdb,
                  tmdbId: movieTvList[p].seasons[sIndex].tmdbId,
                  subtitle: movieTvList[p].seasons[sIndex].subtitle,
                  subtitleList: movieTvList[p].seasons[sIndex].subtitleList,
                );
              }),
            ));
          } else {
            print("no");
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var actorsList =
        Provider.of<MainProvider>(context, listen: false).actorList;
    return Container(
      height: 152,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.only(left: 15.0),
          itemCount: actorsList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(40.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(right: 15.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(1.0),
                              Theme.of(context).primaryColorDark
                            ],
                            stops: [
                              0.3,
                              0.8
                            ]),
                        borderRadius: BorderRadius.circular(0.0),
                        border: Border.all(
                            width: 0.0,
                            color: Colors.white,
                            style: BorderStyle.none)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: actorsList[index].image == null
                          ? Image.asset(
                              "assets/placeholder_box.jpg",
                              fit: BoxFit.cover,
                              height: 150.0,
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: "assets/placeholder_box.jpg",
                              image:
                                  "${APIData.actorsImages}${actorsList[index].image}",
                              fit: BoxFit.cover,
                              height: 150.0,
                            ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 152.0,
                    width: 101.3,
                    margin: EdgeInsets.only(
                      right: 15.0,
                    ),
                    padding: EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Theme.of(context).primaryColorDark.withOpacity(0.1),
                            Theme.of(context).primaryColorDark.withOpacity(0.7),
                            Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.95),
                            Theme.of(context).primaryColorDark
                          ],
                          stops: [
                            0.3,
                            0.65,
                            0.85,
                            1.0
                          ]),
                    ),
                    child: Text(
                      '${actorsList[index].name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).accentColor.withOpacity(0.6),
                          fontSize: 13.0),
                    ),
                  ),
                ],
              ),
              onTap: () => Navigator.pushNamed(
                  context, RoutePaths.actorMoviesGrid,
                  arguments: ActorMoviesGrid(actorsList[index])),
            );
          }),
    );
  }
}
