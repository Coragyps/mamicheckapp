import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/navigation/arguments.dart';

class ContentScreen extends StatefulWidget {
  final PregnancyModel pregnancy;
  final String uid;
  final String firstName;
  final DateTime birthDate;
  final String selectedPeriod;
  final List<MeasurementModel> filteredMeasurements;
  const ContentScreen({super.key, required this.pregnancy, required this.uid, required this.firstName, required this.birthDate, required this.selectedPeriod, required this.filteredMeasurements});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late final List<MeasurementModel> filteredMeasurements;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text(widget.pregnancy.name, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontFamily: 'caveat', color: Theme.of(context).colorScheme.onPrimaryFixed)),
          ),
          // Row(
          //   children: [
          //     OutlinedButton(
          //       style: OutlinedButton.styleFrom(
          //         minimumSize: Size.zero,
          //         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          //       ),
          //       onPressed: () {},
          //       child: Text('Ver todos los Seguidores')
          //     ),
          //   ],
          // ),
          //_buildHeading(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       SizedBox(height: 15),
          //       Text('Indicadores',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
          //     ],
          //   ),
          // ),
          SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Indicadores',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   child: Text('¡Mantener un ojo en estos números te ayuda a cuidar mejor de ti y de tu bebé!'),
          // ),
          SizedBox(height: 8),
          _buildKpiCarrousel(),
          // const SizedBox(height: 16),
          // Divider(),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Evolución de Presión Arterial',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('¡Observar estas tendencias es clave para entender cómo responde tu cuerpo y si necesitas ajustar algo con la ayuda de tu médico!'),
          ),
          const SizedBox(height: 8),
          _buildChartCard(widget.filteredMeasurements, widget.pregnancy.id),
          SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Perfil de Riesgo al Detalle',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Podrías descubrir patrones semanales que te ayuden a identificar qué influye en tus lecturas'),
          ),
          const SizedBox(height: 8),
          _buildGraphCarrousel(widget.filteredMeasurements),
          SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Adherencia al Monitoreo por Semana',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('¿En que horas suelo realizar más mediciones?'),
          ),
          buildRiskHeatmapCard(widget.filteredMeasurements, widget.pregnancy.lastMenstrualPeriod, widget.selectedPeriod),
          SizedBox(height: 24),
          Divider(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Mas Opciones',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   child: Text('Encuentra Telefonos de Contacto y mas configuraciones'),
          // ),          
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {Navigator.pushNamed(context, 'MeasurementsScreen', arguments: MeasurementsScreenArguments(pregnancyId: widget.pregnancy.id));},
              icon: const Icon(Icons.list),
              label: const Text('Ver tabla de Mediciones'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.pregnancy.name, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontFamily: 'caveat', color: Theme.of(context).colorScheme.onPrimaryFixed)),
        //Text('Embarazo Archivado', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.blueGrey)),
        SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.all(8),
              ),
              onPressed: () {},
              child: Text('Ver todos')
            ),
        // Text('Seguidores',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
        // Row(
        //   children: List.generate(2, (i) {
        //     return Padding(
        //         padding: EdgeInsets.only(right: 4),
        //         child: CircleAvatar(radius: 18, child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary)));
        //   })..add(
        //     // IconButton.filled(
        //     //   onPressed: () {}, 
        //     //   icon: Icon(Icons.abc),
        //     // )
        //     OutlinedButton(
        //       style: OutlinedButton.styleFrom(
        //         minimumSize: Size.zero,
        //         padding: EdgeInsets.all(8),
        //       ),
        //       onPressed: () {},
        //       child: Text('Ver todos')
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildKpiCarrousel(){
    return SizedBox(
      height: 90,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, i) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 4),
            elevation: 0,
            color: Theme.of(context).colorScheme.secondaryFixed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ['Tiempo de\nEmbarazo','Total de\nMediciones', 'Tu Última\nRacha', 'Último Riesgo\nCalculado', 'Factores de\nRiesgo'][i],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed),
                    textAlign: TextAlign.center,
                  ),
                  Chip(
                    label: Text([
                      'Semana ${DateTime.now().difference(widget.pregnancy.lastMenstrualPeriod).inDays ~/ 7}',
                      widget.filteredMeasurements.length.toString() ?? '',
                      '4 Dias', 
                      widget.filteredMeasurements.isNotEmpty
                      ? ['Bajo', 'Moderado', 'Alto', 'Sin Medir'][widget.filteredMeasurements.last?.riskLevel ?? 3]
                      : 'Sin Medir',
                      widget.pregnancy.riskFactors!.length.toString()][i], 
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.onPrimaryFixed),),
                  )                
                ],
              ),
            ),
          );
        },
      ),
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
      color: Theme.of(context).colorScheme.surface,
      //color: Theme.of(context).colorScheme.onPrimaryFixed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!hasData)
              const SizedBox(
                height: 120,
                child: Center(
                  child: Text('Aún no se han registrado mediciones para este embarazo.', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
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
                        getTooltipColor: (_) => Theme.of(context).colorScheme.primary,
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            final measurement = measurements[spot.x.toInt()]; // Asegúrate que data[index] sea tu lista original
                            final systolic = measurement.systolicBP;
                            final diastolic = measurement.diastolicBP;
                            final date = measurement.date;
                            final formattedDate = '${date.day}/${date.month}/${date.year}';
                            return LineTooltipItem(          
                              touchedSpots[1]==spot ? 'Sistólica: $systolic\nDiastólica: $diastolic' : formattedDate,
                              TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14)
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
                          reservedSize: 30,
                          getTitlesWidget: (value, _) => Text(value.toInt().toString(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed)),
                        ),
                      ),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(left: BorderSide(), bottom: BorderSide() ),
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
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 12),
                    SizedBox(width: 4),
                    Text('Sistólica', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed)),
                    SizedBox(width: 30),
                    Icon(Icons.circle, color: Colors.blue, size: 12),
                    SizedBox(width: 4),
                    Text('Diastólica', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed)),
                  ],
                ),
              ),
              ///////////////////////////////////////7777
              //const SizedBox(height: 8),
              //Text('Quisit odio, at nobis minima, ullam. Minimaquos, cumque aut velit sunt, animi! Nihiliure, hic tempora amet dolores libero. Hicneque tempora sit, quam eos odit! Laborumanimi, quo, tempora ad tempora animi! Nesciuntsed unde alias unde sit, ad. Aliasdolores rem, in rem, ipsum sed. Temporasunt eveniet nobis amet ullam in. Modiad ullam, vero et amet ut? Sintvitae in, nesciunt, quis nihil eos! '),
          ],
        ),
      ),
    );
  }

  // Widget _buildRiskPieCard(List<MeasurementModel> measurements) {
  //   final riskCounts = <int, int>{0: 0, 1: 0, 2: 0};
  //   int unmeasured = 0;

  //   for (var m in measurements) {
  //     final r = m.riskLevel;
  //     if (r == 0 || r == 1 || r == 2) {riskCounts[r!] = riskCounts[r]! + 1;} else {unmeasured++;}
  //   }

  //   final sections = <PieChartSectionData>[
  //     PieChartSectionData(
  //       color: Colors.green[400],
  //       value: riskCounts[0]!.toDouble(),
  //       title: '${((100 * riskCounts[0]!) / measurements.length).toStringAsFixed(0)} %',
  //       titleStyle: TextStyle(color: Colors.white, fontSize: 12),
  //       radius: 80,
  //       showTitle: true,
  //     ),
  //     PieChartSectionData(
  //       color: Colors.orange[400],
  //       value: riskCounts[1]!.toDouble(),
  //       titleStyle: TextStyle(color: Colors.white, fontSize: 12),
  //       title: '${((100 * riskCounts[1]!) / measurements.length).toStringAsFixed(0)} %',
  //       radius: 80,
  //       showTitle: true,
  //     ),
  //     PieChartSectionData(
  //       color: Colors.red[400],
  //       value: riskCounts[2]!.toDouble(),
  //       titleStyle: TextStyle(color: Colors.white, fontSize: 12),
  //       title: '${((100 * riskCounts[2]!) / measurements.length).toStringAsFixed(0)} %',
  //       radius: 80,
  //       showTitle: true,
  //     ),
  //     PieChartSectionData(
  //       color: Colors.blue[400],
  //       titleStyle: TextStyle(color: Colors.white, fontSize: 12),
  //       value: unmeasured.toDouble(),
  //       title: '${((100 * unmeasured) / measurements.length).toStringAsFixed(0)} %',
  //       radius: 80,
  //       showTitle: true,
  //     ),
  //   ];

  //   return Card(
  //     elevation: 0,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 12),
  //           child: Text('Indicadores',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
  //         ),
  /////////////////////
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             spacing: 16,
  //             children: [
  //               SizedBox(
  //                 height: 150,
  //                 width: 150,
  //                 child: PieChart(
  //                   PieChartData(
  //                     sections: sections,
  //                     centerSpaceRadius: 0,
  //                     sectionsSpace: 2,
  //                   ),
  //                 ),
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 spacing: 6,
  //                 children: [
  //                   _buildRiskChip('Alto', Colors.red),
  //                   _buildRiskChip('Medio', Colors.orange),
  //                   _buildRiskChip('Bajo', Colors.green),
  //                   _buildRiskChip('Sin medir', Colors.blue),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildRiskBarChart(List<MeasurementModel> measurements) {
  //   // Filtra las mediciones que tienen un riskLevel
  //   final withRisk = measurements.where((m) => m.riskLevel != null).toList();

  //   if (withRisk.isEmpty) {
  //     return Card(
  //       child: Padding(
  //         padding: EdgeInsets.all(16),
  //         child: Text('No se registraron riesgos'),
  //       ),
  //     );
  //   }

  //   // Calcula el promedio de riesgo por dia de la semana
  //   final dayRisk = List.generate(7, (i) => <String, dynamic>{'day': i, 'risks': []});

  //   for (final m in withRisk) {
  //     dayRisk[m.date.weekday - 1]['risks'].add(m.riskLevel);
  //   }

  //   for (final d in dayRisk) {
  //     if (d['risks'].isNotEmpty) {
  //       d['averageRisk'] = d['risks'].reduce((a, b) => a + b) / d['risks'].length;
  //       if (d['averageRisk'] == 0.0) {d['averageRisk'] = 0.05;}
  //       d['total'] = d['risks'].length;
  //     } else {
  //       d['averageRisk'] = 0.0;
  //       d['total'] = 0;
  //     }
  //   }

  //   List<BarChartGroupData> barGroups = List.generate(7, (i) {
  //     return BarChartGroupData(
  //       x: i,
  //       barRods: [
  //         BarChartRodData(
  //           toY: dayRisk[i]['averageRisk'],
  //           width: 18,
  //         )
  //       ],
  //     );
  //   });

  //   return Card(
  //     elevation: 0,
  //     color: Theme.of(context).colorScheme.errorContainer,
  //     child: Padding(
  //       padding: const EdgeInsets.all(12),
  //       child: Column(
  //         children: [
  //           Text('Tendencia de Presión Arterial',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
  //           //Text('¡Observar estas tendencias es clave para\nentender cómo responde tu cuerpo y si\nnecesitas ajustar algo con la ayuda de tu médico!'),
  //           SizedBox(height: 16),
  //           SizedBox(
  //             height: 200,
  //             width: 300,
  //             child: BarChart(
  //               BarChartData(
  //                 borderData: FlBorderData(border: const Border(left: BorderSide(), bottom: BorderSide())),
  //                 barGroups: barGroups,
  //                 titlesData: FlTitlesData(
  //                   leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 35, getTitlesWidget: (value, _) {
  //                     return Text(['Bajo', 'Med.', 'Alto'][value.toInt()], style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed));
  //                   })),
  //                   bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
  //                     return Text(['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'][value.toInt() % 7], style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed));
  //                   })),
  //                   rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //                   topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //                 ),
  //                 maxY: 2,
  //                   barTouchData: BarTouchData(
  //                     touchTooltipData: BarTouchTooltipData(
  //                       getTooltipColor: (_) => Theme.of(context).colorScheme.primary,
  //                       getTooltipItem: (group, groupIndex, rod, rodIndex) {
  //                         return BarTooltipItem('${['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'][groupIndex]}\nCantidad: ${dayRisk[group.x.toInt()]['risks'].length}', TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14));
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

Widget _buildGraphCarrousel (List<MeasurementModel> measurements) {
  final riskCounts = <int, int>{0: 0, 1: 0, 2: 0};
  int unmeasured = 0;

  for (var m in measurements) {
    final r = m.riskLevel;
    if (r == 0 || r == 1 || r == 2) {riskCounts[r!] = riskCounts[r]! + 1;} else {unmeasured++;}
  }

  final sections = <PieChartSectionData>[
    PieChartSectionData(
      color: Colors.green[400],
      value: riskCounts[0]!.toDouble(),
      title: '${((100 * riskCounts[0]!) / measurements.length).toStringAsFixed(0)} %',
      titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      radius: 80,
      showTitle: true,
    ),
    PieChartSectionData(
      color: Colors.orange[400],
      value: riskCounts[1]!.toDouble(),
      titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      title: '${((100 * riskCounts[1]!) / measurements.length).toStringAsFixed(0)} %',
      radius: 80,
      showTitle: true,
    ),
    PieChartSectionData(
      color: Colors.red[400],
      value: riskCounts[2]!.toDouble(),
      titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      title: '${((100 * riskCounts[2]!) / measurements.length).toStringAsFixed(0)} %',
      radius: 80,
      showTitle: true,
    ),
    PieChartSectionData(
      color: Colors.blue[400],
      titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      value: unmeasured.toDouble(),
      title: '${((100 * unmeasured) / measurements.length).toStringAsFixed(0)} %',
      radius: 80,
      showTitle: true,
    ),
  ];

  final withRisk = measurements.where((m) => m.riskLevel != null).toList();

  if (withRisk.isEmpty) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('No se registraron riesgos'),
      ),
    );
  }

  final dayRisk = List.generate(7, (i) => <String, dynamic>{'day': i, 'risks': []});

  for (final m in withRisk) {
    dayRisk[m.date.weekday - 1]['risks'].add(m.riskLevel);
  }

  for (final d in dayRisk) {
    if (d['risks'].isNotEmpty) {
      d['averageRisk'] = d['risks'].reduce((a, b) => a + b) / d['risks'].length;
      if (d['averageRisk'] == 0.0) {d['averageRisk'] = 0.05;}
      d['total'] = d['risks'].length;
    } else {
      d['averageRisk'] = 0.0;
      d['total'] = 0;
    }
  }

  List<BarChartGroupData> barGroups = List.generate(7, (i) {
    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: dayRisk[i]['averageRisk'],
          width: 18,
        )
      ],
    );
  });

  return SizedBox(
    height: 230,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        SizedBox(
          width: 290,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 8),
            color: Theme.of(context).colorScheme.surfaceContainer,
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text('¿Cual Riesgo suelo tener?',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: 0,
                          sectionsSpace: 2,
                        )
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRiskChip('Alto', Colors.red),
                        _buildRiskChip('Medio', Colors.orange),
                        _buildRiskChip('Bajo', Colors.green),
                        _buildRiskChip('Sin Medir', Colors.blue),
                      ],
                    )
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text('Revisa si la mayor parte del tiempo te encuentras en un riesgo bajo, o si hay un porcentaje significativo de mediciones en riesgo moderado o alto', softWrap: true,),
                // )
              ],
            )
          ),
        ),
        SizedBox(
          width: 320,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 8),
            color: Theme.of(context).colorScheme.surfaceContainer,
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text('¿Qué Días tuve mayor Riesgo?',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                SizedBox(height: 20),
                Container(
                  height: 165,
                  width: 270,                
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(border: const Border(left: BorderSide(), bottom: BorderSide())),
                      barGroups: barGroups,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 35, getTitlesWidget: (value, _) {
                          return Text(['Bajo', 'Med.', 'Alto'][value.toInt()], style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed));
                        })),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
                          return Text(['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'][value.toInt() % 7], style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed));
                        })),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      maxY: 2,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => Theme.of(context).colorScheme.primary,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem('Cantidad: ${dayRisk[group.x.toInt()]['risks'].length}', TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14));
                          }
                        )
                      )
                    )
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text('Revisa si la mayor parte del tiempo te encuentras en un riesgo bajo, o si hay un porcentaje significativo de mediciones en riesgo moderado o alto', softWrap: true,),
                // )                
              ],
            )
          ),
        ),
      ],
    ),
  );
}

Widget buildRiskHeatmapCard(List<MeasurementModel> filteredMeasurements, DateTime lastPeriodDate, String selectedPeriod) {
  const maxWeeks = 42;
  final heatmapData = <int, List<int>>{
    for (int w = 0; w < maxWeeks; w++) w: List.filled(4, 0),
  };

  for (var m in filteredMeasurements) {
    final week = m.date.difference(lastPeriodDate).inDays ~/ 7;
    if (week < 0 || week >= maxWeeks) continue;
    final hour = m.date.hour;
    final block = hour < 6 ? 0 : hour < 12 ? 1 : hour < 18 ? 2 : 3;
    heatmapData[week]![block]++;
  }

  final now = DateTime.now();
  final currentWeek = now.difference(lastPeriodDate).inDays ~/ 7;
  final colorSteps = [0, 1, 3, 5, 8];
  final colors = [
    const Color(0xFFebedf0),
    const Color(0xFFc6e48b),
    const Color(0xFF7bc96f),
    const Color(0xFF239a3b),
    const Color(0xFF196127),
  ];

  int startWeek = 0;
  int endWeek = currentWeek.clamp(0, maxWeeks - 1);

  if (selectedPeriod == 'Últimos 7 Días') {
    startWeek = ((now.subtract(Duration(days: 7))).difference(lastPeriodDate).inDays ~/ 7).clamp(0, endWeek);
  } else if (selectedPeriod == 'Últimos 30 Días') {
    startWeek = ((now.subtract(Duration(days: 30))).difference(lastPeriodDate).inDays ~/ 7).clamp(0, endWeek);
  } else if (selectedPeriod == '1er Trimestre') {
    startWeek = 0;
    endWeek = 13;
  } else if (selectedPeriod == '2do Trimestre') {
    startWeek = 14;
    endWeek = 27;
  } else if (selectedPeriod == '3er Trimestre') {
    startWeek = 28;
    endWeek = 41; // Hasta semana 42 como máximo más abajo
  }

  final activeRange = Set<int>.from(List.generate(endWeek - startWeek + 1, (i) => startWeek + i));
  const timeBlocks = [' ', 'Madrug.', 'Mañana', 'Tarde', 'Noche'];

  Color getColor(int count, bool isActive) {
    if (!isActive) return Colors.transparent;
    for (int i = colorSteps.length - 1; i >= 0; i--) {
      if (count >= colorSteps[i]) return colors[i];
    }
    return colors.first;
  }

  return Card(
    elevation: 0,
    color: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eje Y
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: timeBlocks.map((label) {
              return Container(
                width: 55,
                height: 23,
                alignment: Alignment.centerLeft,
                child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed)),
              );
            }).toList(),
          ),
          // Heatmap
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(maxWeeks, (weekIdx) {
                  final values = heatmapData[weekIdx]!;
                  final isActive = activeRange.contains(weekIdx);

                  return Column(
                    children: List.generate(5, (rowIdx) {
                      if (rowIdx == 0) {
                        return Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          child: Text('${weekIdx + 1}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontStyle: isActive ? FontStyle.normal : FontStyle.italic,
                                color: isActive
                                    ? Theme.of(context).colorScheme.onPrimaryFixed
                                    : Colors.grey,
                              )),
                        );
                      } else {
                        final count = values[rowIdx - 1];
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: getColor(count, isActive),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isActive ? Colors.transparent : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}





// Widget _buildHeatmapCard(BuildContext context, List<MeasurementModel> measurements, DateTime lastPeriod) {
//   // 1. Cálculo de la semana de gestación para cada medición
//   List<List<int>> countMatrix = List.generate(6, (_) => List.generate(46, (_) => 0));

//   for (var m in measurements) {
//     if (m.date == null) continue;

//     final gestationalWeek = m.date!.difference(lastPeriod).inDays ~/ 7;
//     if (gestationalWeek < 0 ||
//         gestationalWeek >= 46) continue;

//     final hour = m.date!.hour;

//     int row = 0;
//     if (hour < 4) row = 0;
//     else if (hour < 8) row = 1;
//     else if (hour < 12) row = 2;
//     else if (hour < 16) row = 3;
//     else if (hour < 20) row = 4;
//     else row = 5;

//     countMatrix[row][gestationalWeek]++;
//   }

//   // 2. Generar el grid view
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'Mapa de calor de tus mediciones',
//         style: Theme.of(context).textTheme.titleSmall?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.onPrimaryFixed,
//             ),
//       ),
//       Container(
//         height: 300,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(46, (week) {
//               return Column(
//                 children: List.generate(6, (hourBlock) {
//                     final count = countMatrix[hourBlock][week];
//                     final color = count == 0
//                         ? Colors.grey.shade200
//                         : Colors.red.withOpacity((count / 10).clamp(0, 1));

//                     return Container(
//                       width: 20,
//                       height: 20,
//                       margin: EdgeInsets.all(2),
//                       color: color,
//                     );
//                  }),
//               );
//             }),
//           ),
//         ),
//       ),
//     ],
//   );
// }

  Widget _buildRiskChip(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color, radius: 5),
        SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed)),
      ],
    );
  }
}