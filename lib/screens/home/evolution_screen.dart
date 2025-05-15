import 'package:flutter/material.dart';

class EvolutionScreen extends StatelessWidget {
  const EvolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (_, i) => ListTile(
        title: Text('Item $i')
      ),
    );
  }
}