import '../models/movie_genre.dart';

class MovieGenresList {
  List<MovieGenre> genres = <MovieGenre>[];

  MovieGenresList.fromJson(Map<String, dynamic> json)
      : genres = (json["genres"] as List<dynamic>)
            .map((item) => MovieGenre.fromJson(item))
            .toList();

  MovieGenre findById(int genre) => genres.firstWhere((item) => item.genre == genre);
}
