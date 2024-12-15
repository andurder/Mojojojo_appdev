import 'package:flutter/material.dart';
import 'dart:async';
import 'leaderboard.dart';
import 'scores.dart';
import 'login.dart';
import 'homepage.dart';
import 'game.dart';
import 'accounts.dart';
import 'aboutus.dart';

//import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(); // Initialize Firebase
  runApp(PotionMixupApp());
}

class PotionMixupApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Potion Mixup',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: SplashScreen(), // Initial screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 150), // Placeholder for logo
            SizedBox(height: 20),
            Text('Potion Mixup',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Potion Mixup!')),
      drawer: MainDrawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Description placeholder for Potion Mixup.',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
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
            decoration: BoxDecoration(
              color: Color(0xFFF15590),
            ),
            accountName: Text('Andrea Nicole Dumanat'),
            accountEmail: Text('andreanicole.dumanat.cics@ust.edu.ph'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/roku.jpg'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.science),
            title: Text('Let\'s Mix!'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LetsMixPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.leaderboard),
            title: Text('Leaderboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LeaderboardPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.score),
            title: Text('My Scores'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyScoresPage()),
              );
            },
            /* ADD HERE UNG ABOUT US BUT SA PINAKADULOOOOOOO */
          ),
        ],
      ),
    );
  }
}
