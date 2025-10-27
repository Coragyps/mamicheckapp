import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/sheets/pregnancy_followers_create_sheet.dart';
import 'package:mamicheckapp/screens/content_screen.dart';
import 'package:mamicheckapp/sheets/pregnancy_followers_list_sheet.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firebaseuser = FirebaseAuth.instance.currentUser;
  int selectedPregnancyIndex = 0;
  String selectedPeriod = 'Ver Todo';

  @override
  Widget build(BuildContext context) {
    final List<PregnancyModel> pregnancies = context.watch<List<PregnancyModel>>();
    final UserModel? userModel = context.watch<UserModel?>();
    final PregnancyModel? selectedPregnancy = pregnancies.isNotEmpty ? pregnancies[selectedPregnancyIndex] : null;
    final now = DateTime.now();
    final bool isLoading = pregnancies.length == 1 && pregnancies.first.id == 'dummy';
    final bool hasActiveOwnedPregnancy = userModel != null && pregnancies.isNotEmpty && pregnancies.first.isActive && _extractRole(pregnancies.first.followers[userModel.uid]) == 'owner';

    final filteredMeasurements = switch (selectedPeriod) {
      'Últimos 7 Días' => selectedPregnancy?.measurements.where((m) => now.difference(m.date).inDays <= 7).toList(),
      'Últimos 30 Días' => selectedPregnancy?.measurements.where((m) => now.difference(m.date).inDays <= 30).toList(),
      '1er Trimestre' => selectedPregnancy?.measurements.where((m) {final week = m.date.difference(selectedPregnancy.lastMenstrualPeriod).inDays ~/ 7; return week >= 0 && week <= 13;}).toList(),
      '2do Trimestre' => selectedPregnancy?.measurements.where((m) {final week = m.date.difference(selectedPregnancy.lastMenstrualPeriod).inDays ~/ 7; return week >= 14 && week <= 27;}).toList(),
      '3er Trimestre' => selectedPregnancy?.measurements.where((m) {final week = m.date.difference(selectedPregnancy.lastMenstrualPeriod).inDays ~/ 7; return week >= 28;}).toList(),
      _ => selectedPregnancy?.measurements,
    };

    return Scaffold(
      appBar: _buildAppBar(userModel?.firstName, userModel?.lastName, userModel?.uid, userModel?.notifications),  
      bottomNavigationBar: _buildBottomAppBar(userModel?.uid, pregnancies.map((p) => p.name).toList(), selectedPregnancy?.id, selectedPregnancy?.isActive, selectedPregnancy?.followers, hasActiveOwnedPregnancy, userModel?.firstName, userModel?.birthDate, userModel?.lastName, userModel?.email),
      body: isLoading ? Center(child: CircularProgressIndicator()) : pregnancies.isEmpty && userModel != null ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _suggestionCard(
              title: '¿Tienes un embarazo activo?',
              description: 'Has seguimiento continuo a tu salud registrando tus datos.',
              button: ElevatedButton.icon(
                icon: const Icon(Icons.playlist_add),
                label: const Text('Registrar mi Embarazo'),
                onPressed: () {
                  Navigator.pushNamed(context, 'PregnancyDialog', arguments: PregnancyDialogArguments(uid: userModel.uid, firstName: userModel.firstName, birthDate: userModel.birthDate, email: userModel.email, lastName:userModel.lastName));
                },
              )
            ),
            _suggestionCard(
              title: '¿Buscas monitorear un embarazo?',
              description: 'La gestante te puede enviar una solicitud para que aceptes unirte al monitoreo',
              button: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Ir a Notificaciones'),
                onPressed: () {Navigator.pushNamed(context, 'NotificationScreen');},
              )
            ),
          ],
        )
      ) : ContentScreen(pregnancy: selectedPregnancy, uid: userModel?.uid, selectedPeriod: selectedPeriod, filteredMeasurements: filteredMeasurements ?? [], firstName: userModel?.firstName, birthDate: userModel?.birthDate),
      floatingActionButton: _buildFloatingActionButton(userModel?.uid, userModel?.birthDate, selectedPregnancy?.measurements, selectedPregnancy?.id, selectedPregnancy?.isActive, selectedPregnancy?.followers),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _suggestionCard({required String title, required String description, required ElevatedButton button}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.secondaryFixed,
        //margin: const EdgeInsets.only(bottom: 48),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 32, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                    Text(description),
                    button
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String? firstName, String? lastName, String? uid, List<Map<String, dynamic>>? notifications) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(image: AssetImage('assets/img/logo.png'), fit: BoxFit.contain)
      ),
      title: Text('Mamicheck', style: TextStyle(fontFamily: 'Caveat', color: Color(0xffCA3E7F))),
      actions: [
        IconButton(
          onPressed: () {Navigator.pushNamed(context, 'NotificationScreen');},
          icon: notifications != null ? Badge.count(
            isLabelVisible: notifications.isNotEmpty,
            count: notifications.length,
            child: notifications.isNotEmpty ? Icon(Icons.notifications) : Icon(Icons.notifications_outlined),
          ) : Icon(Icons.notifications_outlined)
        ),
        IconButton(
          icon: firstName != null && lastName != null && uid != null ? CircleAvatar(
            backgroundColor: Colors.primaries[uid.hashCode.abs() % Colors.primaries.length].shade900,
            child: Text(firstName[0].toUpperCase() + lastName[0].toUpperCase(), style: TextStyle(color: Colors.primaries[uid.hashCode.abs() % Colors.primaries.length].shade100)),
          ) : CircleAvatar(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
          onPressed: () {Navigator.pushNamed(context, 'ProfileScreen');},
        )
        // PopupMenuButton<String>(
        //   onSelected: (String value) {
        //     final messenger = ScaffoldMessenger.of(context);
        //     switch (value) {
        //       case 'profile':
        //         Navigator.pushNamed(context, 'ProfileScreen');
        //         break;
        //       case 'config':
        //         Navigator.pushNamed(context, 'SettingsScreen');
        //         break;
        //       case 'api':
        //         Navigator.pushNamed(context, 'APITest');
        //         break;
        //       case 'help':
        //         Navigator.pushNamed(context, 'HelpScreen');
        //         break;
        //       case 'signout':
        //         showDialog(
        //           context: context,
        //           builder: (BuildContext dialogContext) {
        //             final dialognavigator = Navigator.of(dialogContext);
        //             return AlertDialog(
        //               title: const Text('¿Deseas cerrar sesión?'),
        //               content: const Text('Si continuas, se cerrará la sesión de tu cuenta y volverás a la pantalla de inicio.\n\nTendrás que volver a acceder para usar el resto de funciones.'),
        //               actions: [
        //                 FilledButton(
        //                   child: const Text('No, Gracias'),
        //                   onPressed: () {
        //                     dialognavigator.pop();
        //                   },
        //                 ),
        //                 TextButton(
        //                   child: const Text('Acepto'),
        //                   onPressed: () async {
        //                     dialognavigator.pop();
        //                     await Future.delayed(Duration.zero);
        //                     await AuthService().signout();                              
        //                   },
        //                 )
        //               ], 
        //             );
        //           }
        //         );
        //         break;                
        //       default:
        //         messenger.showSnackBar(
        //           SnackBar(content: Text('¡Acción "$value" no existe!'))
        //         );
        //     }
        //   },
        //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //     const PopupMenuItem<String>(value: 'profile', child: Row(
        //       children: [Icon(Icons.person_outline), SizedBox(width: 8,), Text('Mi Perfil')],
        //     )),
        //     const PopupMenuItem<String>(value: 'config', child: Row(
        //       children: [Icon(Icons.settings_outlined), SizedBox(width: 8,), Text('Configuración')],
        //     )),
        //     const PopupMenuDivider(),
        //     const PopupMenuItem<String>(value: 'help', child: Row(
        //       children: [Icon(Icons.help_outline), SizedBox(width: 8,), Text('Ayuda')],
        //     )),
        //     const PopupMenuDivider(),
        //     const PopupMenuItem<String>(value: 'signout', child: Row(
        //       children: [Icon(Icons.logout, color: Color.fromRGBO(183, 28, 28, 1)), SizedBox(width: 8,), Text('Cerrar Sesión', style: TextStyle(color: Color.fromRGBO(183, 28, 28, 1)))],
        //     )),
        //   ],
        //   icon: firstName != null && lastName != null && uid != null ? CircleAvatar(
        //     backgroundColor: Colors.primaries[uid.hashCode.abs() % Colors.primaries.length].shade900,
        //     child: Text(firstName[0].toUpperCase() + lastName[0].toUpperCase(), style: TextStyle(color: Colors.primaries[uid.hashCode.abs() % Colors.primaries.length].shade100)),
        //   ) : CircleAvatar(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest)
        // )
      ],
    );
  }

  Widget _buildBottomAppBar(String? uid, List<String>? pregnancyNames, String? pregnancyId, bool? pregnancyIsActive, Map<String, String>? pregnancyFollowers, bool hasActiveOwnedPregnancy, String? firstName, DateTime? birthDate, String? lastName, String? email) {
    return BottomAppBar(
      //olor: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
            MenuAnchor(
              builder: (context, controller, _) {
                return FilledButton.icon(
                  icon: controller.isOpen ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
                  label: Text('Monitorear'),
                  onPressed: controller.isOpen ? controller.close : controller.open,
                );
              },
              menuChildren: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text('Selecciona el\nEmbarazo:'),
                ),
                if (pregnancyNames!.isNotEmpty) ...[
                  for (int i = 0; i < pregnancyNames.length; i++)
                  MenuItemButton(
                    leadingIcon: selectedPregnancyIndex == i ? Icon(Icons.remove_red_eye) : null,
                    onPressed: () {
                      final messenger = ScaffoldMessenger.of(context);
                      setState(() {
                        selectedPregnancyIndex = i;
                      });
                      messenger.showSnackBar(SnackBar(content: Text('Mostrando ${pregnancyNames[i]}')));
                    },
                    child: Text(pregnancyNames[i]),
                  ),
                ],
                if (!hasActiveOwnedPregnancy) ...[
                  Divider(),
                  MenuItemButton(
                    leadingIcon: Icon(Icons.assignment_outlined, color: Color.fromRGBO(183, 28, 28, 1),),
                    onPressed: () {Navigator.pushNamed(context, 'PregnancyDialog', arguments: PregnancyDialogArguments(uid: uid!, firstName: firstName!, birthDate: birthDate!, lastName: lastName!, email: email!));}, 
                    child: Text('Registrar un\nEmbarazo', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Color.fromRGBO(183, 28, 28, 1)),)
                  ),
                ]
              ],
            ),
            if (pregnancyNames.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(Icons.access_time),
              onSelected: (String newPeriod) {
                final messenger = ScaffoldMessenger.of(context);
                setState(() {
                  selectedPeriod = newPeriod;
                });
                messenger.showSnackBar(SnackBar(content: Text('Mostrando resultados de $selectedPeriod')));
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(value: 'Ver Todo', child: Row(
                  children: [
                    if (selectedPeriod == 'Ver Todo') ...[Icon(Icons.access_time_filled), SizedBox(width: 8)], Text('Ver Todo')
                  ],
                )),
                PopupMenuItem<String>(value: 'Últimos 7 Días', child: Row(
                  children: [
                    if (selectedPeriod == 'Últimos 7 Días') ...[Icon(Icons.access_time_filled), SizedBox(width: 8)], Text('Últimos 7 Días')
                  ],
                )),
                PopupMenuItem<String>(value: 'Últimos 30 Días', child: Row(
                  children: [
                    if (selectedPeriod == 'Últimos 30 Días') ...[Icon(Icons.access_time_filled), SizedBox(width: 8)], Text('Últimos 30 Días')
                  ],
                )),
                const PopupMenuDivider(),
                PopupMenuItem<String>(value: '1er Trimestre', child: Row(
                  children: [
                    if (selectedPeriod == '1er Trimestre') ...[Icon(Icons.access_time_filled), SizedBox(width: 8)], Text('1er Trimestre')
                  ],
                )),
                PopupMenuItem<String>(value: '2do Trimestre', child: Row(
                  children: [
                    if (selectedPeriod == '2do Trimestre') ...[Icon(Icons.access_time_filled), SizedBox(width: 8)], Text('2do Trimestre')
                  ],
                )),
                PopupMenuItem<String>(value: '3er Trimestre', child: Row(
                  children: [
                    if (selectedPeriod == '3er Trimestre') ...[Icon(Icons.access_time_filled), SizedBox(width: 8)], Text('3er Trimestre')
                  ],
                )),
              ]
            ),
            if (pregnancyNames.isNotEmpty)
            PopupMenuButton(
              icon: Icon(Icons.share_outlined),
              onSelected: (String value) {
                final messenger = ScaffoldMessenger.of(context);
                switch (value) {
                  case 'Invitar':
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          minChildSize: 0.4,
                          initialChildSize: 0.7,
                          builder: (context, scrollController) {
                            return Center(
                              child: InviteSheet(
                                pregnancyName: pregnancyNames[selectedPregnancyIndex],
                                pregnancyId: pregnancyId!,
                                followers: pregnancyFollowers!
                              ),
                            );
                          }
                        );
                      },
                    );
                    break;
                  case 'Seguidores':
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          minChildSize: 0.4,
                          initialChildSize: 0.7,
                          builder: (context, scrollController) {
                            return FollowersSheet(
                              scrollController: scrollController,
                              pregnancyId: pregnancyId!,
                              followers: pregnancyFollowers!
                            );
                          }
                        );
                      },
                    );
                    break;
                  case 'Ver Mediciones':
                    Navigator.pushNamed(context, 'MeasurementsScreen', arguments: MeasurementsScreenArguments(pregnancyId: pregnancyId!));
                    break;
                  case 'Exportar a PDF':
                    Navigator.pushNamed(context, 'HelpScreen');
                    break;
                  case 'Archivar':
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        final dialognavigator = Navigator.of(dialogContext);
                        return AlertDialog(
                          title: const Text('¿Dejar de monitorear este Embarazo?'),
                          content: const Text('Si continuas, no se podra volver a añadir mediciones a este embarazo y se marcara como archivado'),
                          actions: [
                            FilledButton(
                              child: const Text('No, Gracias'),
                              onPressed: () {
                                dialognavigator.pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Acepto'),
                              onPressed: () async {
                                await PregnancyService().deactivatePregnancy(pregnancyId!);
                                messenger.showSnackBar(SnackBar(content: Text('${pregnancyNames[selectedPregnancyIndex]} se marco como archivado')));
                                dialognavigator.pop();                      
                              },
                            )
                          ],
                        );
                      }
                    );
                    break;                
                  default: messenger.showSnackBar(SnackBar(content: Text('¡Acción "$value" no existe!')));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'Invitar', child: Row(
                  children: [Icon(Icons.person_add_outlined), SizedBox(width: 8,), Text('Invitar')],
                )),
                const PopupMenuItem<String>(value: 'Seguidores', child: Row(
                  children: [Icon(Icons.people_outlined), SizedBox(width: 8,), Text('Seguidores')],
                )),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(value: 'Ver Mediciones', child: Row(
                  children: [Icon(Icons.view_list_outlined), SizedBox(width: 8,), Text('Ver Mediciones')],
                )),
                const PopupMenuItem<String>(value: 'Exportar a PDF', child: Row(
                  children: [Icon(Icons.task_outlined), SizedBox(width: 8,), Text('Ayuda')],
                )),
                if (pregnancyIsActive! && _extractRole(pregnancyFollowers![uid]) == 'owner') ...[
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(value: 'Archivar', child: Row(
                    children: [Icon(Icons.archive_outlined, color: Color.fromRGBO(183, 28, 28, 1)), SizedBox(width: 8,), Text('Archivar', style: TextStyle(color: Color.fromRGBO(183, 28, 28, 1)))],
                  ))
                ]
              ],
            )
        ]
      ),
    );
  }

  Widget _buildFloatingActionButton(String? uid, DateTime? birthDate, List<MeasurementModel>? currentMeasurements, String? pregnancyId, bool? pregnancyIsActive, Map<String, String>? pregnancyFollowers) {
    if (birthDate != null && pregnancyId != null && currentMeasurements != null) {
      return pregnancyIsActive == true && _extractRole(pregnancyFollowers?[uid]) == 'owner' ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'MeasurementDialog', arguments: MeasurementDialogArguments(birthDate: birthDate, currentMeasurements: currentMeasurements, pregnancyId: pregnancyId));
        },
        child: const Icon(Icons.add),
      ) : SizedBox.shrink();
    } else {return SizedBox.shrink();}
  }

  String _extractRole(String? followerData) {
    if (followerData == null || followerData.isEmpty) return 'none';    
    final parts = followerData.split('||');
    return parts.first; 
  }
}