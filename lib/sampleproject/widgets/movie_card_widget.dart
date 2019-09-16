import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/api/themovie_db_api.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/favorite_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/favorite_movie_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';

class MovieCardWidget extends StatefulWidget {
  MovieCardWidget({
    Key key,
    @required this.movieCard,
    @required this.favoritesStream,
    @required this.onPressed,
    this.noHero: false,
  }) : super(key: key);

  final MovieCard movieCard;
  final VoidCallback onPressed;
  final Stream<List<MovieCard>> favoritesStream;
  final bool noHero;

  @override
  MovieCardWidgetState createState() => MovieCardWidgetState();
}

class MovieCardWidgetState extends State<MovieCardWidget> {
  FavoriteMovieBloc _bloc;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _createBloc();
  }

  @override
  void didUpdateWidget(MovieCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  void _createBloc() {
    _bloc = FavoriteMovieBloc(widget.movieCard);
    _subscription = widget.favoritesStream.listen(_bloc.inFavorites.add);
  }

  void _disposeBloc() {
    _subscription.cancel();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context);
    List<Widget> children = <Widget>[
      ClipRect(
        clipper: _SquareClipper(),
        child: widget.noHero
            ? Image.network(
                theMovieDBApi.imageBaseUrl + widget.movieCard.posterPath,
                fit: BoxFit.cover)
            : Hero(
                child: Image.network(
                    theMovieDBApi.imageBaseUrl + widget.movieCard.posterPath,
                    fit: BoxFit.cover),
                tag: 'movie_${widget.movieCard.id}',
              ),
      ),
      Container(
        decoration: _buildGradientBackground(),
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: _buildTextualInfo(widget.movieCard),
      ),
    ];
    children.add(
      StreamBuilder<bool>(
          stream: _bloc.outIsFavorite,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return Positioned(
                top: 0.0,
                right: 0.0,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onTap: () {
                        bloc.inRemoveFavorite.add(widget.movieCard);
                      },
                    )),
              );
            }
            return Container();
          }),
    );
    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: children,
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: <double>[0.0, 0.7, 0.7],
        colors: <Color>[
          Colors.black,
          Colors.transparent,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _buildTextualInfo(MovieCard movieCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          movieCard.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          movieCard.voteAverage.toString(),
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _SquareClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
