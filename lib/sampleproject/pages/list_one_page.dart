import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/favorite_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/movie_catalog_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';
import 'package:flutter_architecture_bloc/sampleproject/pages/filters.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/favorite_button.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/filters_summary.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/movie_card_widget.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/movie_details_container.dart';

class ListOnePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<MovieDetailsContainerState> _movieDetailsKey =
      new GlobalKey<MovieDetailsContainerState>();

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieBloc =
        BlocProvider.of<MovieCatalogBloc>(context);
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('List One Page'),
        actions: <Widget>[
          FavoriteButton(
            child: const Icon(Icons.favorite),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FiltersSummary(),
          Container(
            height: 150.0,
            child: StreamBuilder<List<MovieCard>>(
              stream: movieBloc.outMoviesList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MovieCard>> snapshot) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildMovieCard(movieBloc, index, snapshot.data,
                        favoriteBloc.outFavorites);
                  },
                  itemCount:
                      (snapshot.data == null ? 0 : snapshot.data.length) + 30,
                );
              },
            ),
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: MovieDetailsContainer(
                key: _movieDetailsKey,
              ),
            ),
          )
        ],
      ),
      endDrawer: FiltersPage(),
    );
  }

  Widget _buildMovieCard(MovieCatalogBloc movieBloc, int index,
      List<MovieCard> movieCards, Stream<List<MovieCard>> favoritesStream) {
    movieBloc.inMovieIndex.add(index);

    final MovieCard movieCard =
        (movieCards != null && movieCards.length > index)
            ? movieCards[index]
            : null;

    if (movieCard == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Otherwise, display the movie card
    return SizedBox(
      width: 150.0,
      child: MovieCardWidget(
        key: Key('movie_${movieCard.id}'),
        movieCard: movieCard,
        favoritesStream: favoritesStream,
        noHero: true,
        onPressed: () {
          _movieDetailsKey.currentState.movieCard = movieCard;
        },
      ),
    );
  }
}
