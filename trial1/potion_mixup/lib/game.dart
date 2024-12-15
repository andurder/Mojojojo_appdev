import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class LetsMixPage extends StatefulWidget {
  @override
  _LetsMixPageState createState() => _LetsMixPageState();
}

class _LetsMixPageState extends State<LetsMixPage> {
  final Random _random = Random();
  final int maxAttempts = 72;
  List<int> secretCode = [];
  List<int> currentGuess = [];
  int maxIngredients = 6; // Adjusts based on difficulty
  String feedback = "";

  void generateSecretCode(int length) {
    List<int> symbols = List.generate(maxIngredients, (index) => index + 1);
    symbols.shuffle(_random);
    secretCode = symbols.sublist(0, length);
  }

  void checkGuess() {
    int potionBottles = 0; // Correct ingredient and position
    int emptyFlasks = 0; // Correct ingredient, wrong position

    for (int i = 0; i < currentGuess.length; i++) {
      if (currentGuess[i] == secretCode[i]) {
        potionBottles++;
      } else if (secretCode.contains(currentGuess[i])) {
        emptyFlasks++;
      }
    }

    setState(() {
      feedback = "Potion Bottles: $potionBottles, Empty Flasks: $emptyFlasks";
    });
  }

  @override
  void initState() {
    super.initState();
    generateSecretCode(4); // Default to Medium difficulty
  }

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
              feedback,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(maxIngredients, (index) {
                return Padding(
                  padding: EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentGuess.length < secretCode.length) {
                        setState(() {
                          currentGuess.add(index + 1);
                        });
                      }
                    },
                    child: Text('${index + 1}'),
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            Text(
              'Your Guess: ${currentGuess.join(", ")}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (currentGuess.length == secretCode.length) {
                  checkGuess();
                  currentGuess.clear();
                }
              },
              child: Text('Submit Guess'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentGuess.clear();
                  generateSecretCode(4); // Regenerate the secret code
                  feedback = "";
                });
              },
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
