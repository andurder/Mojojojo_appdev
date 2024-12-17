import 'package:flutter/material.dart';
import 'main.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      drawer: const MainDrawer(),
      body: const Center(child: Text('Account Page Placeholder')),
    );
  }
}
