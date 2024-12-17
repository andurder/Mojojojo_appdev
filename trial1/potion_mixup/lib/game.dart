import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class LetsMixPage extends StatelessWidget {
  const LetsMixPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Let\'s Mix!')),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        // Fix for bottom overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Difficulty Levels:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Easy (3 ingredients): Suitable for beginners.',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '• Medium (4 ingredients): Standard challenge for most players.',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '• Hard (6 ingredients): A complex puzzle for experienced gamers.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Game Mechanics:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Each guess provides feedback through:',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '• "Potion Bottles": Correct ingredient and position.',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '• "Empty Flasks": Correct ingredient but wrong position.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GamePage()),
                    );
                  },
                  child: const Text('Start Brewing!'),
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
  final String difficulty;

  const GamePage({super.key, required this.difficulty});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random _random = Random();
  List<int> secretCode = [];
  List<int> currentGuess = [];
  List<String> guessHistory = [];
  int maxIngredients = 6;
  String feedback = "";
  int score = 1000; // Start with base score
  int penalty = 50; // Points lost per guess

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
      if (potionBottles == secretCode.length) {
        feedback = "You Won! Final Score: $score";
      } else {
        feedback = "Potion Bottles: $potionBottles, Empty Flasks: $emptyFlasks";
        score -= penalty; // Deduct penalty for each guess
      }
      guessHistory.add("Guess: ${currentGuess.join(", ")} | $feedback");
      currentGuess.clear();
    });
  }

  void setDifficulty() {
    switch (widget.difficulty) {
      case "Easy":
        maxIngredients = 3;
        break;
      case "Medium":
        maxIngredients = 4;
        break;
      case "Hard":
        maxIngredients = 6;
        score = 1500; // Higher starting score for Hard
        break;
    }
    generateSecretCode(maxIngredients);
  }

  @override
  void initState() {
    super.initState();
    setDifficulty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Potion Mix-Up: ${widget.difficulty}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Score: $score',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // History of Guesses
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: guessHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(guessHistory[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            Text(
              feedback,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 16),

            // Ingredient Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(maxIngredients, (index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
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
                        const Icon(Icons.science),
                        Text('${index + 1}')
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Submit Guess Button
            ElevatedButton(
              onPressed: () {
                if (currentGuess.length == secretCode.length) {
                  checkGuess();
                } else {
                  setState(() {
                    feedback = "Please enter ${secretCode.length} ingredients.";
                  });
                }
              },
              child: const Text('Submit Guess'),
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultySelectionPage extends StatelessWidget {
  const DifficultySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Difficulty')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Your Difficulty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(difficulty: 'Easy'),
                  ),
                );
              },
              child: const Text('Easy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(difficulty: 'Medium'),
                  ),
                );
              },
              child: const Text('Medium'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(difficulty: 'Hard'),
                  ),
                );
              },
              child: const Text('Hard'),
            ),
          ],
        ),
      ),
    );
  }
}
