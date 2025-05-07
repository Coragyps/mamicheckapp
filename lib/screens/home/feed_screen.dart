import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hello👋'),
    );
  }
}

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Alertas'),
              Tab(text: 'Invitaciones'),
              Tab(text: 'Opiniones'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Placeholder(),
                Placeholder(),
                Placeholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificacionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Personal'),
              Tab(text: 'Seguidos'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Placeholder(),
                ListView.builder(itemCount: 30,itemBuilder: (_, i) => ListTile(title: Text('Item $i')),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}