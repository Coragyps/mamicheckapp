import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPasswordEditSheet extends StatefulWidget {
  const UserPasswordEditSheet({super.key});

  @override
  State<UserPasswordEditSheet> createState() => _UserPasswordEditSheetState();
}

class _UserPasswordEditSheetState extends State<UserPasswordEditSheet> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailErrorText;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            enabled: !isLoading,
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              border: const OutlineInputBorder(),
              errorText: _emailErrorText,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.lock_reset),
            label: Text(isLoading ? 'Enviando...' : 'Restablecer contraseña'),
            onPressed: isLoading
                ? null
                : () async {
                    final email = _emailController.text.trim();

                    if (email.isEmpty ||
                        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(email)) {
                      setState(() =>
                          _emailErrorText = 'Por favor ingresa un correo válido');
                      return;
                    }

                    setState(() {
                      isLoading = true;
                      _emailErrorText = null;
                    });

                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);

                      if (!mounted) return;
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Si existe una cuenta con ese correo, recibirás un enlace para restablecer tu contraseña.',
                          ),
                        ),
                      );
                      navigator.pop();
                    } catch (_) {
                      // Evitar user enumeration
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Si existe una cuenta con ese correo, recibirás un enlace para restablecer tu contraseña.',
                          ),
                        ),
                      );
                      navigator.pop();
                    } finally {
                      if (mounted) setState(() => isLoading = false);
                    }
                  },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}