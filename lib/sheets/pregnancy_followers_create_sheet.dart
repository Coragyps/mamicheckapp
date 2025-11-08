import 'package:flutter/material.dart';
import 'package:mamicheckapp/services/user_service.dart';

class InviteSheet extends StatefulWidget {
  final String pregnancyName;
  final String pregnancyId;
  final Map<String, String> followers;
  const InviteSheet({super.key, required this.pregnancyName, required this.pregnancyId, required this.followers});

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailErrorText;
  bool isLoading = false;

  String _extractEmailFromFollowerData(String followerData) {
      if (followerData.isEmpty) return '';
      final parts = followerData.split('||');
      return parts.length > 1 ? parts[1] : ''; 
  }

  bool _isEmailAlreadyFollower(String invitedEmail) {
      final normalizedEmail = invitedEmail.toLowerCase();
      
      for (final followerData in widget.followers.values) {
          final existingEmail = _extractEmailFromFollowerData(followerData);
          if (existingEmail.toLowerCase() == normalizedEmail) {
              return true;
          }
      }
      return false;
  }

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
              labelText: 'Correo del acompañante',
              border: const OutlineInputBorder(),
              errorText: _emailErrorText,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
          onPressed: () async {
            final email = _emailController.text.trim();

            if (email.isEmpty) {
              setState(() => _emailErrorText = 'Por favor ingresa un correo válido');
              return;
            }

            if (_isEmailAlreadyFollower(email)) {
              setState(() => _emailErrorText = 'Este correo ya es seguidor de este embarazo.');
              return; // Sale de la función
            }

            setState(() {
              isLoading = true;
              _emailErrorText = null; // limpia errores anteriores
            });

            try {
              final uid = await UserService().getUidByEmail(email);

              if (uid != null) {
                await UserService().sendPregnancyInviteNotification(
                  uid: uid,
                  pregnancyId: widget.pregnancyId,
                  pregnancyName: widget.pregnancyName,
                );

                if (!mounted) return;
                messenger.clearSnackBars();
                messenger.showSnackBar(SnackBar(content: Text('Se invitó a: $email a monitorear el embarazo ${widget.pregnancyName}')),);
                navigator.pop();
              } else {
                setState(() => _emailErrorText = 'No se encontró ese correo');
              }
            } catch (e) {
              messenger.clearSnackBars();
              messenger.showSnackBar(const SnackBar(content: Text('Ocurrió un error al invitar')),);
            } finally {
              if (mounted) setState(() => isLoading = false);
            }
          },
            icon: const Icon(Icons.send),
            label: const Text('Invitar'),
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