import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens/screens.dart';
import 'package:mamicheckapp/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final firebaseuser = FirebaseAuth.instance.currentUser;

  final List<List<dynamic>> _pages = [
    [NotificacionesPage(), 'Inicio', Icon(Icons.home_outlined), Icon(Icons.home)],
    [ListView.builder(itemCount: 30,itemBuilder: (_, i) => ListTile(title: Text('Item $i')),), 'Historial', Icon(Icons.analytics_outlined), Icon(Icons.analytics)],
    [FeedScreen(), 'Contacto', Icon(Icons.groups_outlined), Icon(Icons.groups)],
    //[Placeholder(), 'Notificaciones', Icon(Icons.settings)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _titlebar(context, firebaseuser),
      drawer: _menu(context, firebaseuser),
      body: _body(context),
      bottomNavigationBar: _navbar(context),
      floatingActionButton: _add(context),
    );
  }

  PreferredSizeWidget _titlebar(BuildContext context, firebaseuser) {
    return AppBar(
      //title: Text(_pages[_selectedIndex][1] as String),
      title: Text('MamiCheck'),
      actions: [
        IconButton(
          onPressed: () {}, 
          icon: const Icon(Icons.notifications)
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              child: Text(firebaseuser.email.toString().isNotEmpty ? firebaseuser.email.toString()[0].toUpperCase() : '??'),
            )
          ),
        )
      ],
    );
  }

  Widget _menu(BuildContext context, firebaseuser) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(firebaseuser.email.toString()),
            accountEmail: Text(firebaseuser.email.toString()),
            currentAccountPicture: CircleAvatar(
              //backgroundImage: AssetImage('assets/profile.jpg'), // Usa NetworkImage si es online
              child: Text(firebaseuser.email.toString().isNotEmpty ? firebaseuser.email.toString()[0].toUpperCase() : '??'),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.medical_services),
            title: Text('Mis Mediciones'),
          ),
          const ListTile(
            leading: Icon(Icons.medical_services),
            title: Text('Mis Mediciones'),
          ),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text('Ayuda'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.local_fire_department),
            title: Text('Probar API'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Sesión'),
            onTap: () async {
              await AuthService().signout();
              Navigator.pushNamedAndRemoveUntil(context, 'LoginScreen', (Route<dynamic> route) => false);
            } 
          ),
        ],
      ),
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
        Navigator.pushNamed(context, 'MyHomePage', arguments: MyHomePageArguments(title: 'fab button'));
      },
      child: const Icon(Icons.add),
    );
  }
}