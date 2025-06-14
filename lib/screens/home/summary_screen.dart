import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:provider/provider.dart';

enum SummaryFilter { optionA, optionB }

class SummaryScreen extends StatefulWidget {
  final void Function(int) onTabChange;
  const SummaryScreen({super.key, required this.onTabChange});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

// class _SummaryScreenState extends State<SummaryScreen> {
//   SummaryFilter _selectedFilter = SummaryFilter.optionA;

//   @override
//   Widget build(BuildContext context) {
//     final userModel = context.watch<UserModel?>();
//     final allPregnancies = context.watch<List<PregnancyModel>>();

//     if (userModel == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final owned = allPregnancies
//       .where((p) => p.followers[userModel.uid] == 'owner')
//       .toList()
//       ..sort((a, b) => b.isActive.toString().compareTo(a.isActive.toString()));

//     final followed = allPregnancies
//       .where((p) => p.followers[userModel.uid] == 'companion')
//       .toList()
//       ..sort((a, b) => b.isActive.toString().compareTo(a.isActive.toString()));

//     final filteredPregnancies =
//         _selectedFilter == SummaryFilter.optionA ? owned : followed;
//     final canCreatePregnancy =
//         owned.isEmpty || owned.every((p) => !p.isActive);

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             Text('Seguimiento',
//                 style: TextStyle(fontFamily: 'Caveat', fontSize: 42)),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 const Expanded(
//                     child: Text('Resumen de los embarazos asociados')),
//                 const SizedBox(width: 12),
//                 SegmentedButton<SummaryFilter>(
//                   segments: const [
//                     ButtonSegment(value: SummaryFilter.optionA, label: Text('Míos')),
//                     ButtonSegment(value: SummaryFilter.optionB, label: Text('Otros')),
//                   ],
//                   selected: {_selectedFilter},
//                   onSelectionChanged: (Set<SummaryFilter> newSelection) {
//                     setState(() {
//                       _selectedFilter = newSelection.first;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Crear embarazo (si aplica)
//             if (_selectedFilter == SummaryFilter.optionA && canCreatePregnancy)
//               Card(
//                 //color: Colors.pink,
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 12),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.info_outline),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               '¿Aún no tienes un embarazo activo?',
//                               style: TextStyle(fontWeight: FontWeight.bold),                        
//                             ),
//                             const SizedBox(height: 4),
//                             const Text('Puedes iniciar uno nuevo para hacer seguimiento.'),
//                             const SizedBox(height: 8),
//                             FilledButton.icon(
//                               icon: const Icon(Icons.playlist_add),
//                               label: const Text('Registrar mi Embarazo'),
//                               onPressed: () {
//                                 Navigator.pushNamed(context, 'PregnancyDialog', arguments: PregnancyDialogArguments(uid: userModel.uid, firstName: userModel.firstName, birthDate: userModel.birthDate));
//                               },
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   )
//                 ),
//               ),
//             ...filteredPregnancies.map(
//               (pregnancy) => Card(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         pregnancy.toMap().toString(),
//                         style: const TextStyle(fontFamily: 'monospace'),
//                       ),
//                       const SizedBox(height: 8),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton.icon(
//                           onPressed: () {
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(
//                             //     builder: (_) => MeasurementsScreen(pregnancyId: pregnancy.id),
//                             //   ),
//                             // );

//                             Navigator.pushNamed(context, 'MeasurementsScreen', arguments: MeasurementsScreenArguments(pregnancyId: pregnancy.id));

//                           },
//                           icon: const Icon(Icons.list),
//                           label: const Text('Ver todos los registros'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Si no hay seguidos (acompañar)
//             if (_selectedFilter == SummaryFilter.optionB && followed.isEmpty)
//               Card(
//                 //color: Colors.amber,
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 12),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.info_outline),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               '¿Quieres acompañar un embarazo?',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 4),
//                             const Text('Puedes ingresar el ID en la pestaña de Acompañar.'),
//                             const SizedBox(height: 8),
//                             FilledButton.icon(
//                               icon: const Icon(Icons.open_in_new),
//                               label: const Text('Ir a Acompañar'),
//                               onPressed: () {
//                                 widget.onTabChange(2); // Cambio a pestaña de Acompañar
//                               },
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   )
//                 ),
//               ),

//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final allPregnancies = context.watch<List<PregnancyModel>>();
    final userModel = context.watch<UserModel?>();

    if (userModel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Clasificación
    final ownedActive = allPregnancies.where((p) => p.followers[userModel.uid] == 'owner' && p.isActive).toList();
    final followedActive = allPregnancies.where((p) => p.followers[userModel.uid] == 'companion' && p.isActive).toList();
    final finalizados = allPregnancies.where((p) => !p.isActive).toList();

    // Construir páginas ordenadas
    final pages = <Widget>[
      ...ownedActive.map(_pregnancyPage),
      ...followedActive.map(_pregnancyPage),
    ];

    final noOwn = ownedActive.isEmpty;
    final noFollowed = followedActive.isEmpty;
    final noActive = ownedActive.isEmpty && followedActive.isEmpty;

    // Insertar sugerencias justo antes de los finalizados
    if (noOwn || noFollowed || noActive) {
      pages.add(_suggestionsPage(
        showCreate: noOwn || noActive,
        showJoin: noFollowed || noActive,
        uid: userModel.uid,
        firstName: userModel.firstName,
        birthDate: userModel.birthDate,
      ));
    }

    pages.addAll(finalizados.map(_pregnancyPage));

    return PageView(
      scrollDirection: Axis.vertical,
      children: pages,
    );
  }

  Widget _pregnancyPage(PregnancyModel pregnancy) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pregnancy.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Semanas de embarazo: ${(DateTime.now().difference(pregnancy.lastMenstrualPeriod).inDays / 7).floor()} Semanas',),
              const SizedBox(height: 8),
              Text('Estado: ${pregnancy.isActive ? "Activo" : "Finalizado"}'),
              const SizedBox(height: 8),
              Text('Cant. de Mediciones: ${pregnancy.measurements.length}'),
              const SizedBox(height: 8),
              Text('Factores de Riesgo: ${pregnancy.riskFactors}'),
              const SizedBox(height: 8),
              Text('Seguimiento: ${pregnancy.followers.length} personas'),
              // Puedes añadir más detalles
            ],
          ),
        ),
      ),
    );
  }

  Widget _suggestionsPage({required bool showCreate, required bool showJoin, required String uid, required String firstName, required DateTime birthDate}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showCreate)
              _suggestionCard(
                title: '¿Tienes un embarazo activo?',
                description: 'Has seguimiento continuo a tu salud registrando tus datos.',
                button: FilledButton.icon(
                  icon: const Icon(Icons.playlist_add),
                  label: const Text('Registrar mi Embarazo'),
                  onPressed: () {
                    Navigator.pushNamed(context, 'PregnancyDialog', arguments: PregnancyDialogArguments(uid: uid, firstName: firstName, birthDate: birthDate));
                  },
                )
              ),
            if (showJoin)
              _suggestionCard(
                title: '¿Buscas monitorear un embarazo?',
                description: 'Utiliza el código que te compartió la gestante.',
                button: FilledButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Ir a Seguimiento'),
                  onPressed: () {
                    widget.onTabChange(2); // Cambio a pestaña de Acompañar
                  },
                )
              ),
          ],
        ),
      ),
    );
  }

  Widget _suggestionCard({required String title, required String description, required FilledButton button}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 32,color: Colors.purple,),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  //const Text('¿Quieres acompañar un embarazo?', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description),
                  //const Text('Puedes ingresar el ID en la pestaña de Acompañar.'),
                  const SizedBox(height: 8),
                  button
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}