import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:provider/provider.dart';

class EvolutionScreen extends StatefulWidget {
  const EvolutionScreen({super.key});

  @override
  State<EvolutionScreen> createState() => _EvolutionScreenState();
}

// class _EvolutionScreenState extends State<EvolutionScreen> {
//   int selectedPregnancyIndex = 0;
//   String selectedFilter = 'Todo';

//   final filters = ['Todo', '7 días', '30 días'];

//   @override
//   Widget build(BuildContext context) {
//     final pregnancies = context.watch<List<PregnancyModel>>();
//     if (pregnancies.isEmpty) {
//       return const Center(child: Text('No hay embarazos disponibles.'));
//     }
//     final selectedPregnancy = pregnancies[selectedPregnancyIndex];
//     final now = DateTime.now();
//     final rawMeasurements = selectedPregnancy.measurements
//       ..sort((a, b) => a.date.compareTo(b.date));

//     final filteredMeasurements = selectedFilter == 'Todo'
//         ? rawMeasurements
//         : rawMeasurements.where((m) {
//             final diff = now.difference(m.date).inDays;
//             if (selectedFilter == '7 días') return diff <= 2;
//             if (selectedFilter == '30 días') return diff <= 30;
//             return true;
//           }).toList();

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: DropdownButton<int>(
//                   value: selectedPregnancyIndex,
//                   isExpanded: true,
//                   items: List.generate(
//                     pregnancies.length,
//                     (i) => DropdownMenuItem(
//                       value: i,
//                       child: Text('Embarazo ${i + 1}'),
//                     ),
//                   ),
//                   onChanged: (val) {
//                     if (val != null) {
//                       setState(() {
//                         selectedPregnancyIndex = val;
//                       });
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Wrap(
//                 spacing: 4,
//                 children: filters.map((filter) {
//                   final isSelected = selectedFilter == filter;
//                   return ChoiceChip(
//                     label: Text(filter),
//                     selected: isSelected,
//                     onSelected: (_) {
//                       setState(() {
//                         selectedFilter = filter;
//                       });
//                     },
//                   );
//                 }).toList(),
//               )
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             children: [
//               _buildChartCard(filteredMeasurements),
//               // Puedes añadir más secciones aquí
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChartCard(List<MeasurementModel> measurements) {
//     final hasData = measurements.isNotEmpty;
//     final chartWidth = (measurements.length * 60).toDouble().clamp(300, 1000);

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 0,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Presión Arterial',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             if (!hasData)
//               const SizedBox(
//                 height: 120,
//                 child: Center(
//                   child: Text(
//                     'Aún no se han registrado mediciones para este embarazo.',
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               )
//             else
//               SizedBox(
//                 height: 250,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SizedBox(
//                     width: chartWidth.toDouble(),
//                     child: LineChart(_buildBPChart(measurements)),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   LineChartData _buildBPChart(List<MeasurementModel> data) {
//     final systolicSpots = <FlSpot>[];
//     final diastolicSpots = <FlSpot>[];

//     for (int i = 0; i < data.length; i++) {
//       systolicSpots.add(FlSpot(i.toDouble(), data[i].systolicBP.toDouble()));
//       diastolicSpots.add(FlSpot(i.toDouble(), data[i].diastolicBP.toDouble()));
//     }

//     return LineChartData(
//       minY: 40,
//       maxY: 220,
//       lineTouchData: LineTouchData(
//         touchTooltipData: LineTouchTooltipData(
//           //tooltipBgColor: Colors.black87,
//           fitInsideHorizontally: true,
//           fitInsideVertically: true,
//           //tooltipRoundedRadius: 8,
//           tooltipMargin: 8,
//         ),
//       ),
//       titlesData: FlTitlesData(
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 20,
//             reservedSize: 30,
//             getTitlesWidget: (value, meta) => Text(
//               value.toInt().toString(),
//               style: const TextStyle(fontSize: 10),
//             ),
//           ),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//             interval: 1,
//           ),
//         ),
//         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       ),
//       gridData: FlGridData(show: true),
//       borderData: FlBorderData(
//         show: true,
//         border: const Border(
//           left: BorderSide(),
//           bottom: BorderSide(),
//         ),
//       ),
//       lineBarsData: [
//         LineChartBarData(
//           spots: systolicSpots,
//           isCurved: true,
//           color: Colors.red,
//           barWidth: 2,
//           dotData: FlDotData(show: true),
//         ),
//         LineChartBarData(
//           spots: diastolicSpots,
//           isCurved: true,
//           color: Colors.blue,
//           barWidth: 2,
//           dotData: FlDotData(show: true),
//         ),
//       ],
//     );
//   }
// }

// class _EvolutionScreenState extends State<EvolutionScreen> {
//   int selectedPregnancyIndex = 0;
//   String selectedFilter = 'Todo';

//   final filters = ['Todo', '7 días', '30 días'];

//   @override
//   Widget build(BuildContext context) {
//     final pregnancies = context.watch<List<PregnancyModel>>();
//     if (pregnancies.isEmpty) {
//       return const Center(child: Text('No hay embarazos disponibles.'));
//     }
//     final selectedPregnancy = pregnancies[selectedPregnancyIndex];
//     final now = DateTime.now();
//     final rawMeasurements = selectedPregnancy.measurements
//       ..sort((a, b) => a.date.compareTo(b.date));

//     final filteredMeasurements = selectedFilter == 'Todo'
//         ? rawMeasurements
//         : rawMeasurements.where((m) {
//             final diff = now.difference(m.date).inDays;
//             if (selectedFilter == '7 días') return diff <= 2;
//             if (selectedFilter == '30 días') return diff <= 30;
//             return true;
//           }).toList();

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: DropdownButton<int>(
//                   value: selectedPregnancyIndex,
//                   isExpanded: true,
//                   items: List.generate(
//                     pregnancies.length,
//                     (i) => DropdownMenuItem(
//                       value: i,
//                       child: Text('Embarazo ${i + 1}'),
//                     ),
//                   ),
//                   onChanged: (val) {
//                     if (val != null) {
//                       setState(() {
//                         selectedPregnancyIndex = val;
//                       });
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Wrap(
//                 spacing: 4,
//                 children: filters.map((filter) {
//                   final isSelected = selectedFilter == filter;
//                   return ChoiceChip(
//                     label: Text(filter),
//                     selected: isSelected,
//                     onSelected: (_) {
//                       setState(() {
//                         selectedFilter = filter;
//                       });
//                     },
//                   );
//                 }).toList(),
//               )
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             children: [
//               _buildChartCard(filteredMeasurements),
//               // Puedes añadir más secciones aquí
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChartCard(List<MeasurementModel> measurements) {
//     final hasData = measurements.isNotEmpty;

//     List<charts.Series<MeasurementModel, DateTime>> series = [
//       charts.Series(
//         id: 'Sistólica',
//         colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
//         domainFn: (MeasurementModel m, _) => m.date,
//         measureFn: (MeasurementModel m, _) => m.systolicBP,
//         data: measurements,
//       ),
//       charts.Series(
//         id: 'Diastólica',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (MeasurementModel m, _) => m.date,
//         measureFn: (MeasurementModel m, _) => m.diastolicBP,
//         data: measurements,
//       ),
//     ];

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Presión Arterial',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             if (!hasData)
//               const SizedBox(
//                 height: 120,
//                 child: Center(
//                   child: Text(
//                     'Aún no se han registrado mediciones para este embarazo.',
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               )
//             else
//               SizedBox(
//                 height: 250,
//                 child: charts.TimeSeriesChart(
//                   series,
//                   animate: true,
//                   dateTimeFactory: const charts.LocalDateTimeFactory(),
//                   behaviors: [
//                     charts.SeriesLegend(),
//                     charts.ChartTitle('Fecha',
//                         behaviorPosition: charts.BehaviorPosition.bottom),
//                     charts.ChartTitle('Presión (mmHg)',
//                         behaviorPosition: charts.BehaviorPosition.start),
//                   ],
//                   primaryMeasureAxis: const charts.NumericAxisSpec(
//                     viewport: charts.NumericExtents(50, 200),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _EvolutionScreenState extends State<EvolutionScreen> {
//   int selectedPregnancyIndex = 0;
//   String selectedFilter = 'Todo';

//   final filters = ['Todo', '7 días', '30 días'];

//   @override
//   Widget build(BuildContext context) {
//     final pregnancies = context.watch<List<PregnancyModel>>();
//     if (pregnancies.isEmpty) {
//       return const Center(child: Text('No hay embarazos disponibles.'));
//     }
//     final selectedPregnancy = pregnancies[selectedPregnancyIndex];
//     final now = DateTime.now();
//     final rawMeasurements = selectedPregnancy.measurements
//       ..sort((a, b) => a.date.compareTo(b.date));

//     final filteredMeasurements = selectedFilter == 'Todo'
//         ? rawMeasurements
//         : rawMeasurements.where((m) {
//             final diff = now.difference(m.date).inDays;
//             if (selectedFilter == '7 días') return diff <= 7;
//             if (selectedFilter == '30 días') return diff <= 30;
//             return true;
//           }).toList();

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: DropdownButton<int>(
//                   value: selectedPregnancyIndex,
//                   isExpanded: true,
//                   items: List.generate(
//                     pregnancies.length,
//                     (i) => DropdownMenuItem(
//                       value: i,
//                       child: Text('Embarazo ${i + 1}'),
//                     ),
//                   ),
//                   onChanged: (val) {
//                     if (val != null) {
//                       setState(() {
//                         selectedPregnancyIndex = val;
//                       });
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Wrap(
//                 spacing: 4,
//                 children: filters.map((filter) {
//                   final isSelected = selectedFilter == filter;
//                   return ChoiceChip(
//                     label: Text(filter),
//                     selected: isSelected,
//                     onSelected: (_) {
//                       setState(() {
//                         selectedFilter = filter;
//                       });
//                     },
//                   );
//                 }).toList(),
//               )
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             children: [
//               _buildChartCard(filteredMeasurements),
//               // Puedes añadir más secciones aquí
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChartCard(List<MeasurementModel> measurements) {
//     final hasData = measurements.isNotEmpty;
//     final chartWidth = (measurements.length * 60).toDouble().clamp(300, 1000);

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 0,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Presión Arterial',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 24),
//             if (!hasData)
//               const SizedBox(
//                 height: 120,
//                 child: Center(
//                   child: Text(
//                     'Aún no se han registrado mediciones para este embarazo.',
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               )
//             else
//               SizedBox(
//                 height: 280,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SizedBox(
//                     width: chartWidth.toDouble(),
//                     child: LineChart(_buildBPChart(measurements)),
//                   ),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }

//   LineChartData _buildBPChart(List<MeasurementModel> data) {
//     final systolicSpots = <FlSpot>[];
//     final diastolicSpots = <FlSpot>[];

//     for (int i = 0; i < data.length; i++) {
//       systolicSpots.add(FlSpot(i.toDouble(), data[i].systolicBP.toDouble()));
//       diastolicSpots.add(FlSpot(i.toDouble(), data[i].diastolicBP.toDouble()));
//     }

//     return LineChartData(
//       minY: 40,
//       maxY: 220,
//       lineTouchData: LineTouchData(
//         touchTooltipData: LineTouchTooltipData(
//           //getTooltipColor: GetLineTooltipColor,
//           fitInsideHorizontally: true,
//           fitInsideVertically: true,
//           tooltipBorderRadius: BorderRadius.all(Radius.circular(8)),
//           tooltipMargin: 12,
//           getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
//             final index = spot.x.toInt();
//             final measurement = data[index];
//             final dateStr = '${measurement.date.day}/${measurement.date.month}/${measurement.date.year}';
//             return LineTooltipItem(
//               '${'$dateStr\n\n'}${spot.bar.color == Colors.red ? 'Sistólica' : 'Diastólica'}\n${spot.y.toInt()} mmHg',
//               const TextStyle(color: Colors.white, fontSize: 12),
//             );
//           }).toList(),
//         ),
//       ),
//       titlesData: FlTitlesData(
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 20,
//             reservedSize: 36,
//             getTitlesWidget: (value, meta) => Text(
//               value.toInt().toString(),
//               style: const TextStyle(fontSize: 10),
//             ),
//           ),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//           ),
//         ),
//         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       ),
//       gridData: FlGridData(show: true),
//       borderData: FlBorderData(
//         show: true,
//         border: const Border(
//           left: BorderSide(),
//           bottom: BorderSide(),
//         ),
//       ),
//       lineBarsData: [
//         LineChartBarData(
//           spots: systolicSpots,
//           isCurved: true,
//           color: Colors.red,
//           barWidth: 2,
//           dotData: FlDotData(show: true),
//         ),
//         LineChartBarData(
//           spots: diastolicSpots,
//           isCurved: true,
//           color: Colors.blue,
//           barWidth: 2,
//           dotData: FlDotData(show: true),
//         ),
//       ],
//     );
//   }
// }

class _EvolutionScreenState extends State<EvolutionScreen> {
  int selectedPregnancyIndex = 0;
  String selectedFilter = 'Todo';

  final filters = ['Todo', '7 días', '30 días'];

  @override
  Widget build(BuildContext context) {
    final pregnancies = context.watch<List<PregnancyModel>>();
    if (pregnancies.isEmpty) {
      return const Center(child: Text('No hay embarazos disponibles.'));
    }

    final selectedPregnancy = pregnancies[selectedPregnancyIndex];
    final now = DateTime.now();
    final rawMeasurements = selectedPregnancy.measurements
      ..sort((a, b) => a.date.compareTo(b.date));

    final filteredMeasurements = selectedFilter == 'Todo'
        ? rawMeasurements
        : rawMeasurements.where((m) {
            final diff = now.difference(m.date).inDays;
            if (selectedFilter == '7 días') return diff <= 7;
            if (selectedFilter == '30 días') return diff <= 30;
            return true;
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DropdownButton<int>(
                  value: selectedPregnancyIndex,
                  isExpanded: true,
                  items: List.generate(
                    pregnancies.length,
                    (i) => DropdownMenuItem(
                      value: i,
                      child: Text('Embarazo ${i + 1}'),
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedPregnancyIndex = val;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Wrap(
                spacing: 4,
                children: filters.map((filter) {
                  final isSelected = selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  );
                }).toList(),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _buildChartCard(filteredMeasurements, selectedPregnancy.id),
              _buildRiskPieCard(filteredMeasurements), // Añádelo aquí
              // Puedes añadir más secciones aquí
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(List<MeasurementModel> measurements, String pregnancyId) {
    final hasData = measurements.isNotEmpty;

    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];
    for (int i = 0; i < measurements.length; i++) {
      systolicSpots.add(FlSpot(i.toDouble(), measurements[i].systolicBP.toDouble()));
      diastolicSpots.add(FlSpot(i.toDouble(), measurements[i].diastolicBP.toDouble()));
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Presión Arterial',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (!hasData)
              const SizedBox(
                height: 120,
                child: Center(
                  child: Text(
                    'Aún no se han registrado mediciones para este embarazo.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minY: 40,
                    maxY: 220,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        //tooltipBgColor: Colors.black87,
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            final measurement = measurements[spot.x.toInt()]; // Asegúrate que data[index] sea tu lista original
                            final systolic = measurement.systolicBP;
                            final diastolic = measurement.diastolicBP;
                            final date = measurement.date;
                            final formattedDate = '${date.day}/${date.month}/${date.year}';

                            return LineTooltipItem(          
                              touchedSpots[1]==spot ? 'SYS: $systolic\nDIA: $diastolic' : formattedDate,
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            );


                          }).toList();
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          reservedSize: 36,
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(),
                        bottom: BorderSide(),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: systolicSpots,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 2,
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: diastolicSpots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.circle, color: Colors.red, size: 12),
                  SizedBox(width: 4),
                  Text('Sistólica', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 12),
                  Icon(Icons.circle, color: Colors.blue, size: 12),
                  SizedBox(width: 4),
                  Text('Diastólica', style: TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {Navigator.pushNamed(context, 'MeasurementsScreen', arguments: MeasurementsScreenArguments(pregnancyId: pregnancyId));},
                  icon: const Icon(Icons.list),
                  label: const Text('Ver tabla de Mediciones'),
                ),
              ),
              //const SizedBox(height: 8),
              //Text('Quisit odio, at nobis minima, ullam. Minimaquos, cumque aut velit sunt, animi! Nihiliure, hic tempora amet dolores libero. Hicneque tempora sit, quam eos odit! Laborumanimi, quo, tempora ad tempora animi! Nesciuntsed unde alias unde sit, ad. Aliasdolores rem, in rem, ipsum sed. Temporasunt eveniet nobis amet ullam in. Modiad ullam, vero et amet ut? Sintvitae in, nesciunt, quis nihil eos! '),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskPieCard(List<MeasurementModel> measurements) {
    final riskCounts = <int, int>{0: 0, 1: 0, 2: 0};
    int unmeasured = 0;

    for (var m in measurements) {
      final r = m.riskLevel;
      if (r == 0 || r == 1 || r == 2) {riskCounts[r!] = riskCounts[r]! + 1;} else {unmeasured++;}
    }

    final sections = <PieChartSectionData>[
      PieChartSectionData(
        color: Colors.green,
        value: riskCounts[0]!.toDouble(),
        title: "",
        //title: '${(riskCounts[0]! * 100 / measurements.length).round()}%',
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: riskCounts[1]!.toDouble(),
        title: "",
        //title: '${(riskCounts[1]! * 100 / measurements.length).round()}%',
      ),
      PieChartSectionData(
        color: Colors.red,
        value: riskCounts[2]!.toDouble(),
        title: "",
        //title: '${(riskCounts[2]! * 100 / measurements.length).round()}%',
      ),
      PieChartSectionData(
        color: Colors.blueGrey.shade200,
        value: unmeasured.toDouble(),
        title: "",
        //title: '${(unmeasured * 100 / measurements.length).round()}%',
      ),
    ];

    // return Card(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   elevation: 0,
    //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Row(
    //       children: [
    //         SizedBox(
    //           width: 200,
    //           height: 200,
    //           child: PieChart(
    //             PieChartData(
    //               sections: sections,
    //               sectionsSpace: 2,
    //               centerSpaceRadius: 26,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(width: 16),
    //         Expanded(
    //           child: Wrap(
    //             spacing: 8,
    //             runSpacing: 4,
    //             children: legends.map((item) {
    //               return Chip(
    //                 backgroundColor: item['color'] as Color,
    //                 label: Text(
    //                   '${item['label']} (${item['count']})',
    //                   style: const TextStyle(color: Colors.white),
    //                 ),
    //               );
    //             }).toList(),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nivel de Riesgo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 24,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildRiskChip('Alto', Colors.red, riskCounts[2]!),
                      _buildRiskChip('Moderado', Colors.orange, riskCounts[1]!),
                      _buildRiskChip('Bajo', Colors.green, riskCounts[0]!),
                      _buildRiskChip('Sin medir', Colors.blueGrey, unmeasured),
                    ],
                  ),
                ),
              ],
            ),
            //const SizedBox(height: 12),
            //Text('Quisit odio, at nobis minima, ullam. Minimaquos, cumque aut velit sunt, animi! Nihiliure, hic tempora amet dolores libero. Hicneque tempora sit, quam eos odit! Laborumanimi, quo, tempora ad tempora animi! Nesciuntsed unde alias unde sit, ad. Aliasdolores rem, in rem, ipsum sed. Temporasunt eveniet nobis amet ullam in. Modiad ullam, vero et amet ut? Sintvitae in, nesciunt, quis nihil eos! '),
          ],
        ),
      ),
    );
  }
  Widget _buildRiskChip(String label, Color color, int count) {
  return Chip(
    avatar: CircleAvatar(backgroundColor: color, radius: 5),
    label: Text('$label ($count)'),
    labelStyle: const TextStyle(fontSize: 11),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
}