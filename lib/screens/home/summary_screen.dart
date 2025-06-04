import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:provider/provider.dart';

enum SummaryFilter { optionA, optionB }

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

// class _SummaryScreenState extends State<SummaryScreen> {
//   SummaryFilter _selectedFilter = SummaryFilter.optionA;

//   List<int> get _filteredItems {
//     final allItems = List<int>.generate(5, (index) => index);
//     return _selectedFilter == SummaryFilter.optionA
//         ? allItems.where((i) => i % 2 == 0).toList() 
//         : allItems.where((i) => i % 2 != 0).toList();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Text('Resumen de los embarazos asociados'),
//               ),
//               const SizedBox(width: 12),
//               SegmentedButton<SummaryFilter>(
//                 segments: const [
//                   ButtonSegment(
//                     value: SummaryFilter.optionA,
//                     label: Text('Míos'),
//                   ),
//                   ButtonSegment(
//                     value: SummaryFilter.optionB,
//                     label: Text('Otros'),
//                   ),
//                 ],
//                 selected: {_selectedFilter},
//                 onSelectionChanged: (Set<SummaryFilter> newSelection) {
//                   setState(() {
//                     _selectedFilter = newSelection.first;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: _filteredItems.length,
//             itemBuilder: (_, index) {
//               final i = _filteredItems[index];
//               return Card(
//                 //margin: const EdgeInsets.only(bottom: 16),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       title: Text('Bebé de $i$i$i'),
//                       subtitle: Text('$i semanas'),
//                       leading: const Image(
//                         image: AssetImage('assets/img/logo.png'),
//                         width: 40,
//                         height: 40,
//                       ),
//                     ),
//                     const SizedBox(height: 500),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }


class _SummaryScreenState extends State<SummaryScreen> {
  SummaryFilter _selectedFilter = SummaryFilter.optionA;

  @override
  Widget build(BuildContext context) {
    // final owned = context.watch<OwnedPregnancies>().pregnancies;
    // final followed = context.watch<FollowedPregnancies>().pregnancies;

    // List<PregnancyModel> filteredPregnancies = _selectedFilter == SummaryFilter.optionA
    //     ? owned
    //     : followed;

    final uid = context.read<User>().uid;
    final allPregnancies = context.watch<List<PregnancyModel>>();

    final owned = allPregnancies.where((p) => p.followers.isNotEmpty && p.followers.first == uid).toList();
    final followed = allPregnancies.where((p) => p.followers.isNotEmpty && p.followers.first != uid).toList();

    //final owned = allPregnancies.where((p) => p.ownerId == user.uid).toList();
    //final followed = allPregnancies.where((p) => p.ownerId != user.uid).toList();

    owned.sort((a, b) => b.isActive.toString().compareTo(a.isActive.toString()));
    followed.sort((a, b) => b.isActive.toString().compareTo(a.isActive.toString()));

    final filteredPregnancies = _selectedFilter == SummaryFilter.optionA ? owned : followed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Seguimiento', style: TextStyle(fontFamily: 'Caveat', fontSize: 42)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: Text('Resumen de los embarazos asociados')),
              const SizedBox(width: 12),
              SegmentedButton<SummaryFilter>(
                segments: const [
                  ButtonSegment(value: SummaryFilter.optionA, label: Text('Míos')),
                  ButtonSegment(value: SummaryFilter.optionB, label: Text('Otros')),
                ],
                selected: {_selectedFilter},
                onSelectionChanged: (Set<SummaryFilter> newSelection) {
                  setState(() {
                    _selectedFilter = newSelection.first;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredPregnancies.length,
            itemBuilder: (_, index) {
              final pregnancy = filteredPregnancies[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    pregnancy.toMap().toString(),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final uid = context.read<User>().uid;
            final allPregnancies = context.read<List<PregnancyModel>>();

            final owned = allPregnancies
                .where((p) => p.followers.isNotEmpty && p.followers.first == uid)
                .toList();

            final canCreate = owned.isEmpty || owned.every((p) => !p.isActive);

            if (canCreate) {
              Navigator.pushNamed(context, 'PregnancyDialog');
            } else {
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text('No puedes crear un nuevo embarazo'),
                  content: Text('Debes finalizar el embarazo activo antes de crear uno nuevo.'),
                ),
              );
            }
          },
          child: const Text('Crear embarazo'),
        )
      ],
    );
  }
}