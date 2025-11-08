import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';
import 'package:mamicheckapp/services/user_service.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel?>();
    final notifications = userModel?.notifications ?? [];
    final messenger = ScaffoldMessenger.of(context);
    const separator = '||';

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: notifications.isEmpty
            ? _buildEmptyState(context)
            : SizedBox(
              height: 200,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: notifications.length,
                  itemBuilder: (context, i) {
                    final notif = notifications[i];
                    final pregnancyId = notif['pregnancyId'] ?? '';
                    final name = notif['pregnancyName'] ?? 'Embarazo';
                    final ts = DateTime.tryParse(notif['timestamp'] ?? '') ?? DateTime(1900);
                    final isElimination = pregnancyId.startsWith('eliminacion||');
                    final formattedDate = DateFormat.yMMMMEEEEd(Intl.defaultLocale).add_Hm().format(ts);
                    final titleText = isElimination ? 'Fuiste removido del seguimiento al embarazo:' : 'Se te invitó a monitorear el embarazo:';
                    
                    final actions = isElimination
                        ? [
                            FilledButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text('OK'),
                              onPressed: () async {
                                final uid = userModel?.uid;
                                if (uid == null) return;
                                try {
                                  await UserService().deleteNotification(
                                    uid: uid,
                                    pregnancyId: 'eliminacion||',
                                    pregnancyName: name,
                                    timestamp: notif['timestamp'],
                                  );
                                } catch (_) {
                                  messenger.clearSnackBars();
                                  messenger.showSnackBar(const SnackBar(content: Text('Error al borrar invitación'),),);
                                }
                              },
                            ),
                          ]
                        : [
                            FilledButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text('Aceptar'),
                              onPressed: () async {
                                final uid = userModel?.uid;
                                final firstname = userModel?.firstName ?? 'Desconocido';
                                final lastname = userModel?.lastName ?? 'Desconocido';
                                final emailadress = userModel?.email ?? 'Correo Desconocido';
                                if (uid == null) return;
                    
                                final followerData = 
                                'companion$separator'
                                '$emailadress$separator'
                                '$firstname$separator'
                                '$lastname';
              
                                try {
                                  await PregnancyService().addFollower(
                                    notif['pregnancyId'],
                                    uid,
                                    followerData,
                                  );
                                  await UserService().deleteNotification(
                                    uid: uid,
                                    pregnancyId: notif['pregnancyId'],
                                    pregnancyName: name,
                                    timestamp: notif['timestamp'],
                                  );
                                  messenger.clearSnackBars();
                                  messenger.showSnackBar(SnackBar(content: Text('Ahora sigues "$name"')),);
                                } catch (_) {
                                  messenger.clearSnackBars();
                                  messenger.showSnackBar(const SnackBar(content: Text('Error al aceptar invitación'),),);
                                }
                              },
                            ),
                            IconButton.outlined(
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
                                  messenger.clearSnackBars();
                                  messenger.showSnackBar(const SnackBar(content: Text('Notificación eliminada'),),);
                                } catch (_) {
                                  messenger.clearSnackBars();
                                  messenger.showSnackBar(const SnackBar(content: Text('Error al eliminar notificación'),),);
                                }
                              },
                            ),
                          ];
                    
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
                            Text(titleText, style: Theme.of(context).textTheme.bodyMedium),
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    formattedDate,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Wrap(spacing: 8, children: actions),
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

  // 🩶 Card de "no hay notificaciones"
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
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
    );
  }
}

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userModel = context.watch<UserModel?>();
//     final messenger = ScaffoldMessenger.of(context);
//     final notifications = userModel?.notifications ?? [];
//     const separator = '||';
//     return Scaffold(
//       appBar: AppBar(title: const Text('Notificaciones')),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: notifications.isEmpty
//             ? Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Card(
//                 elevation: 0,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 color: Theme.of(context).colorScheme.surfaceContainerHigh,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Comparte tu correo para que te puedan invitar', style: Theme.of(context).textTheme.bodyMedium,),
//                       const SizedBox(height: 6),
//                       Text('No tienes notificaciones pendientes',style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer,),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//             : SizedBox(
//               height: 200,
//               child: ListView.builder(
//                   itemCount: notifications.length,
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   itemBuilder: (context, i) {
//                     final notif = notifications[i];
//                     final name = notif['pregnancyName'] ?? 'Embarazo';
//                     final ts = DateTime.tryParse(notif['timestamp']) ?? DateTime(1900);
                    
//                     return Card(
//                       elevation: 0,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       color: Theme.of(context).colorScheme.surfaceContainerHigh,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Se te invitó a monitorear el embarazo:',
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               name,
//                               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: Theme.of(context).colorScheme.onPrimaryContainer,
//                                   ),
//                             ),
//                             const SizedBox(height: 6),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(DateFormat('d MMM yyyy, HH:mm', Intl.defaultLocale).format(ts), style: Theme.of(context).textTheme.bodySmall,),
//                                 Wrap(
//                                   spacing: 8,
//                                   children: [
//                                     FilledButton.icon(
//                                       icon: const Icon(Icons.check),
//                                       label: const Text('Aceptar'),
//                                       onPressed: () async {
//                                         final uid = userModel?.uid;
//                                         final firstname = userModel?.firstName ?? 'Desconocido';
//                                         final lastname = userModel?.lastName ?? 'Desconocido';
//                                         final emailadress = userModel?.email ?? 'Correo Desconocido';
//                                         if (uid == null) return;

//                                         final followerData = 
//                                         'companion$separator'
//                                         '$emailadress$separator'
//                                         '$firstname$separator'
//                                         '$lastname';
                      
//                                         try {
//                                           await PregnancyService().addFollower(
//                                             notif['pregnancyId'],
//                                             uid,
//                                             followerData,
//                                           );
//                                           await UserService().deleteNotification(
//                                             uid: uid,
//                                             pregnancyId: notif['pregnancyId'],
//                                             pregnancyName: name,
//                                             timestamp: notif['timestamp'],
//                                           );
//                                           messenger.clearSnackBars();
//                                           messenger.showSnackBar(SnackBar(content: Text('Ahora sigues "$name"')),);
//                                         } catch (_) {
//                                           messenger.clearSnackBars();
//                                           messenger.showSnackBar(const SnackBar(content: Text('Error al aceptar invitación'),),);
//                                         }
//                                       },
//                                     ),
//                                     IconButton.outlined (
//                                       icon: const Icon(Icons.delete_forever),
//                                       onPressed: () async {
//                                         final uid = userModel?.uid;
//                                         if (uid == null) return;
                      
//                                         try {
//                                           await UserService().deleteNotification(
//                                             uid: uid,
//                                             pregnancyId: notif['pregnancyId'],
//                                             pregnancyName: name,
//                                             timestamp: notif['timestamp'],
//                                           );
//                                           messenger.clearSnackBars();
//                                           messenger.showSnackBar(const SnackBar(content: Text('Notificación eliminada'),),);
//                                         } catch (_) {
//                                           messenger.clearSnackBars();
//                                           messenger.showSnackBar(const SnackBar(content: Text('Error al eliminar notificación'),),);
//                                         }
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//             ),
//       ),
//     );
//   }
// }
