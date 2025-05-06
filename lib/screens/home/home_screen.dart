import 'package:flutter/material.dart';
import 'package:mamicheckapp/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<List<dynamic>> _pages = [
    [FeedScreen(), 'Inicio', Icon(Icons.home)],
    [Placeholder(), 'Historial', Icon(Icons.person)],
    [Placeholder(), 'Notificaciones', Icon(Icons.settings)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _titlebar(context),
      drawer: _menu(context),
      body: _body(context),
      bottomNavigationBar: _navbar(context),
    );
  }

  PreferredSizeWidget _titlebar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(_pages[_selectedIndex][1] as String)
    );
  }

  Widget _menu(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(child: Text('data')),
          ListTile(title: Text('data1'),)
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
      destinations: _pages.map((item) => NavigationDestination(icon: item[2], label: item[1])).toList(),
    );
  }
}