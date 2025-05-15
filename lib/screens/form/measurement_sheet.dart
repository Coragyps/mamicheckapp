import 'package:flutter/material.dart';

class MeasurementSheet extends StatelessWidget {
  final ScrollController scrollController;
  const MeasurementSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView.builder(
        controller: scrollController,
        itemCount: 31, // 1 estático + 30 dinámicos
        itemBuilder: (_, i) {
          if (i == 0) {
            return Column(
              children: [
                Text('Aquí va tu contenido'),
              ],
            );
          }
          return ListTile(title: Text('Item ${i - 1}'));
        },
      ),
    );
  }
}


