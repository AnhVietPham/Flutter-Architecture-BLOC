import 'dart:async';
import 'dart:collection';

import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_filters.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_page_result.dart';
import 'package:rxdart/rxdart.dart';

import '../api/themovie_db_api.dart';

class MovieCatalogBloc implements BlocBase {
  final int _moviesPerPage = 20;
  int _genre = 28;
  int _minReleaseDate = 2000;
  int _maxReleaseDate = 2005;
  int _totalMovies = -1;

  final _fetchPages = <int, MoviePageResult>{};
  final _pagesBeingFetched = Set<int>();

  PublishSubject<List<MovieCard>> _moviesController =
      PublishSubject<List<MovieCard>>();

  Sink<List<MovieCard>> get _inMoviesList => _moviesController.sink;

  Stream<List<MovieCard>> get outMoviesList => _moviesController.stream;

  PublishSubject<int> _indexController = PublishSubject<int>();

  Sink<int> get inMovieIndex => _indexController.sink;

  BehaviorSubject<int> _totalMoviesController =
      BehaviorSubject<int>(seedValue: 0);
  BehaviorSubject<List<int>> _releaseDatesController =
      BehaviorSubject<List<int>>(seedValue: <int>[2000, 2005]);
  BehaviorSubject<int> _genreController = BehaviorSubject<int>(seedValue: 28);

  Sink<int> get _inTotalMovies => _totalMoviesController.sink;

  Stream<int> get outTotalMovies => _totalMoviesController.stream;

  Sink<List<int>> get _inReleaseDates => _releaseDatesController.sink;

  Stream<List<int>> get outReleaseDates => _releaseDatesController.stream;

  Sink<int> get _inGenre => _genreController.sink;

  Stream<int> get outGenre => _genreController.stream;

  BehaviorSubject<MovieFilters> _filtersController =
      BehaviorSubject<MovieFilters>(
          seedValue: MovieFilters(
              genre: 28, minReleaseDate: 2000, maxReleaseDate: 2005));

  Sink<MovieFilters> get inFilters => _filtersController.sink;

  Stream<MovieFilters> get outFilters => _filtersController.stream;

  MovieCatalogBloc() {
    _indexController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .listen(_handleIndexes);
  }

  void dispose() {
    _moviesController.close();
    _indexController.close();
    _totalMoviesController.close();
    _releaseDatesController.close();
    _genreController.close();
    _filtersController.close();
  }

  void _handleIndexes(List<int> indexes) {
    indexes.forEach((int index) {
      final int pageIndex = 1 + ((index + 1) ~/ _moviesPerPage);

      if (!_fetchPages.containsKey(pageIndex)) {
        if (!_pagesBeingFetched.contains(pageIndex)) {
          _pagesBeingFetched.add(pageIndex);
          theMovieDBApi
              .pagedList(
                  pageIndex: pageIndex,
                  genre: _genre,
                  minYear: _minReleaseDate,
                  maxYear: _maxReleaseDate)
              .then((MoviePageResult fetchedPage) =>
                  _handleFetchedPage(fetchedPage, pageIndex));
        }
      }
    });
  }

  void _handleFetchedPage(MoviePageResult page, int pageIndex) {
    _fetchPages[pageIndex] = page;
    _pagesBeingFetched.remove(pageIndex);

    List<MovieCard> movies = <MovieCard>[];
    List<int> pageIndexes = _fetchPages.keys.toList();
    pageIndexes.sort((a, b) => a.compareTo(b));

    final int minPageIndex = pageIndexes[0];
    final int maxPageIndex = pageIndexes[pageIndexes.length - 1];

    if (minPageIndex == 1) {
      for (int i = 1; i <= maxPageIndex; i++) {
        if (!_fetchPages.containsKey(i)) {
          break;
        }
        movies.addAll(_fetchPages[i].movies);
      }
    }

    if (_totalMovies == -1) {
      _totalMovies = page.totalResults;
      _inTotalMovies.add(_totalMovies);
    }

    if (movies.length > 0) {
      _inMoviesList.add(UnmodifiableListView<MovieCard>(movies));
    }
  }

  void _handleFilters(MovieFilters result) {
    _minReleaseDate = result.minReleaseDate;
    _maxReleaseDate = result.maxReleaseDate;
    _genre = result.genre;

    _totalMovies = -1;
    _fetchPages.clear();
    _pagesBeingFetched.clear();

    _inGenre.add(_genre);
    _inReleaseDates.add(<int>[_minReleaseDate, _maxReleaseDate]);
    _inTotalMovies.add(0);

    _inMoviesList.add(<MovieCard>[]);
  }
}
