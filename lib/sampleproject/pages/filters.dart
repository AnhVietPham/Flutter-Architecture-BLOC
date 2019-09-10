import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/application_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/movie_catalog_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_filters.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_genre.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as prefix0;

class FiltersPage extends StatefulWidget {
  FiltersPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FiltersPageState();
  }
}

class FiltersPageState extends State<FiltersPage> {
  ApplicationBloc _appBloc;
  MovieCatalogBloc _movieBloc;
  double _minReleaseDate;
  double _maxReleaseDate;
  MovieGenre _movieGenre;
  List<MovieGenre> _genres;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit == false) {
      _appBloc = BlocProvider.of<ApplicationBloc>(context);
      _movieBloc = BlocProvider.of<MovieCatalogBloc>(context);

      _getFilterParameters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isInit == false
        ? Container()
        : Scaffold(
            appBar: AppBar(
              leading: Container(),
              title: Text('Filters'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Years:',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(
                            minWidth: 40.0,
                            maxWidth: 40.0,
                          ),
                          child: Text('${_minReleaseDate.toStringAsFixed(0)}'),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFFFF0000),
                              showValueIndicator: ShowValueIndicator.always,
                            ),
                            child: prefix0.RangeSlider(
                              min: 2000.0,
                              max: 2017.0,
                              lowerValue: _minReleaseDate,
                              upperValue: _maxReleaseDate,
                              divisions: 18,
                              showValueIndicator: true,
                              valueIndicatorMaxDecimals: 0,
                              onChanged: (double lower, double upper) {
                                setState(() {
                                  _minReleaseDate = lower;
                                  _maxReleaseDate = upper;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minWidth: 40.0,
                            maxWidth: 40.0,
                          ),
                          child: Text('${_maxReleaseDate.toStringAsFixed(0)}'),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Genre:'),
                      SizedBox(width: 24.0),
                      DropdownButton<MovieGenre>(
                          items: _genres.map((MovieGenre movieGenre) {
                            return DropdownMenuItem<MovieGenre>(
                              value: movieGenre,
                              child: new Text(movieGenre.next),
                            );
                          }).toList(),
                          value: _movieGenre,
                          onChanged: (MovieGenre newMovieGenre) {
                            _movieGenre = newMovieGenre;
                            setState(() {});
                          }),
                    ],
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                _movieBloc.inFilters.add(MovieFilters(
                  minReleaseDate: _minReleaseDate.round(),
                  maxReleaseDate: _maxReleaseDate.round(),
                  genre: _movieGenre.genre,
                ));
                Navigator.of(context).pop();
              },
            ),
          );
  }

  void _getFilterParameters() {
    StreamSubscription subscriptionMovieGenres;
    StreamSubscription subscriptionFilters;

    subscriptionMovieGenres =
        _appBloc.outMovieGenres.listen((List<MovieGenre> data) {
      _genres = data;

      subscriptionFilters =
          _movieBloc.outFilters.listen((MovieFilters filters) {
        _minReleaseDate = filters.minReleaseDate.toDouble();
        _maxReleaseDate = filters.maxReleaseDate.toDouble();
        _movieGenre = _genres.firstWhere((g) => g.genre == filters.genre);

        // Simply to make sure the subscriptions are released
        subscriptionMovieGenres.cancel();
        subscriptionFilters.cancel();

        // Now that we have all parameters, we may build the actual page
        if (mounted) {
          setState(() {
            _isInit = true;
          });
        }
      });
    });

    // Send a request to get the list of the movie genres via stream
    _appBloc.getMovieGenres.add(null);
  }
}
