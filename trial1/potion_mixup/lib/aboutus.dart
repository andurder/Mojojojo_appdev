import 'package:flutter/material.dart';
import 'main.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const MainDrawer(), // Add the drawer here
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Description
              const SizedBox(height: 70),
              const Text(
                'We are the Mojojojo—named after the infamous mastermind Mojojojo, but instead of causing chaos, '
                'we’re here to mix things up in the best way possible! Inspired by the Powerpuff Girls\' mix of sugar, spice, '
                'and everything nice, we’ve blended creativity, innovation, and a touch of whimsy to bring you Potion Mix-Up! '
                'This application is part of our requirements for the course Applications Development and Emerging Technologies 3 (Mobile Programming). \n\n',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 50),

              // Images Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImage("assets/images/image1.jpg"),
                  _buildImage("assets/images/image2.jpg"),
                  _buildImage("assets/images/image3.jpg"),
                ],
              ),
              const SizedBox(height: 50),

              // Closing Text
              const Text(
                'Grab your ingredients, channel your inner hero—or villain—and let’s brew some magic together! ✨',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
