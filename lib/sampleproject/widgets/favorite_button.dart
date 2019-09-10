import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/favorite_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/pages/favorites.dart';

class FavoriteButton extends StatelessWidget {
  FavoriteButton({
    Key key,
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    return RaisedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return FavoritesPage();
        }));
      },
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          child,
          Positioned(
            top: -12.0,
            right: -6.0,
            child: Material(
              type: MaterialType.circle,
              elevation: 2.0,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: StreamBuilder<int>(
                  stream: favoriteBloc.outTotalFavorite,
                  initialData: 0,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
