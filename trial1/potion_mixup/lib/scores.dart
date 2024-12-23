import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class MyScoresPage extends StatelessWidget {
  const MyScoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Scores'),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No scores available'));
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;

            // Retrieve scores from Firestore and convert to int
            final int easyScore =
                int.tryParse(userData['eScore'].toString()) ?? 0;
            final int mediumScore =
                int.tryParse(userData['mScore'].toString()) ?? 0;
            final int hardScore =
                int.tryParse(userData['hScore'].toString()) ?? 0;

            return Column(
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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.star, color: Colors.orange),
                  title: const Text('Medium'),
                  trailing: Text(
                    mediumScore.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.star, color: Colors.red),
                  title: const Text('Hard'),
                  trailing: Text(
                    hardScore.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
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
            );
          },
        ),
      ),
    );
  }
}
