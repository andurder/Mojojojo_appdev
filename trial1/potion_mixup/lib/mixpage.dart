import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'game.dart';
import 'main.dart';

class LetsMixPage extends StatelessWidget {
  final String? uid;

  const LetsMixPage({super.key, this.uid});

  @override
  Widget build(BuildContext context) {
    // Fallback to the current user's UID if not provided
    final String currentUid =
        uid ?? FirebaseAuth.instance.currentUser?.uid ?? 'Unknown User';

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
                '• "Green Potion": Correct ingredient and position.',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '• "Yellow Potion": Correct ingredient but wrong position.',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '• "Empty Flasks": Wrong ingredient and wrong position.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DifficultySelectionPage(uid: currentUid),
                      ),
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
  final String uid;

  const DifficultySelectionPage({super.key, required this.uid});

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
                    builder: (context) =>
                        GamePage(difficulty: 'Easy', uid: uid),
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
                    builder: (context) =>
                        GamePage(difficulty: 'Medium', uid: uid),
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
                    builder: (context) =>
                        GamePage(difficulty: 'Hard', uid: uid),
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
