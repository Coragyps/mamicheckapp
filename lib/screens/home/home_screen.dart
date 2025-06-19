import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens/home/avatar.dart';
import 'package:mamicheckapp/screens/home/content_screen.dart';
import 'package:mamicheckapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _selectedIndex = 0;
  // late List<List<dynamic>> _pages;
  final firebaseuser = FirebaseAuth.instance.currentUser;

  int selectedPregnancyIndex = 0;
  String selectedPeriod = 'Ver Todo';

  //     final List<Tab> _tabs = [
  //   Tab(text: 'Resumen', icon: Icon(Icons.medical_services_outlined),),
  //   Tab(text: 'Evolución', icon: Icon(Icons.analytics_outlined)),
  //   Tab(text: 'Seguimiento', icon: Icon(Icons.groups_outlined)),
  // ];

  // final List<Widget> _pages2 = [
  //   SummaryScreen(),
  //   EvolutionScreen(),
  //   Placeholder()
  // ];

  // void _changeTab(int newIndex) {
  //   setState(() {_selectedIndex = newIndex;});
  // }

///override no borrar
  // @override
  // void initState() {
  //   super.initState();

  //   _pages = [
  //     [SummaryScreen(),'Resumen', Icon(Icons.medical_services_outlined), Icon(Icons.medical_services), 'Resumen'],
  //     [EvolutionScreen(),'Evolución', Icon(Icons.analytics_outlined), Icon(Icons.analytics), 'Mi Evolución'],
  //     [AccompanyScreen(),'Seguimiento', Icon(Icons.groups_outlined), Icon(Icons.groups), 'Seguimiento'],
  //   ];
  // }

@override
Widget build(BuildContext context) {
  final pregnancies = context.watch<List<PregnancyModel>>();
  final userModel = context.watch<UserModel?>();

  if (userModel == null) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  if (pregnancies.isEmpty) {
    return Scaffold(
      body: Center(
        child: Text('No hay embarazos disponibles'),
      ),
    );
  }

  final rawMeasurements = pregnancies[selectedPregnancyIndex].measurements..sort((a, b) => a.date.compareTo(b.date));
  final lastPeriodDate = pregnancies[selectedPregnancyIndex].lastMenstrualPeriod;

  final filteredMeasurements = switch (selectedPeriod) {
    'Últimos 7 Días' => rawMeasurements.where((m) => DateTime.now().difference(m.date).inDays <= 7).toList(),
    'Últimos 30 Días' => rawMeasurements.where((m) => DateTime.now().difference(m.date).inDays <= 30).toList(),
    '1er Trimestre' => rawMeasurements.where((m) {
        final week = m.date.difference(lastPeriodDate).inDays ~/ 7;
        return week >= 0 && week <= 13;
      }).toList(),
    '2do Trimestre' => rawMeasurements.where((m) {
        final week = m.date.difference(lastPeriodDate).inDays ~/ 7;
        return week >= 14 && week <= 27;
      }).toList(),
    '3er Trimestre' => rawMeasurements.where((m) {
        final week = m.date.difference(lastPeriodDate).inDays ~/ 7;
        return week >= 28;
      }).toList(),
    _ => rawMeasurements, // 'Ver Todo' o cualquier otro
  };

  return Scaffold(
    appBar: _buildAppBar(context),
    body: ContentScreen(
      pregnancy: pregnancies[selectedPregnancyIndex],
      uid: userModel.uid,
      firstName: userModel.firstName,
      birthDate: userModel.birthDate,
      selectedPeriod: selectedPeriod,
      filteredMeasurements: filteredMeasurements,
    ),
    bottomNavigationBar: _buildBottomAppBar(context, pregnancies, userModel.uid),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    floatingActionButton: _buildFloatingActionButton(context, pregnancies, userModel),
  );
}


///ereal
  // @override
  // Widget build(BuildContext context) {
  //   final pregnancies = context.watch<List<PregnancyModel>>();
  //   final userModel = context.watch<UserModel?>();

  //     if (userModel == null) {
  //   return Center(child: CircularProgressIndicator());
  // }
    
  // if (pregnancies.isEmpty) {
  //   return Center(child: Text('No hay embarazos disponibles.'));
  // }

  //   return Scaffold(
  //     appBar: _titlebar(context),
  //     body: ContentScreen(pregnancy: pregnancies[selectedPregnancyIndex], uid: userModel.uid, firstName: userModel.firstName, birthDate: userModel.birthDate, selectedPeriod: selectedPeriod,),
///eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  //     bottomNavigationBar: BottomAppBar(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           MenuAnchor(
  //             builder: (context, controller, _) {
  //               return ElevatedButton.icon(
  //                 icon: controller.isOpen ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
  //                 label: Text('Embarazo'),
  //                 onPressed: controller.isOpen ? controller.close : controller.open,
  //               );
  //             },
  //             menuChildren: [
  //               for (int i = 0; i < pregnancies.length; i++) 
  //               MenuItemButton(
  //                 leadingIcon: pregnancies[i].followers[firebaseuser!.uid] == "owner" && pregnancies[i].isActive ? Icon(Icons.bookmark) : null,
  //                 onPressed: () {
  //                   setState(() {
  //                     selectedPregnancyIndex = i;
  //                   });
  //                 },
  //                 child: Text(pregnancies[i].name),
  //               ),
  //             ],
  //           ),

  /////////////////////////////////////////////////////////////
  //           PopupMenuButton<int>(
  //             icon: Icon(Icons.access_time),
  //             onSelected: (int newPeriod) {
  //               setState(() {
  //                 selectedPeriod = newPeriod;
  //               });
  //             },
  //             itemBuilder: (context) => <PopupMenuEntry<int>>[
  //               PopupMenuItem(
  //                 value: null,
  //                 child: Text('Todo'),
  //               ),
  //               PopupMenuItem(
  //                 value: 7,
  //                 child: Text('Últimos 7 días'),
  //               ),
  //               PopupMenuItem(
  //                 value: 2,
  //                 child: Text('Últimas 2 semanas'),
  //               ),
  //               PopupMenuItem(
  //                 value: 30,
  //                 child: Text('Último mes'),
  //               ),
  //               PopupMenuItem(
  //                 value: 60,
  //                 child: Text('Últimos 2 meses'),
  //               ),
  //               PopupMenuItem(
  //                 value: 140,
  //                 child: Text('A las 20 semanas'),
  //               ),
  //             ],
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.share_outlined),
  //             onPressed: () {
  //               showDialog(
  //                 context: context,
  //                 builder: (_) => const AlertDialog(
  //                   title: Text('No se puede registrar'),
  //                   content: Text('Debes tener un embarazo propio para guardar tus mediciones.'),
  //                 ),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
/////eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  //     floatingActionButtonLocation:FloatingActionButtonLocation.endDocked,
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         if (pregnancies[0].followers[firebaseuser!.uid] == 'owner' && pregnancies[0].isActive) {
  //           Navigator.pushNamed(context,'MeasurementDialog',arguments: MeasurementDialogArguments(pregnancy: pregnancies[0], birthDate: userModel.birthDate),
  //           );
  //         } else {
  //           showDialog(
  //             context: context,
  //             builder: (_) => const AlertDialog(
  //               title: Text('No se puede registrar'),
  //               content: Text('Debes tener un embarazo propio para guardar tus mediciones.'),
  //             ),
  //           );
  //         }
  //       },
  //       child: const Icon(Icons.create_outlined),
  //     ),
  //   );
  // }

  PreferredSizeWidget _titlebar(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      title: Row(
        children: [
          Text('$selectedPregnancyIndex', style: TextStyle(fontFamily: 'Caveat', fontSize: 22, fontWeight: FontWeight.bold , color: Color(0xffCA3E7F))),
        ],
      ),
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Image(image: AssetImage('assets/img/logo.png')),
      ),
      actions: [
        IconButton(
          tooltip: 'Notificaciones',
          onPressed: () {
            Navigator.pushNamed(context, 'NotificationScreen');
          }, 
          icon: const Icon(Icons.notifications_outlined)
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: PopupMenuButton<String>(
            tooltip: 'Menú de Opciones',
            onSelected: (String value) {
              final messenger = ScaffoldMessenger.of(context);

              switch (value) {
                case 'profile':
                  Navigator.pushNamed(context, 'ProfileScreen');
                  break;
                case 'config':
                  Navigator.pushNamed(context, 'SettingsScreen');
                  break;
                case 'api':
                  Navigator.pushNamed(context, 'APITest');
                  break;
                case 'help':
                  Navigator.pushNamed(context, 'HelpScreen');
                  break;
                case 'signout':
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      final dialognavigator = Navigator.of(dialogContext);
                      return AlertDialog(
                        title: const Text('¿Deseas cerrar sesión?'),
                        content: const Text('Si continuas, se cerrará la sesión de tu cuenta y volverás a la pantalla de inicio.\n\nTendrás que volver a acceder para usar el resto de funciones.'),
                        actions: [
                          ElevatedButton(
                            child: const Text('No, Gracias'),
                            onPressed: () {
                              dialognavigator.pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Acepto'),
                            onPressed: () async {
                              dialognavigator.pop();
                              await Future.delayed(Duration.zero);
                              await AuthService().signout();                              
                            },
                          )
                        ], 
                      );
                    }
                  );
                  break;                
                default:
                  messenger.showSnackBar(
                    SnackBar(content: Text('¡Acción "$value" no existe!'))
                  );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'profile', child: Row(
                children: [Icon(Icons.person_outline), SizedBox(width: 8,), Text('Mi Perfil')],
              )),
              const PopupMenuItem<String>(value: 'config', child: Row(
                children: [Icon(Icons.settings_outlined), SizedBox(width: 8,), Text('Configuración')],
              )),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(value: 'help', child: Row(
                children: [Icon(Icons.help_outline), SizedBox(width: 8,), Text('Ayuda')],
              )),
              const PopupMenuItem<String>(value: 'signout', child: Row(
                children: [Icon(Icons.logout), SizedBox(width: 8,), Text('Cerrar Sesión')],
              )),
            ],
            child: Avatar(),
          ),
        )
      ],
    );
  }


  // Widget _body(BuildContext context) {
  //   // return IndexedStack(
  //   //   index: _selectedIndex,
  //   //   children: _pages.map((item) => item[0] as Widget).toList(),
  //   // );
  //   return ContentScreen();
  // } 

  // Widget _body(BuildContext context) {
  //   return TabBarView(
  //     children: _pages2
  //   );
  // } 

///este es el ultimo no borrar
  // Widget _navbar(BuildContext context) {
  //   return NavigationBar(
  //     selectedIndex: _selectedIndex,
  //     onDestinationSelected: (index) {
  //       if (_selectedIndex != index) {
  //         setState(() => _selectedIndex = index);
  //       }
  //     },
  //     destinations: _pages.map((item) => NavigationDestination(icon: item[2], selectedIcon: item[3], label: item[1])).toList(),
  //   );
  // }
  /// aqui acaba

  // Widget _fab(BuildContext context) {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       showModalBottomSheet(
  //         context: context,
  //         isScrollControlled: true,
  //         //shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
  //         builder: (context) {
  //           return DraggableScrollableSheet(
  //             expand: false,
  //               maxChildSize: 0.9, // Esto da un valor entre 0 y 1
  //             builder: (context, scrollController) {
  //               return MeasurementSheet(scrollController: scrollController);
  //             },
  //           );
  //         }
  //       );
  //     },
  //     child: const Icon(Icons.add),
  //   );
  // }

  // Widget _fab(BuildContext context) {
  //   final userModel = context.watch<UserModel?>();
  //   if (userModel == null) return const SizedBox.shrink();
  //   return FloatingActionButton(

  //     onPressed: () {
  //       final allPregnancies = context.read<List<PregnancyModel>>();
  //       final userModel = context.read<UserModel>();
        
  //       final activePregnancy = allPregnancies.firstWhereOrNull((p) => p.followers[userModel.uid] == 'owner' && p.isActive);

  //       if (activePregnancy != null) {
  //         Navigator.pushNamed(
  //           context,
  //           'MeasurementDialog',
  //           arguments: MeasurementDialogArguments(pregnancy: activePregnancy, birthDate: userModel.birthDate),
  //         );
  //       } else {
  //         showDialog(
  //           context: context,
  //           builder: (_) => const AlertDialog(
  //             title: Text('No se puede registrar'),
  //             content: Text('Debes tener un embarazo activo para registrar mediciones rutinarias.'),
  //           ),
  //         );
  //       }
        
  //     },
  //     child: const Icon(Icons.addchart_outlined),
  //   );
  // }

  Widget _navbar(BuildContext context, List<PregnancyModel> pregnancies, int selectedPregnancyIndex, String uid) {
    return BottomAppBar(
      child: MenuAnchor(
        builder: (context, controller, _) {
          return OutlinedButton.icon(
            icon: Icon(Icons.child_care),
            label: Text('Seleccionar Embarazo'),
            //label: Text(pregnancies[selectedPregnancyIndex].name),
            onPressed: controller.open,
          );
        },
        menuChildren: [
          for (int i = 0; i < pregnancies.length; i++) 
          MenuItemButton(
            leadingIcon: pregnancies[i].followers[uid] == "owner" ? Icon(Icons.person) : null,
            onPressed: () {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Medición guardada sin cálculo de riesgo.'),
                  backgroundColor: Colors.blue,
                ));
                selectedPregnancyIndex = i;
              });
            },
            child: Text(pregnancies[i].name),
          ),
        ],
      ),
    );
  }

  Widget _fab(BuildContext context, List<PregnancyModel> pregnancies, int selectedPregnancyIndex, String uid) {
    final userModel = context.watch<UserModel?>();
    if (userModel == null) return const SizedBox.shrink();

    return FloatingActionButton(
      onPressed: () {
        if (pregnancies[selectedPregnancyIndex].followers[uid] == 'owner' && pregnancies[selectedPregnancyIndex].isActive) {
          Navigator.pushNamed(context,'MeasurementDialog',arguments: MeasurementDialogArguments(pregnancy: pregnancies[selectedPregnancyIndex], birthDate: userModel.birthDate),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text('No se puede registrar'),
              content: Text('Debes tener un embarazo activo para registrar mediciones rutinarias.'),
            ),
          );
        }
      },
      child: const Icon(Icons.add),
    );
  }

  // Widget _fab(BuildContext context) {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       showModalBottomSheet(
  //         context: context,
  //         isScrollControlled: true,
  //         //shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
  //         builder: (context) {
  //           return DraggableScrollableSheet(
  //             expand: false,
  //               maxChildSize: 0.9, // Esto da un valor entre 0 y 1
  //             builder: (context, scrollController) {
  //               return MeasurementSheet(scrollController: scrollController);
  //             },
  //           );
  //         }
  //       );
  //     },
  //     child: const Icon(Icons.add),
  //   );
  // }


PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
    forceMaterialTransparency: true,
    leading: Padding(
      padding: EdgeInsets.all(8),
      child: Image(image: AssetImage('assets/img/logo.png'),fit: BoxFit.contain)
    ),
    title: Text('Mamicheck', style: TextStyle(fontFamily: 'Caveat', color: Color(0xffCA3E7F))),
    actions: [
      IconButton(
        tooltip: 'Notificaciones',
        onPressed: () {
          Navigator.pushNamed(context, 'NotificationScreen');
        }, 
        icon: const Icon(Icons.notifications_outlined)
      ),
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: PopupMenuButton<String>(
          tooltip: 'Menú de Opciones',
          onSelected: (String value) {
            final messenger = ScaffoldMessenger.of(context);

            switch (value) {
              case 'profile':
                Navigator.pushNamed(context, 'ProfileScreen');
                break;
              case 'config':
                Navigator.pushNamed(context, 'SettingsScreen');
                break;
              case 'api':
                Navigator.pushNamed(context, 'APITest');
                break;
              case 'help':
                Navigator.pushNamed(context, 'HelpScreen');
                break;
              case 'signout':
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    final dialognavigator = Navigator.of(dialogContext);
                    return AlertDialog(
                      title: const Text('¿Deseas cerrar sesión?'),
                      content: const Text('Si continuas, se cerrará la sesión de tu cuenta y volverás a la pantalla de inicio.\n\nTendrás que volver a acceder para usar el resto de funciones.'),
                      actions: [
                        ElevatedButton(
                          child: const Text('No, Gracias'),
                          onPressed: () {
                            dialognavigator.pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Acepto'),
                          onPressed: () async {
                            dialognavigator.pop();
                            await Future.delayed(Duration.zero);
                            await AuthService().signout();                              
                          },
                        )
                      ], 
                    );
                  }
                );
                break;                
              default:
                messenger.showSnackBar(
                  SnackBar(content: Text('¡Acción "$value" no existe!'))
                );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'profile', child: Row(
              children: [Icon(Icons.person_outline), SizedBox(width: 8,), Text('Mi Perfil')],
            )),
            const PopupMenuItem<String>(value: 'config', child: Row(
              children: [Icon(Icons.settings_outlined), SizedBox(width: 8,), Text('Configuración')],
            )),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(value: 'help', child: Row(
              children: [Icon(Icons.help_outline), SizedBox(width: 8,), Text('Ayuda')],
            )),
            const PopupMenuItem<String>(value: 'signout', child: Row(
              children: [Icon(Icons.logout), SizedBox(width: 8,), Text('Cerrar Sesión')],
            )),
          ],
          child: Avatar(),
        ),
      )
    ],
  );
}

Widget _buildBottomAppBar(BuildContext context, List<PregnancyModel> pregnancies, String uid) {
final periodOptions = [
  'Ver Todo',
  'Últimos 7 Días',
  'Últimos 30 Días',
  '1er Trimestre',
  '2do Trimestre',
  '3er Trimestre',
];

  return BottomAppBar(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Row(
      children: [
        MenuAnchor(
          builder: (context, controller, _) {
            return ElevatedButton.icon(
              icon: controller.isOpen ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
              label: Text('Monitorear'),
              onPressed: controller.isOpen ? controller.close : controller.open,
            );
          },
          menuChildren: [
            for (int i = 0; i < pregnancies.length; i++) 
            MenuItemButton(
              leadingIcon: pregnancies[i].followers[firebaseuser!.uid] == "owner" && pregnancies[i].isActive ? Icon(Icons.bookmark) : null,
              onPressed: () {
                setState(() {
                  selectedPregnancyIndex = i;
                });
              },
              child: Text(pregnancies[i].name),
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.access_time),
          onSelected: (String newPeriod) {
            setState(() {
              selectedPeriod = newPeriod;
            });
          },
itemBuilder: (context) => periodOptions.map((label) {
  return PopupMenuItem(
    value: label,
    child: Row(
      children: [
        if (selectedPeriod == label) ...[
          Icon(Icons.access_time_filled),
          SizedBox(width: 8),
        ],
        Text(label),
      ],
    ),
  );
}).toList(),
        ),
        IconButton(
          icon: Icon(Icons.share_outlined),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('No se puede registrar'),
                content: Text('Debes tener un embarazo propio para guardar tus mediciones.'),
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildFloatingActionButton(BuildContext context, List<PregnancyModel> pregnancies, UserModel userModel) {
  return FloatingActionButton(
    onPressed: () {
      if (pregnancies[0].followers[userModel.uid] == 'owner') {
        Navigator.pushNamed(
          context,'MeasurementDialog',
          arguments: MeasurementDialogArguments(
            pregnancy: pregnancies[0],
            birthDate: userModel.birthDate,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('No se puede registrar'),
            content: Text('Debes tener un embarazo propio para guardar tus mediciones'),
          ),
        );
      }
    },
    child: Icon(Icons.create_outlined),
  );
}
}