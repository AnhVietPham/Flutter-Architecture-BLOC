import 'dart:async';
import 'dart:collection';

import '../api/themovie_db_api.dart';
import '../blocs/bloc_provider.dart';
import '../models/movie_genre.dart';
import '../models/movie_genre_list.dart';

class ApplicationBloc implements BlocBase {
  MovieGenresList _movieGenresList;

  StreamController<List<MovieGenre>> _syncController =
      StreamController<List<MovieGenre>>.broadcast();

  Stream<List<MovieGenre>> get outMovieGenres => _syncController.stream;

  StreamController<List<MovieGenre>> _cmdController =
      StreamController<List<MovieGenre>>.broadcast();

  StreamSink get getMovieGenres => _cmdController.sink;

  ApplicationBloc() {
    theMovieDBApi.getMovieGenres().then((list) {
      _movieGenresList = list;
    });

    _cmdController.stream.listen((_) {
      _syncController.sink
          .add(UnmodifiableListView<MovieGenre>(_movieGenresList.genres));
    });
  }

  @override
  void dispose() {
    _syncController.close();
    _cmdController.close();
  }
}
