import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LeaderboardsPage extends StatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  _LeaderboardsPageState createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  String _selectedDifficulty = 'easy'; // Default difficulty
  final List<String> _difficulties = ['easy', 'medium', 'hard'];

  // A mapping from the difficulty level to the respective Firestore field
  String getScoreField(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'eScore';
      case 'medium':
        return 'mScore';
      case 'hard':
        return 'hScore';
      default:
        return 'eScore'; // Default to easy if something goes wrong
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboards'),
        actions: [
          DropdownButton<String>(
            value: _selectedDifficulty,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDifficulty = newValue!.toLowerCase();
              });
            },
            items: _difficulties.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      drawer: const MainDrawer(), // Add the drawer here
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'images/lb.png', // Replace with your asset path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Column(
            children: [
              const SizedBox(
                height: 200, // Add space for the header or artwork if needed
                child: Center(
                  child: Text(
                    'Leaderboards',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .orderBy(getScoreField(_selectedDifficulty),
                          descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No scores available'));
                    }

                    final users = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final score = user[getScoreField(_selectedDifficulty)];
                        final isTopThree = index < 3;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isTopThree
                                ? (index == 0
                                    ? Colors.amber
                                    : (index == 1
                                        ? Colors.lightGreen
                                        : Colors.blueAccent))
                                : Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  user['username'],
                                  style: TextStyle(
                                    fontSize: isTopThree ? 24 : 16,
                                    fontWeight: isTopThree
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                score.toString(),
                                style:
                                    TextStyle(fontSize: isTopThree ? 24 : 16),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
