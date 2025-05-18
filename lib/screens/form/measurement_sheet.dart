import 'package:flutter/material.dart';

class MeasurementSheet extends StatelessWidget {
  final ScrollController scrollController;
  const MeasurementSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Contenido desplazable
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text('Aquí va tu contenido', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    for (var i = 0; i < 30; i++) ListTile(title: Text('Item $i')),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // Botones fijos abajo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Guardado exitosamente')),
                      );
                    },
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


