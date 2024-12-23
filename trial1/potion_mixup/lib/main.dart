import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'leaderboard.dart';
import 'scores.dart';
import 'login.dart';
import 'homepage.dart';
import 'game.dart';
import 'accounts.dart';
import 'aboutus.dart';
import 'mixpage.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PotionMixupApp());
}

class PotionMixupApp extends StatelessWidget {
  const PotionMixupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Potion Mixup',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SplashScreen(), // Initial screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration of one full rotation
      vsync: this,
    )..repeat(); // Repeat the animation

    // Navigate to the LandingPage after 5 seconds
    Timer(const Duration(seconds: 5), () {
      _controller.dispose(); // Dispose of the controller
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use RotationTransition for spinning effect
            RotationTransition(
              turns: _controller,
              child: Image.asset('icons/potionmixuop.png',
                  height: 150), // Placeholder for logo
            ),
            const SizedBox(height: 20),
            const Text('Potion Mixup',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Welcome to Potion Mixup!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.deepPurple[800],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.deepPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'icons/potionmixuop.png', // Replace with your potion icon path
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '🧙‍♀️ Become a Master Alchemist 🧙‍♂️\n'
                    'Concoct the winning elixir in Potion Mix-Up! This captivating game, inspired by the classic Bulls and Cows, challenges you to decipher the secret recipe by guessing the correct combination of magical ingredients.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700], // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? username;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      setState(() {
        username =
            doc.data()?['username'] ?? user.displayName ?? 'Unknown User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 60,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Potion Mixup',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          UserAccountsDrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 39, 73, 50)),
            accountName: Text(
              username ?? 'Loading...',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              user?.email ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.science),
            title: const Text('Let\'s Mix!'),
            onTap: () {
              final User? user = _auth.currentUser;
              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LetsMixPage(uid: user.uid),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Leaderboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LeaderboardsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.score),
            title: const Text('My Scores'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyScoresPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Aboutus()),
              );
            },
          ),
          const Divider(), // Optional divider for aesthetics
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              await _auth.signOut(); // Sign out the user
              setState(() {}); // Update the UI to reflect logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LandingPage()),
              ); // Redirect to Landing Page
            },
          ),
        ],
      ),
    );
  }
}
