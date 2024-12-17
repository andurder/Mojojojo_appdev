import 'package:flutter/material.dart';
import 'main.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder Data for Highscores and Username
    const String username = 'Player123';
    const int easyScore = 1500;
    const int mediumScore = 1200;
    const int hardScore = 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Username Section
            const SizedBox(height: 20),
            Text(
              'Welcome, $username!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Highscores Section
            const Text(
              'Highscores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
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

            // Spacer for aesthetics
            const Spacer(),
            const Text(
              'Potion Mixup v1.0',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
