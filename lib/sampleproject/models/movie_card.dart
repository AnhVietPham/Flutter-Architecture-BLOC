import '../models/base_model.dart';

class MovieCard {
  final int id;
  final int voteAverage;
  final String title;
  final String posterPath;
  final String overview;

  MovieCard(
      this.id, this.voteAverage, this.title, this.posterPath, this.overview);

  MovieCard.fromJson(Map<String, dynamic> json)
      : id = BaseModel.parseInt('id', json),
        voteAverage = BaseModel.parseInt('vote_average', json),
        title = BaseModel.parseString('title', json),
        posterPath = BaseModel.parseString('poster_path', json),
        overview = BaseModel.parseString('overview', json);
}
