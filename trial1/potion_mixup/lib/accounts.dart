import 'package:flutter/material.dart';
import 'main.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      drawer: MainDrawer(),
      body: Center(child: Text('Account Page Placeholder')),
    );
  }
}
