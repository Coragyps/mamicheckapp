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
    final owned = context.watch<OwnedPregnancies>().pregnancies;
    final followed = context.watch<FollowedPregnancies>().pregnancies;

    List<PregnancyModel> _filteredPregnancies = _selectedFilter == SummaryFilter.optionA
        ? owned
        : followed;

    return Column(
      children: [
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
            itemCount: _filteredPregnancies.length,
            itemBuilder: (_, index) {
              final pregnancy = _filteredPregnancies[index];
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
      ],
    );
  }
}