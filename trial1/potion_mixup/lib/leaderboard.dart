import 'package:flutter/material.dart';
import 'main.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      drawer: const MainDrawer(),
      body: const Center(child: Text('Leaderboard Page Placeholder')),
    );
  }
}
