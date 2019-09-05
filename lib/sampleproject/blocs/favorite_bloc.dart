import 'dart:collection';

import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteBloc implements BlocBase {
  final Set<MovieCard> _favorites = Set<MovieCard>();

  BehaviorSubject<MovieCard> _favoriteAddController =
      BehaviorSubject<MovieCard>();

  Sink<MovieCard> get inAddFavorite => _favoriteAddController.sink;

  BehaviorSubject<MovieCard> _favoriteRemoveController =
      BehaviorSubject<MovieCard>();

  Sink<MovieCard> get inRemoveFavorite => _favoriteRemoveController.sink;

  BehaviorSubject<int> _favoriteTotalController =
      BehaviorSubject<int>(seedValue: 0);

  Sink<int> get _inTotalFavorites => _favoriteTotalController.sink;

  Stream<int> get outTotalFavorite => _favoriteTotalController.stream;

  BehaviorSubject<List<MovieCard>> _favoritesController =
      BehaviorSubject<List<MovieCard>>(seedValue: []);

  Sink<List<MovieCard>> get _inFavorites => _favoritesController.sink;

  Stream<List<MovieCard>> get outFavorites => _favoritesController.stream;

  FavoriteBloc() {
    _favoriteAddController.listen(_handleAddFavorite);
    _favoriteRemoveController.listen(_handleRemoveFavorite);
  }

  void dispose() {
    _favoriteAddController.close();
    _favoriteRemoveController.close();
    _favoriteTotalController.close();
    _favoritesController.close();
  }

  void _handleAddFavorite(MovieCard movieCard) {
    // Add the movie to the list of favorite ones
    _favorites.add(movieCard);

    _notify();
  }

  void _handleRemoveFavorite(MovieCard movieCard) {
    _favorites.remove(movieCard);

    _notify();
  }

  void _notify() {
    // Send to whomever is interested...
    // The total number of favorites
    _inTotalFavorites.add(_favorites.length);

    // The new list of all favorite movies
    _inFavorites.add(UnmodifiableListView(_favorites));
  }
}
