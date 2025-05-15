import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Mi Embarazo'),
              Tab(text: 'Siguiendo'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _personal(context),
                _seguidos(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _personal(BuildContext context) {
    return Placeholder();
  }

  Widget _seguidos(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (_, i) => ListTile(
        title: Text('Item $i'),
      ),
    );
  }
}