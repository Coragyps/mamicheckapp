import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/screens/form/measurement_sheet.dart';
import 'package:provider/provider.dart';

class MeasurementsScreen extends StatefulWidget {
  final String pregnancyId;

  const MeasurementsScreen({super.key, required this.pregnancyId});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final pregnancy = context.watch<List<PregnancyModel>>().firstWhere(
      (p) => p.id == widget.pregnancyId,
      orElse: () => throw Exception('Embarazo no encontrado'),
    );
    final measurements = pregnancy.measurements;

      return Scaffold(
        appBar: AppBar(title: const Text('Tabla de Mediciones')),
        body: _body(measurements),
        //floatingActionButton: _fab(context,pregnancy.id),
        bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.task_outlined),
                  onPressed: () {},
                  label: const Text('Exportar a PDF'),
                ),
              ],
            ),
        ),
      );
  }

  Widget _body(List<MeasurementModel> measurements) {
    List<MeasurementModel> sorted = List.of(measurements);
    if (_sortColumnIndex != null) {
      sorted.sort((a, b) {
        int compare<T extends Comparable>(T aVal, T bVal) =>
            _sortAscending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
        switch (_sortColumnIndex) {
          case 0: return compare(a.date, b.date);
          case 1: return compare(a.systolicBP, b.systolicBP);
          case 2: return compare(a.diastolicBP, b.diastolicBP);
          case 3: return compare(a.heartRate, b.heartRate);
          case 4: return compare(a.age, b.age);
          case 5: return compare(a.bloodSugar ?? -1, b.bloodSugar ?? -1);
          case 6: return compare(a.temperature ?? -1.0, b.temperature ?? -1.0);
          case 7: return compare(a.riskLevel ?? -1, b.riskLevel ?? -1);
          case 8: return compare(a.notes ?? '', b.notes ?? '');
          default: return 0;
        }
      });
    }

    return measurements.isEmpty 
    ? const Center(child: Text('No hay mediciones registradas.'))
    : SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Resumen de mediciones recientes. Toca los encabezados para ordenar.'),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columnSpacing: 24,
              dataRowMaxHeight: 60,
              columns: [
                _buildSortableColumn('Fecha', 0),
                _buildSortableColumn('PA Sist.', 1),
                _buildSortableColumn('PA Diast.', 2),
                _buildSortableColumn('Pulso', 3),
                _buildSortableColumn('Edad', 4),
                _buildSortableColumn('Glucosa', 5),
                _buildSortableColumn('Temp.', 6),
                _buildSortableColumn('Riesgo', 7),
                _buildSortableColumn('Notas', 8),
              ],
              rows: sorted.map((m) {
                return DataRow(cells: [
                  DataCell(_formatDate(m.date)),
                  DataCell(Text('${m.systolicBP}')),
                  DataCell(Text('${m.diastolicBP}')),
                  DataCell(Text('${m.heartRate}')),
                  DataCell(Text('${m.age}')),
                  DataCell(Text(m.bloodSugar?.toString() ?? '-')),
                  DataCell(Text(m.temperature?.toString() ?? '-')),
                  //_riskCell(m.riskLevel),
                  //_riskCell(measurements, m),
                  // DataCell(
                  //   showEditIcon: m.riskLevel == null ? true : false,
                  //   m.riskLevel != null
                  //   ? Chip(label: Text(['Baja', 'Media', 'Alta'][m.riskLevel!]), backgroundColor: [Colors.green[200], Colors.orange[200], Colors.red[200]][m.riskLevel!])
                  //   : const Text('Editar'),
                  // ),
                  if (m.riskLevel != null) 
                    DataCell(Chip(label: Text(['Baja', 'Media', 'Alta'][m.riskLevel!]), backgroundColor: [Colors.green[200], Colors.orange[200], Colors.red[200]][m.riskLevel!])) else
                    DataCell(
                      const Text('Editar'),
                      showEditIcon: true,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              maxChildSize: 0.9,
                              builder: (context, scrollController) {
                                return MeasurementSheet(
                                  scrollController: scrollController,
                                  measurement: m,
                                  measurements: measurements,
                                  pregnancyId: widget.pregnancyId
                                );
                              }
                            );
                          },
                        );
                      },
                    ),
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Text(
                        m.notes ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataColumn _buildSortableColumn(String label, int index) {
    return DataColumn(
      label: Text(label),
      onSort: (columnIndex, ascending) {
        setState(() {
          _sortColumnIndex = columnIndex;
          _sortAscending = ascending;
        });
      },
    );
  }

  Text _formatDate(DateTime date) {
    return Text('${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}\n${date.day}/${date.month}/${date.year}');
  }

  // Widget _fab(BuildContext context, String pregnancyId) {
  //   final userModel = context.watch<UserModel?>();
  //   final activePregnancy = context.watch<List<PregnancyModel>>().firstOrNull;
  //   //final allPregnancies = context.watch<List<PregnancyModel>>();
  //   if (userModel == null) return const SizedBox.shrink();

  //   //final activePregnancy = allPregnancies.firstOrNull;
  //   //final activePregnancy = allPregnancies.firstWhereOrNull((p) => p.followers[userModel.uid] == 'owner' && p.isActive);
  //   return FloatingActionButton(
  //     onPressed: () {
  //       if (activePregnancy != null && activePregnancy.followers[userModel.uid] == 'owner' && activePregnancy.isActive) {
  //         Navigator.pushNamed(context,'MeasurementDialog',arguments: MeasurementDialogArguments(pregnancy: activePregnancy,birthDate: userModel.birthDate));
  //         // if (activePregnancy.id != pregnancyId) {
  //         //   showDialog(
  //         //     context: context, 
  //         //     builder: (_) => AlertDialog(
  //         //       title: Text('No tienes acceso a este Embarazo'),
  //         //       content: Text('Unicamente puedes registrar mediciones en tu propio embarazo que este activo'),
  //         //       actions: [
  //         //         ElevatedButton(
  //         //           child: const Text('OK'),
  //         //           onPressed: () async {
  //         //             Navigator.pushNamed(context,'MeasurementDialog',arguments: MeasurementDialogArguments(pregnancy: activePregnancy,birthDate: userModel.birthDate));                            
  //         //           },
  //         //         )
  //         //       ], 
  //         //     ),
  //         //   );
  //         // } else {
  //         //   Navigator.pushNamed(context,'MeasurementDialog',arguments: MeasurementDialogArguments(pregnancy: activePregnancy,birthDate: userModel.birthDate));
  //         // }
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
  //     child: const Icon(Icons.add),
  //   );
  // }

  // DataCell _riskCell(int? level) {
  //   switch (level) {
  //     case 0:
  //       return DataCell(Chip(label: Text('Baja'), backgroundColor: Colors.green[200]));
  //     case 1:
  //       return DataCell(Chip(label: Text('Medio'), backgroundColor: Colors.orange[200]));
  //     case 2:
  //       return DataCell(Chip(label: Text('Alta'), backgroundColor: Colors.red[200]));
  //     default:
  //       return DataCell(Text('Editar'), showEditIcon: true, onTap: () {
  //         showModalBottomSheet(
  //           context: context,
  //           isScrollControlled: true,
  //           builder: (context) {
  //             return DraggableScrollableSheet(
  //               expand: false,
  //               maxChildSize: 0.9,
  //               builder: (context, scrollController) {
  //                 return MeasurementSheet(scrollController: scrollController);
  //               }
  //             );
  //           }
  //         );
  //       },
  //     );
  //   }
  // }
  ///-----------------------------------------------------
  // DataCell _riskCell(PregnancyModel pregnancy, MeasurementModel m) {
  //   final incompletos = <String>[];
  //   if (m.bloodSugar == null) incompletos.add('Glucosa');
  //   if (m.temperature == null) incompletos.add('Temperatura');
  //   if (m.riskLevel == null) incompletos.add('Riesgo');

  //   final hayFaltantes = incompletos.isNotEmpty;

  //   if (hayFaltantes) {
  //     return DataCell(
  //       Text('Completar'),
  //       showEditIcon: true,
  //       onTap: () {
  //         showModalBottomSheet(
  //           context: context,
  //           isScrollControlled: true,
  //           backgroundColor: Colors.transparent,
  //           builder: (context) {
  //             return DraggableScrollableSheet(
  //               expand: false,
  //               maxChildSize: 0.9,
  //               builder: (context, scrollController) {
  //                 return MeasurementSheet(
  //                   scrollController: scrollController,
  //                   measurement: m,
  //                   onSave: (updated) async {
  //                     // Actualiza el documento en Firestore o localmente
  //                     await MeasurementService().editMeasurement(pregnancy, updated);
  //                     setState(() {}); // Forzar reconstrucción si es necesario
  //                   },
  //                 );
  //               },
  //             );
  //           },
  //         );
  //       },
  //     );
  //   }

  //   switch (m.riskLevel) {
  //     case 0:
  //       return DataCell(Chip(label: Text('Baja'), backgroundColor: Colors.green[200]));
  //     case 1:
  //       return DataCell(Chip(label: Text('Medio'), backgroundColor: Colors.orange[200]));
  //     case 2:
  //       return DataCell(Chip(label: Text('Alta'), backgroundColor: Colors.red[200]));
  //     default:
  //       return DataCell(Text('-'));
  //   }
  // }
}