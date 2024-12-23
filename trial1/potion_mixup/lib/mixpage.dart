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
      body: Container(
        color: const Color.fromARGB(255, 188, 119,
            209), // Change to your preferred light background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Game Mechanics'),
              _buildContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Each guess provides feedback through:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '• "Green Potion": Correct ingredient and position.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '• "Empty Flasks": Correct ingredient but wrong position.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Difficulty Levels'),
              _buildContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
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
                  ],
                ),
              ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87, // Use a readable color
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple.shade50, // Soft purple background for containers
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: child,
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
      body: Container(
        color: const Color.fromARGB(255, 188, 119,
            209), // Change to your preferred light background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose Your Difficulty',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Use a readable color
                ),
              ),
              const SizedBox(height: 20),
              _buildDifficultyButton(context, 'Easy'),
              _buildDifficultyButton(context, 'Medium'),
              _buildDifficultyButton(context, 'Hard'),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildDifficultyButton(
      BuildContext context, String difficulty) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GamePage(difficulty: difficulty, uid: uid),
          ),
        );
      },
      child: Text(difficulty),
    );
  }
}
