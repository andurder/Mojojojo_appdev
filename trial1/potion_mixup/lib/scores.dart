import 'package:flutter/material.dart';
import 'main.dart';

class MyScoresPage extends StatelessWidget {
  const MyScoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder Data for Highscores
    const int easyScore = 1500;
    const int mediumScore = 1200;
    const int hardScore = 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Scores'),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Your Highscores',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Difficulty Scores
            ListTile(
              leading: const Icon(Icons.star, color: Colors.green),
              title: const Text('Easy'),
              trailing: Text(
                easyScore.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.orange),
              title: const Text('Medium'),
              trailing: Text(
                mediumScore.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.red),
              title: const Text('Hard'),
              trailing: Text(
                hardScore.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            // Spacer for clean UI
            const Spacer(),
            const Center(
              child: Text(
                'Potion Mixup v1.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
