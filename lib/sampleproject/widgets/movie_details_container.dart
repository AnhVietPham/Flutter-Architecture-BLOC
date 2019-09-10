import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/favorite_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/movie_details_widget.dart';

class MovieDetailsContainer extends StatefulWidget {
  MovieDetailsContainer({
    Key key,
  }) : super(key: key);

  @override
  MovieDetailsContainerState createState() => MovieDetailsContainerState();
}

class MovieDetailsContainerState extends State<MovieDetailsContainer> {
  MovieCard _movieCard;

  set movieCard(MovieCard newMovieCard) {
    setState(() {
      _movieCard = newMovieCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_movieCard == null)
        ? Center(
            child: Text('Click on a movie to see the details...'),
          )
        : MovieDetailsWidget(
            movieCard: _movieCard,
            boxFit: BoxFit.contain,
            favoritesStream:
                BlocProvider.of<FavoriteBloc>(context).outFavorites,
          );
  }
}
