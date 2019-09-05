import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/movie_genre_list.dart';
import '../models/movie_page_result.dart';

class TheMovieDBApi {
  static const String TMDB_API_KEY = "PUT YOUR KEY, HERE";
  static const String baseUrl = 'api.themoviedb.org';
  final String imageBaseUrl = 'http://image.tmdb.org/t/p/w185/';
  final _httpClient = HttpClient();

  Future<MoviePageResult> pagedList(
      {String type: "movie",
      int pageIndex: 1,
      int minYear: 2016,
      int maxYear: 2017,
      int genre: 28}) async {
    var uri = Uri.https(
      baseUrl,
      '3/discover/$type',
      <String, String>{
        'api_key': TMDB_API_KEY,
        'language': 'en-US',
        'sort_by': 'popularity.desc',
        'include_adult': 'false',
        'include_video': 'false',
        'page': '$pageIndex',
        'release_date.gte': '$minYear',
        'release_date.lte': '$maxYear',
        'with_genres': '$genre',
      },
    );

    var response = await _getRequest(uri);
    MoviePageResult list = MoviePageResult.fromJson(json.decode(response));

    // Give some additional delay to simulate slow network
    await Future.delayed(const Duration(seconds: 1));

    return list;
  }

  Future<MovieGenresList> getMovieGenres({String type: "movie"}) async {
    var uri = Uri.https(
      baseUrl,
      '3/genre/$type/list',
      <String, String>{'api_key': TMDB_API_KEY, 'language': 'en-US'},
    );

    var response = await _getRequest(uri);
    MovieGenresList list = MovieGenresList.fromJson(json.decode(response));

    return list;
  }

  Future<String> _getRequest(Uri uri) async {
    var request = await _httpClient.getUrl(uri);
    var response = await request.close();
    return response.transform(utf8.decoder).join();
  }
}

TheMovieDBApi theMovieDBApi = TheMovieDBApi();
