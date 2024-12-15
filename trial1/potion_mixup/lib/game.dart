import 'package:flutter/material.dart';
import 'main.dart';

class LetsMixPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Let\'s Mix!')),
      drawer: MainDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Potion Mix-Up: The Alchemist\'s Challenge',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Potion Mix-Up is an engaging guessing game inspired by the classic Bulls and Cows concept. Players take on the role of an alchemist, trying to brew the perfect potion by guessing the correct combination of magical ingredients from a selection of six options.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Difficulty Levels:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Easy (3 ingredients): Suitable for beginners.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '• Medium (4 ingredients): Standard challenge for most players.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '• Hard (6 ingredients): A complex puzzle for experienced gamers.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Game Mechanics:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Each guess provides feedback through:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '• "Potion Bottles": Correct ingredient and position.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '• "Empty Flasks": Correct ingredient but wrong position.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to game setup page (to be implemented)
                },
                child: Text('Start Brewing!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
