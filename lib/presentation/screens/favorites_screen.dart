import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Favorites Screen',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
