import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';

class LeaderboardEntry {
  final String userName;
  final int easyScore;
  final int mediumScore;
  final int hardScore;

  LeaderboardEntry({
    required this.userName,
    required this.easyScore,
    required this.mediumScore,
    required this.hardScore,
  });

  factory LeaderboardEntry.fromFirestore(Map<String, dynamic> data) {
    return LeaderboardEntry(
      userName: data['UserName'] ?? '',
      easyScore: data['EasyScore'] ?? 0,
      mediumScore: data['MediumScore'] ?? 0,
      hardScore: data['HardScore'] ?? 0,
    );
  }
}

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<LeaderboardEntry>> getLeaderboard(String difficulty) {
    final difficultyField = difficulty[0].toUpperCase() +
        difficulty.substring(1) +
        'Score'; // Capitalize difficulty and add "Score"
    return _firestore
        .collection('Scores') // Updated collection name
        .orderBy(difficultyField,
            descending: true) // Sort by the selected difficulty field
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaderboardEntry.fromFirestore(
                doc.data() as Map<String, dynamic>))
            .toList());
  }
}

class LeaderboardsPage extends StatefulWidget {
  @override
  _LeaderboardsPageState createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  String selectedDifficulty = 'Easy'; // Default difficulty

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        actions: [
          // Dropdown for difficulty selection
          DropdownButton<String>(
            value: selectedDifficulty,
            icon: Icon(Icons.arrow_downward),
            onChanged: (String? newValue) {
              setState(() {
                selectedDifficulty = newValue!;
              });
            },
            items: <String>['Easy', 'Medium', 'Hard']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: StreamBuilder<List<LeaderboardEntry>>(
        stream: LeaderboardService()
            .getLeaderboard(selectedDifficulty.toLowerCase()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final leaderboard = snapshot.data!;
          if (leaderboard.isEmpty) {
            return Center(child: Text('No scores available.'));
          }
          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final entry = leaderboard[index];
              final score = selectedDifficulty.toLowerCase() == 'easy'
                  ? entry.easyScore
                  : selectedDifficulty.toLowerCase() == 'medium'
                      ? entry.mediumScore
                      : entry.hardScore;

              if (index == 0) {
                // Top scorer
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[100], // Highlight color
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Shadow effect
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50, // Larger avatar
                          child: Text(
                            '1',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 12.0), // Space between avatar and text
                        Text(
                          entry.userName,
                          style: TextStyle(
                            fontSize: 24, // Larger font size for top scorer
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Score: $score',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 12.0), // Space after the score
                      ],
                    ),
                  ),
                );
              }

              // For other entries
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(entry.userName),
                    subtitle: Text('Score: $score'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
