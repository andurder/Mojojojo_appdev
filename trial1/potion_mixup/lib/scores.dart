import 'package:flutter/material.dart';
import 'main.dart';

class MyScoresPage extends StatelessWidget {
  const MyScoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Scores')),
      drawer: const MainDrawer(),
      body: const Center(child: Text('My Scores Page Placeholder')),
    );
  }
}
