import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';

class AccompanyScreen extends StatefulWidget {
  const AccompanyScreen({super.key});

  @override
  State<AccompanyScreen> createState() => _AccompanyScreenState();
}

class _AccompanyScreenState extends State<AccompanyScreen> {
  final _controller = TextEditingController();
  final _pregnancyService = PregnancyService();
  bool _loading = false;
  String? _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguir Embarazo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Ingresa el código del embarazo que deseas seguir:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'ID del embarazo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('Seguir'),
                    onPressed: () => _handleAction(true),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.person_remove),
                    label: const Text('Dejar de seguir'),
                    onPressed: () => _handleAction(false),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(color: _message!.startsWith('Error') ? Colors.red : Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(bool add) async {
    final pregnancyId = _controller.text.trim();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (pregnancyId.isEmpty || uid == null) return;

    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      if (add) {
        await _pregnancyService.addFollower(pregnancyId, uid);
        _message = 'Seguidor añadido correctamente.';
      } else {
        await _pregnancyService.removeFollower(pregnancyId, uid);
        _message = 'Seguidor eliminado correctamente.';
      }
    } catch (e) {
      _message = 'Error: ${e.toString()}';
    }

    setState(() {
      _loading = false;
    });
  }
}
