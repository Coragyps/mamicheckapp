import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';
import 'package:mamicheckapp/services/user_service.dart';
import 'package:provider/provider.dart';

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userModel = context.watch<UserModel?>();
//     final messenger = ScaffoldMessenger.of(context);
//     final notifications = userModel?.notifications ?? [];

//     return Scaffold(
//       appBar: AppBar(title: const Text('Notificaciones')),
//       body: notifications.isEmpty
//           ? const Center(child: Text('No tienes notificaciones pendientes'))
//           : ListView.builder(
//               itemCount: notifications.length,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               itemBuilder: (context, i) {
//                 final notif = notifications[i];
//                 final name = notif['pregnancyName'] ?? 'Embarazo';
//                 final ts = DateTime.tryParse(notif['timestamp'] ?? '');
//                 final date = ts != null
//                     ? '${ts.day}/${ts.month}/${ts.year}\n${ts.hour}:${ts.minute.toString().padLeft(2, '0')}'
//                     : 'Fecha desconocida';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   elevation: 0,
//                   color: Theme.of(context).colorScheme.secondaryContainer,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Se te invitó a monitorear el embarazo:',
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           name,
//                           style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed),
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(date, style: Theme.of(context).textTheme.bodyMedium),
//                             Row(
//                               children: [
//                                 FilledButton.icon(
//                                   icon: const Icon(Icons.check),
//                                   label: Text('Aceptar'),
//                                   onPressed: () async {
//                                     final uid = userModel?.uid;
//                                     if (uid == null) return;

//                                     try {
//                                       await PregnancyService().addFollower(notif['pregnancyId'], uid);
//                                       await UserService().deleteNotification(
//                                         uid: uid,
//                                         pregnancyId: notif['pregnancyId'],
//                                         pregnancyName: name,
//                                         timestamp: notif['timestamp'],
//                                       );
//                                       messenger.showSnackBar(SnackBar(content: Text('Ahora sigues "$name"')));
//                                     } catch (_) {
//                                       messenger.showSnackBar(
//                                         const SnackBar(content: Text('Error al aceptar invitación')),
//                                       );
//                                     }
//                                   },
//                                 ),
//                                 IconButton.filled(
//                                   icon: const Icon(Icons.delete_forever),
//                                   onPressed: () async {
//                                     final uid = userModel?.uid;
//                                     if (uid == null) return;

//                                     try {
//                                       await UserService().deleteNotification(
//                                         uid: uid,
//                                         pregnancyId: notif['pregnancyId'],
//                                         pregnancyName: name,
//                                         timestamp: notif['timestamp'],
//                                       );
//                                       messenger.showSnackBar(
//                                         const SnackBar(content: Text('Notificación eliminada')),
//                                       );
//                                     } catch (_) {
//                                       messenger.showSnackBar(
//                                         const SnackBar(content: Text('Error al eliminar notificación')),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel?>();
    final messenger = ScaffoldMessenger.of(context);
    final notifications = userModel?.notifications ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: notifications.isEmpty
            ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Comparte tu correo para que te puedan invitar', style: Theme.of(context).textTheme.bodyMedium,),
                      const SizedBox(height: 6),
                      Text('No tienes notificaciones pendientes',style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer,),
                      ),
                    ],
                  ),
                ),
              ),
            )
            : Container(
              height: 200,
              child: ListView.builder(
                  itemCount: notifications.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemBuilder: (context, i) {
                    final notif = notifications[i];
                    final name = notif['pregnancyName'] ?? 'Embarazo';
                    final ts = DateTime.tryParse(notif['timestamp'] ?? '');
                    final date = ts != null
                        ? '${ts.day}/${ts.month}/${ts.year}\n${ts.hour}:${ts.minute.toString().padLeft(2, '0')}'
                        : 'Fecha desconocida';
                      
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Se te invitó a monitorear el embarazo:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  date,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Row(
                                  children: [
                                    FilledButton.icon(
                                      icon: const Icon(Icons.check),
                                      label: const Text('Aceptar'),
                                      onPressed: () async {
                                        final uid = userModel?.uid;
                                        if (uid == null) return;
                      
                                        try {
                                          await PregnancyService().addFollower(
                                            notif['pregnancyId'],
                                            uid,
                                          );
                                          await UserService().deleteNotification(
                                            uid: uid,
                                            pregnancyId: notif['pregnancyId'],
                                            pregnancyName: name,
                                            timestamp: notif['timestamp'],
                                          );
                                          messenger.showSnackBar(
                                            SnackBar(content: Text('Ahora sigues "$name"')),
                                          );
                                        } catch (_) {
                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text('Error al aceptar invitación'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton.filled(
                                      icon: const Icon(Icons.delete_forever),
                                      onPressed: () async {
                                        final uid = userModel?.uid;
                                        if (uid == null) return;
                      
                                        try {
                                          await UserService().deleteNotification(
                                            uid: uid,
                                            pregnancyId: notif['pregnancyId'],
                                            pregnancyName: name,
                                            timestamp: notif['timestamp'],
                                          );
                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text('Notificación eliminada'),
                                            ),
                                          );
                                        } catch (_) {
                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text('Error al eliminar notificación'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),
      ),
    );
  }
}
