import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('notify'),
      ),
      body: Center(
        child: Image(
          image: AssetImage('assets/img/logo.png'),
        ),
      ),
    );
  }
}