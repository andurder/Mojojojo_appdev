import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this for persistent storage
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
                      MaterialPageRoute(
                          builder: (context) =>
                              const DifficultySelectionPage()),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GamePage(difficulty: 'Easy'),
                  ),
                );
              },
              child: const Text('Easy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GamePage(difficulty: 'Medium'),
                  ),
                );
              },
              child: const Text('Medium'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GamePage(difficulty: 'Hard'),
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
  int score = 0; // Cumulative score
  int roundScore = 1000; // Base score for the round
  int penalty = 50; // Points lost per guess
  int highScore = 0; // Persistent high score
  List<Widget> feedbackImages = [];

  void generateSecretCode(int length) {
    List<int> symbols = List.generate(maxIngredients, (index) => index + 1);
    symbols.shuffle(_random);
    secretCode = symbols.sublist(0, length);
  }

  Future<void> loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore_${widget.difficulty}') ?? 0;
    });
  }

  Future<void> updateHighScore() async {
    if (score > highScore) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        highScore = score;
        prefs.setInt('highScore_${widget.difficulty}', highScore);
      });
    }
  }

  void checkGuess() {
    int potionBottles = 0; // Correct ingredient and position
    int emptyFlasks = 0; // Correct ingredient, wrong position

    feedbackImages.clear();

    for (int i = 0; i < currentGuess.length; i++) {
      if (currentGuess[i] == secretCode[i]) {
        potionBottles++;
        feedbackImages.add(
            Image.asset('assets/icons/correct.png', width: 60, height: 60));
      } else if (secretCode.contains(currentGuess[i])) {
        emptyFlasks++;
        feedbackImages
            .add(Image.asset('assets/icons/empty.png', width: 60, height: 60));
      }
    }

    setState(() {
      if (potionBottles == secretCode.length) {
        feedback = "You Won! Final Score: $score";
        updateHighScore(); // Check and update high score if necessary
      } else {
        feedback = "Potion Bottles: $potionBottles, Empty Flasks: $emptyFlasks";
        roundScore -= penalty; // Deduct penalty for incorrect guesses
        if (roundScore < 0) roundScore = 0; // Ensure no negative score
      }
      guessHistory.add("Guess: ${currentGuess.join("")} | $feedback");
      currentGuess.clear();
    });
  }

  void setDifficulty() {
    switch (widget.difficulty) {
      case "Easy":
        maxIngredients = 3;
        penalty = 20;
        roundScore = 1000;
        break;
      case "Medium":
        maxIngredients = 4;
        penalty = 50;
        roundScore = 1000;
        break;
      case "Hard":
        maxIngredients = 6;
        penalty = 100;
        roundScore = 1500;
        break;
    }
    generateSecretCode(maxIngredients);
  }

  @override
  void initState() {
    super.initState();
    loadHighScore();
    setDifficulty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Potion Mix-Up: ${widget.difficulty}')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/woodbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Score: $score',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text('High Score: $highScore',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              // Current guess display
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: currentGuess.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.purple[200],
                        child: Text(
                          '$e',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Game history
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListView.builder(
                    itemCount: guessHistory.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color:
                            index % 2 == 0 ? Colors.purple[50] : Colors.white,
                        child: ListTile(
                          title: Text(
                            guessHistory[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Feedback images
              SizedBox(
                height: 60,
                child: Wrap(
                  spacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: feedbackImages.map((image) => image).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Ingredient buttons
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
              ElevatedButton(
                onPressed: () {
                  if (currentGuess.length == secretCode.length) {
                    setState(() {
                      score += roundScore; // Add round score to total score
                      checkGuess();
                    });
                  } else {
                    setState(() {
                      feedback =
                          "Please enter ${secretCode.length} ingredients.";
                    });
                  }
                },
                child: const Text('Submit Guess'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentGuess.clear();
                    guessHistory.clear();
                    feedback = "";
                    feedbackImages.clear();
                    setDifficulty();
                  });
                },
                child: const Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
