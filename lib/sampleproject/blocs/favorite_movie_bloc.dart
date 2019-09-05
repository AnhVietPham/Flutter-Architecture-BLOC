import 'dart:async';

import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs/bloc_provider.dart';

class FavoriteMovieBloc implements BlocBase {
  final BehaviorSubject<bool> _isFavoriteController = BehaviorSubject<bool>();

  Stream<bool> get outIsFavorite => _isFavoriteController.stream;

  final StreamController<List<MovieCard>> _favoritesController =
      StreamController<List<MovieCard>>();

  Sink<List<MovieCard>> get inFavorites => _favoritesController.sink;

  FavoriteMovieBloc(MovieCard movieCard) {
    _favoritesController.stream
        .map((list) => list.any((MovieCard item) => item.id == movieCard.id))
        .listen((isFavorite) => _isFavoriteController.add(isFavorite));
  }

  @override
  void dispose() {
    _favoritesController.close();
    _isFavoriteController.close();
  }
}
