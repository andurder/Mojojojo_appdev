import 'package:flutter/material.dart';
import 'main.dart';

class MyScoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Scores')),
      drawer: MainDrawer(),
      body: Center(child: Text('My Scores Page Placeholder')),
    );
  }
}
