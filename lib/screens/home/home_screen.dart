import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens/home/avatar.dart';
import 'package:mamicheckapp/screens/screens.dart';
import 'package:mamicheckapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<List<dynamic>> _pages;
  final firebaseuser = FirebaseAuth.instance.currentUser;

  void _changeTab(int newIndex) {
    setState(() {_selectedIndex = newIndex;});
  }

  @override
  void initState() {
    super.initState();

    _pages = [
      [SummaryScreen(onTabChange: _changeTab),'Resumen', Icon(Icons.medical_services_outlined), Icon(Icons.medical_services), 'Resumen'],
      [EvolutionScreen(),'Evolución', Icon(Icons.analytics_outlined), Icon(Icons.analytics), 'Mi Evolución'],
      [AccompanyScreen(),'Seguimiento', Icon(Icons.groups_outlined), Icon(Icons.groups), 'Seguimiento'],
    ];
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);

    return Scaffold(
      appBar: _titlebar(context),
      body: _body(context),
      bottomNavigationBar: _navbar(context),
      floatingActionButton: _fab(context),
    );
  }

  PreferredSizeWidget _titlebar(BuildContext context) {

    return AppBar(
      //backgroundColor: Colors.green,
      forceMaterialTransparency: true,

      // title: Row(
      //   children: [
      //     Image(
      //        image: AssetImage('assets/img/logo.png'),
      //        width: 32,
      //     ),
      //     Text('Mamicheck', 
      //     style: TextStyle(fontFamily: 'Caveat', fontSize: 22, color: Color(0xffCA3E7F))
      //     //style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontFamily: 'Caveat'),
      //     ),
      //   ],
      // ),
      //title: Text(_pages[_selectedIndex][4], style: TextStyle(fontFamily: 'Caveat', fontSize: 42)),
      title: Text('Mamicheck', style: TextStyle(fontFamily: 'Caveat', fontSize: 22, color: Color(0xffCA3E7F))),
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
                              await AuthService().signout();
                              dialognavigator.pop();
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
              const PopupMenuItem<String>(value: 'api', child: Row(
                children: [SizedBox(width: 8,), Text('Prueba de API ML')],
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


  Widget _body(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: _pages.map((item) => item[0] as Widget).toList(),
    );
  } 

  Widget _navbar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        if (_selectedIndex != index) {
          setState(() => _selectedIndex = index);
        }
      },
      destinations: _pages.map((item) => NavigationDestination(icon: item[2], selectedIcon: item[3], label: item[1])).toList(),
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

  Widget _fab(BuildContext context) {
    final userModel = context.watch<UserModel?>();
    final allPregnancies = context.watch<List<PregnancyModel>>();
    if (userModel == null) return const SizedBox.shrink();

    final activePregnancy = allPregnancies.firstWhereOrNull((p) => p.followers[userModel.uid] == 'owner' && p.isActive);

    return FloatingActionButton(
      onPressed: () {
        if (activePregnancy != null) {
          Navigator.pushNamed(context,'MeasurementDialog',arguments: MeasurementDialogArguments(pregnancy: activePregnancy,birthDate: userModel.birthDate),
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

}