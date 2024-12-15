import 'package:flutter/material.dart';
import 'main.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      drawer: MainDrawer(),
      body: Center(child: Text('Leaderboard Page Placeholder')),
    );
  }
}
