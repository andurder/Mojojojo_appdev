import 'package:flutter/material.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const MainDrawer(),
      body: const Center(child: Text('Home Page Placeholder')),
    );
  }
}
