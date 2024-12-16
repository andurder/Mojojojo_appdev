import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class LetsMixPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Let\'s Mix!')),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        // Fix for bottom overflow
        child: Padding(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage()),
                    );
                  },
                  child: Text('Start Brewing!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random _random = Random();
  List<int> secretCode = [];
  List<int> currentGuess = [];
  List<String> guessHistory = [];
  int maxIngredients = 6; // Adjusts based on difficulty
  String feedback = "";
  String selectedDifficulty = "Medium"; // Default difficulty

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
      guessHistory.add("Guess: ${currentGuess.join(", ")} | $feedback");
      currentGuess.clear();
    });
  }

  void setDifficulty(String difficulty) {
    setState(() {
      selectedDifficulty = difficulty;
      switch (difficulty) {
        case "Easy":
          maxIngredients = 3;
          break;
        case "Medium":
          maxIngredients = 4;
          break;
        case "Hard":
          maxIngredients = 6;
          break;
      }
      currentGuess.clear();
      feedback = "";
      guessHistory.clear();
      generateSecretCode(maxIngredients);
    });
  }

  @override
  void initState() {
    super.initState();
    setDifficulty("Medium"); // Initialize with Medium difficulty
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Potion Mix-Up Game')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Difficulty: $selectedDifficulty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedDifficulty,
              items: ["Easy", "Medium", "Hard"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setDifficulty(newValue);
                }
              },
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
                    child: Column(
                      children: [
                        Icon(Icons.science), // Placeholder icon
                        Text('${index + 1}')
                      ],
                    ),
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
                } else {
                  setState(() {
                    feedback =
                        "Incomplete guess. Please enter ${secretCode.length} numbers.";
                  });
                }
              },
              child: Text('Submit Guess'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentGuess.clear();
                  generateSecretCode(
                      maxIngredients); // Regenerate the secret code
                  feedback = "";
                  guessHistory.clear();
                });
              },
              child: Text('Reset Game'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: guessHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(guessHistory[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
