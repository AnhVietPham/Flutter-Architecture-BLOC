import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/favorite_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/models/movie_card.dart';
import 'package:flutter_architecture_bloc/sampleproject/widgets/favorite_widget.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Page'),
      ),
      body: StreamBuilder(
        stream: favoriteBloc.outFavorites,
        builder:
            (BuildContext context, AsyncSnapshot<List<MovieCard>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return FavoriteWidget(
                    data: snapshot.data[index],
                  );
                });
          }
          return Container();
        },
      ),
    );
  }
}
