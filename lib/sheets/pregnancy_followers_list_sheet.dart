import 'package:flutter/material.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';

class FollowersSheet extends StatelessWidget {
  final ScrollController scrollController;
  final Map<String, String> followers;
  final String pregnancyId;

  const FollowersSheet({
    super.key,
    required this.scrollController,
    required this.followers, required this.pregnancyId,
  });

  @override
  Widget build(BuildContext context) {
    final pregnancyService = PregnancyService();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    const separator = '||';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        controller: scrollController,
        children: [
          Text(
            'Seguidores del Embarazo',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (followers.isEmpty)
            const Text('No hay seguidores registrados'),
          ...followers.entries.map((entry) {
            final uid = entry.key;
            final combinedData = entry.value;
            final dataParts = combinedData.split(separator);
            final role = dataParts.isNotEmpty ? dataParts[0] : 'Desconocido';
            final email = dataParts.length > 1 ? dataParts[1] : 'Correo Desconocido';
            final firstName = dataParts.length > 2 ? dataParts[2] : 'Desconocido';
            final lastName = dataParts.length > 3 ? dataParts[3] : 'Desconocido';
            final baseColor = _profileColor(uid);

            // return Card(
            //   elevation: 0,
            //   margin: const EdgeInsets.symmetric(vertical: 4),
            //   color: Theme.of(context).colorScheme.surfaceContainerHigh,
            //   child: ListTile(
            //     leading: CircleAvatar(
            //       backgroundColor: baseColor.shade900,
            //       child: Text(uid == 'nNF18EWgOBb786CFQboARQN8gB53' ? 'MR' : uid[0]+uid[1],style: TextStyle(color: baseColor.shade100))
            //     ),                
            //     title: Text(uid == 'nNF18EWgOBb786CFQboARQN8gB53' ? 'Mamicheck' : '($role)', style: Theme.of(context).textTheme.labelLarge),
            //     subtitle: Text(uid, style: Theme.of(context).textTheme.bodySmall),
            //     trailing: role == 'owner' || uid == 'nNF18EWgOBb786CFQboARQN8gB53' ? null : IconButton.filled(
            //       icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.onPrimary),
            //       onPressed: () {
            //         showDialog(
            //           context: context,
            //           builder: (BuildContext dialogContext) {
            //             return AlertDialog(
            //               title: const Text('Eliminar Seguidor'),
            //               content: const Text('¿Estás seguro de que quieres eliminar a este seguidor? Esta acción no se puede deshacer.'),
            //               actions: [
            //                 FilledButton(
            //                   child: const Text('No, Gracias'),
            //                   onPressed: () {Navigator.of(dialogContext).pop();}
            //                 ),
            //                 TextButton(
            //                   child: const Text('Acepto'),
            //                   onPressed: () async {
            //                     Navigator.of(dialogContext).pop();
            //                     await pregnancyService.removeFollower(pregnancyId, uid);
            //                     messenger.showSnackBar(const SnackBar(content: Text('Seguidor eliminado correctamente.')),);  
            //                     navigator.pop(); 
            //                   },
            //                 )
            //               ],
            //             );
            //           },
            //         );
            //       },
            //     ),
            //   ),
            // );

            return Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: baseColor.shade900,
                  child: Text(firstName[0].toUpperCase() + lastName[0].toUpperCase(), style: TextStyle(color: baseColor.shade100))
                ),                
                title: Text('$firstName $lastName'.trim(), style: Theme.of(context).textTheme.labelLarge),
                subtitle: Text(email, style: Theme.of(context).textTheme.bodySmall),
                trailing: role == 'owner' || uid == 'nNF18EWgOBb786CFQboARQN8gB53' ? null : IconButton.filled(
                  icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.onPrimary),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Eliminar Seguidor'),
                          content: const Text('¿Estás seguro de que quieres eliminar a este seguidor? Esta acción no se puede deshacer.'),
                          actions: [
                            FilledButton(
                              child: const Text('No, Gracias'),
                              onPressed: () {Navigator.of(dialogContext).pop();}
                            ),
                            TextButton(
                              child: const Text('Acepto'),
                              onPressed: () async {
                                Navigator.of(dialogContext).pop();
                                await pregnancyService.removeFollower(pregnancyId, uid);
                                messenger.showSnackBar(const SnackBar(content: Text('Seguidor eliminado correctamente.')),);  
                                navigator.pop(); 
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            );

          }),
        ],
      ),
    );
  }

  MaterialColor _profileColor(String avatarText) {
    return Colors.primaries[avatarText.hashCode.abs() % Colors.primaries.length];
  }
}