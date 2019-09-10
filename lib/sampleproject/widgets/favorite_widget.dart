import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/api/themovie_db_api.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/favorite_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';

class FavoriteWidget extends StatelessWidget {
  FavoriteWidget({
    Key key,
    @required this.data,
  }) : super(key: key);
  final MovieCard data;

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black54))),
      child: ListTile(
        leading: Container(
          width: 100.0,
          height: 100.0,
          child: Image.network(
            theMovieDBApi.imageBaseUrl + data.posterPath,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(data.title),
        subtitle: Text(
          data.overview,
          style: TextStyle(fontSize: 10.0),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            favoriteBloc.inRemoveFavorite.add(data);
          },
        ),
      ),
    );
  }
}
