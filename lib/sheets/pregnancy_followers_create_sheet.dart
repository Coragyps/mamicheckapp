import 'package:flutter/material.dart';
import 'package:mamicheckapp/services/user_service.dart';

class InviteSheet extends StatefulWidget {
  final String pregnancyName;
  final String pregnancyId;
  const InviteSheet({super.key, required this.pregnancyName, required this.pregnancyId});

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailErrorText;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    bool isLoading = false;

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
          onPressed: isLoading ? null : () async {
            final email = _emailController.text.trim();

            if (email.isEmpty) {
              setState(() => _emailErrorText = 'Por favor ingresa un correo válido');
              return;
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
                messenger.showSnackBar(
                  SnackBar(content: Text('Se invitó a: $email a monitorear el embarazo ${widget.pregnancyName}')),
                );
                navigator.pop();
              } else {
                setState(() => _emailErrorText = 'No se encontró ese correo');
              }
            } catch (e) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Ocurrió un error al invitar')),
              );
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