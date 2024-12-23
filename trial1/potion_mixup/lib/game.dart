import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'main.dart';

class GamePage extends StatefulWidget {
  final String difficulty;
  final String uid;

  const GamePage({super.key, required this.difficulty, required this.uid});

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
  int score = 0;
  int roundScore = 1000;
  int penalty = 50;
  int highScore = 0;
  List<Widget> feedbackImages = [];

  void generateSecretCode(int length) {
    List<int> symbols = List.generate(maxIngredients, (index) => index + 1);
    symbols.shuffle(_random);
    secretCode = symbols.sublist(0, length);
  }

  Future<void> loadHighScore() async {
    // Load high score from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .get();
    if (userDoc.exists) {
      setState(() {
        highScore = userDoc.data()![getScoreField(widget.difficulty)] ?? 0;
      });
    }
  }

  Future<void> updateHighScore() async {
    if (score > highScore) {
      setState(() {
        highScore = score;
      });

      // Update high score in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .update({
        getScoreField(widget.difficulty): highScore,
      });
    }
  }

  String getScoreField(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 'eScore';
      case 'Medium':
        return 'mScore';
      case 'Hard':
        return 'hScore';
      default:
        return 'eScore'; // Default to easy if something goes wrong
    }
  }

  void checkGuess() {
    int potionBottles = 0; // Correct ingredient and position
    int emptyFlasks = 0; // Correct ingredient, wrong position

    feedbackImages.clear();

    for (int i = 0; i < currentGuess.length; i++) {
      if (currentGuess[i] == secretCode[i]) {
        potionBottles++;
        feedbackImages.add(Image.asset('assets/icons/correct.png',
            width: 40, height: 40)); // Reduced size
      } else if (secretCode.contains(currentGuess[i])) {
        emptyFlasks++;
        feedbackImages.add(Image.asset('assets/icons/empty.png',
            width: 40, height: 40)); // Reduced size
      }
    }

    setState(() {
      if (potionBottles == secretCode.length) {
        feedback = "You Won! Final Score: $score";
        showWinPrompt();
      } else {
        roundScore -= penalty;
        if (roundScore < 0) roundScore = 0;
      }
      guessHistory.add("Guess:   ${currentGuess.join("  ")}");
      currentGuess.clear();
    });
  }

  Future<void> showWinPrompt() async {
    await updateHighScore();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You Won!'),
          content: Text('Your score: $score\nHigh score: $highScore'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(
                    context); // Navigate back to main menu or difficulty selection
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
              widget.difficulty == "Hard"
                  ? Column(
                      children: [
                        Wrap(
                          spacing: 8.0,
                          alignment: WrapAlignment.center,
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
                                child: Text('${index + 1}'),
                              ),
                            );
                          }),
                        ),
                      ],
                    )
                  : Row(
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
                            child: Text('${index + 1}'),
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
