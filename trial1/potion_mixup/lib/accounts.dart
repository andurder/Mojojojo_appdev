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
          await _firestore.collection('scores').doc(user.uid).get();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome, $username!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (userScores != null) ...[
              Text('Easy Score: ${userScores!['EasyScore']}'),
              Text('Medium Score: ${userScores!['MediumScore']}'),
              Text('Hard Score: ${userScores!['HardScore']}'),
            ],
            const Spacer(),
            Text(
              'Potion Mixup v1.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
