import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens/screens.dart';
import 'package:mamicheckapp/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final firebaseuser = FirebaseAuth.instance.currentUser;

  final List<List<dynamic>> _pages = [
    [FeedScreen(), 'Embarazos', Icon(Icons.home_outlined), Icon(Icons.home)],
    [TrackingScreen(), 'Evolución', Icon(Icons.analytics_outlined), Icon(Icons.analytics)],
    [ContactScreen(), 'Acompañar', Icon(Icons.groups_outlined), Icon(Icons.groups)],
  ];

  MaterialColor _profileColor(String email) {
    final hash = email.hashCode;
    return Colors.primaries[hash.abs() % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _titlebar(context, firebaseuser),
      body: _body(context),
      bottomNavigationBar: _navbar(context),
      floatingActionButton: _add(context),
    );
  }

  PreferredSizeWidget _titlebar(BuildContext context, firebaseuser) {
    final email = firebaseuser.email.toString().isNotEmpty ? firebaseuser.email.toString()[0].toUpperCase()+firebaseuser.email.toString()[1] : '??';
    final baseColor = _profileColor(email);

    return AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            color: Colors.red, // Placeholder: cuadrado rojo
          ),
          const SizedBox(width: 8),
          Text('Mamicheck', style: GoogleFonts.caveat(),),
        ],
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
              switch (value) {
                case 'profile':
                  Navigator.pushNamed(context, 'MyHomePage', arguments: MyHomePageArguments(title: value));
                  break;
                case 'config':
                  Navigator.pushNamed(context, 'SettingsScreen');
                  break;
                case 'api':
                  Navigator.pushNamed(context, 'APITest');
                  break;
                case 'measurements':
                  Navigator.pushNamed(context, 'MeasurementScreen');
                  break;
                case 'pregnancies':
                  Navigator.pushNamed(context, 'PregnancyScreen');
                  break;
                case 'help':
                  Navigator.pushNamed(context, 'MyHomePage', arguments: MyHomePageArguments(title: value));
                  break;
                case 'signout':
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('¿Deseas cerrar sesión?'),
                        content: const Text('Si continuas, se cerrará la sesión de tu cuenta y volverás a la pantalla de inicio.\n\nTendrás que volver a acceder para usar el resto de funciones.'),
                        actions: [
                          ElevatedButton(
                            child: const Text('No, Gracias'),
                            onPressed: () {Navigator.of(context).pop();},
                          ),
                          TextButton(
                            child: const Text('Acepto'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await AuthService().signout();
                              Navigator.pushNamedAndRemoveUntil(context, 'LoginScreen', (_) => false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Acción "$value" no existe!'), behavior: SnackBarBehavior.floating,),
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
              const PopupMenuItem<String>(value: 'measurements', child: Row(
                children: [Icon(Icons.monitor_heart_outlined), SizedBox(width: 8,), Text('Todas las Mediciones')],
              )),
              const PopupMenuItem<String>(value: 'pregnancies', child: Row(
                children: [Icon(Icons.monitor_heart_outlined), SizedBox(width: 8,), Text('Todos los Embarazos')],
              )),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(value: 'help', child: Row(
                children: [Icon(Icons.help_outline), SizedBox(width: 8,), Text('Ayuda')],
              )),
              const PopupMenuItem<String>(value: 'signout', child: Row(
                children: [Icon(Icons.logout), SizedBox(width: 8,), Text('Cerrar Sesión')],
              )),
            ],
            child: CircleAvatar(
              backgroundColor: baseColor.shade900,
              child: Text(email, style: TextStyle(color: baseColor.shade100),),
            ),
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
        if (_selectedIndex != index) {setState(() => _selectedIndex = index);}
      },
      destinations: _pages.map((item) => NavigationDestination(icon: item[2], selectedIcon: item[3], label: item[1])).toList(),
    );
  }

  Widget _add(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, 'AddScreen');
      },
      child: const Icon(Icons.add),
    );
  }
}