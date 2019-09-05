import 'package:flutter/material.dart';

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
//                _openPage(context);
              },
            ),
            RaisedButton(
              child: Text('One Page'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
