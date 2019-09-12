import 'package:flutter/material.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/bloc_provider.dart';
import 'package:flutter_architecture_bloc/sampleproject/blocs/movie_catalog_bloc.dart';
import 'package:flutter_architecture_bloc/sampleproject/pages/list.dart';
import 'package:flutter_architecture_bloc/sampleproject/pages/list_one_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Movies')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Movies List'),
              onPressed: () {
                _openPage(context);
              },
            ),
            RaisedButton(
              child: Text('One Page'),
              onPressed: () {
                _openOnePage(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _openPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListPage(),
      );
    }));
  }

  void _openOnePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListOnePage(),
      );
    }));
  }
}
