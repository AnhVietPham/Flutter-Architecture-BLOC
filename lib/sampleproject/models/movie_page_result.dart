import 'package:flutter_architecture_bloc/sampleproject/models/base_model.dart';

import '../models/movie_card.dart';

class MoviePageResult {
  final int pageIndex;
  final int totalResults;
  final int totalPages;
  final List<MovieCard> movies;

  MoviePageResult.fromJson(Map<String, dynamic> json)
      : pageIndex = BaseModel.parseInt('page', json),
        totalResults = BaseModel.parseInt('total_results', json),
        totalPages = BaseModel.parseInt('total_pages', json),
        movies = (json['results'] as List)
            .map((item) => MovieCard.fromJson(item))
            .toList();
}
