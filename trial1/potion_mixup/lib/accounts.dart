import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String username = 'Player'; // Default username
  Map<String, dynamic>? userScores;

  @override
  void initState() {
    super.initState();
    _getUserScores();
  }

  Future<void> _getUserScores() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Fetch the user's scores from Firestore
      DocumentSnapshot scoresSnapshot =
          await _firestore.collection('Users').doc(user.uid).get();

      setState(() {
        userScores = scoresSnapshot.data() as Map<String, dynamic>?;
        username = user.email?.split('@')[0] ??
            'Player'; // Use email prefix as username
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: Container(
        color: Colors.grey[200], // Soft background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome, $username!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (userScores != null) ...[
              _buildScoreCard('Easy Score', userScores!['eScore']),
              const SizedBox(height: 16),
              _buildScoreCard('Medium Score', userScores!['mScore']),
              const SizedBox(height: 16),
              _buildScoreCard('Hard Score', userScores!['hScore']),
            ] else ...[
              const CircularProgressIndicator(), // Loading indicator while fetching scores
            ],
            const Spacer(),
            const Text(
              'Potion Mixup v1.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String title, int? score) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber[600]), // Icon for scores
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              score != null ? score.toString() : 'N/A',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
