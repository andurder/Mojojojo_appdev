import 'package:flutter/material.dart';
import 'package:potion_mixup/mixpage.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const MainDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7), // Reduced opacity
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 191, 55, 218).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Potion Mix-Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Mix and match different potions to create powerful effects! '
                  'Experiment with various ingredients to see what magical '
                  'potions you can conjure. Will you be the ultimate potion master?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LetsMixPage()),
                    );
                  },
                  child: const Text("Let's Brew!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
