import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/favorite_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/movie_catalog_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';
import 'package:flutter_architecture_bloc/sampleproject/pages/details.dart';
import 'package:flutter_architecture_bloc/sampleproject/pages/filters.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/favorite_button.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/filters_summary.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/movie_card_widget.dart';

class ListPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieCatalogBloc =
        BlocProvider.of<MovieCatalogBloc>(context);
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('List Page'),
        actions: <Widget>[
          FavoriteButton(
            child: Icon(Icons.favorite),
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FiltersSummary(),
          Expanded(
            child: StreamBuilder<List<MovieCard>>(
              stream: movieCatalogBloc.outMoviesList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MovieCard>> snapshot) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildMovieCard(context, movieCatalogBloc, index,
                        snapshot.data, favoriteBloc.outFavorites);
                  },
                  itemCount:
                      (snapshot.data == null ? 0 : snapshot.data.length) + 30,
                );
              },
            ),
          )
        ],
      ),
      endDrawer: FiltersPage(),
    );
  }

  Widget _buildMovieCard(
      BuildContext context,
      MovieCatalogBloc movieCatalogBloc,
      int index,
      List<MovieCard> movieCards,
      Stream<List<MovieCard>> favoritesStream) {
    movieCatalogBloc.inMovieIndex.add(index);
    final MovieCard movieCard =
        (movieCards != null && movieCards.length > index)
            ? movieCards[index]
            : null;

    if (movieCard == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return MovieCardWidget(
        key: Key('movie_${movieCard.id}'),
        movieCard: movieCard,
        favoritesStream: favoritesStream,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return DetailsPage(
              data: movieCard,
            );
          }));
        });
  }
}
