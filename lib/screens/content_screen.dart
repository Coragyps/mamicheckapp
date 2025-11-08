import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:intl/intl.dart';

class ContentScreen extends StatefulWidget {
  final PregnancyModel? pregnancy;
  final String? uid;
  final String? firstName;
  final DateTime? birthDate;
  final String selectedPeriod;
  final List<MeasurementModel> filteredMeasurements;
  const ContentScreen({super.key, required this.pregnancy, required this.uid, required this.selectedPeriod, required this.filteredMeasurements, required this.firstName, required this.birthDate});

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
          SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text('${widget.pregnancy?.name ?? ''}${(widget.pregnancy?.isActive ?? true) ? '' : ' - Archivado'}', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontFamily: 'caveat', color: Theme.of(context).colorScheme.onPrimaryFixed, height: 0.9)),
          ),
          SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Indicadores',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Estos valores te ayudan a comprender tu evolución y actuar a tiempo'),
            ),
            SizedBox(height: 8),
            _buildKpiCarrousel(),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Evolución de Presión Arterial',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('¡Manten un ojo en estas tendencias para evitar tener una PA elevada!'),
            ),
            const SizedBox(height: 12),
            _buildChartCard(widget.filteredMeasurements),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Patrones Semanales',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Considera como tu rutina influye en tus lecturas'),
            ),
            const SizedBox(height: 12),
            _buildGraphCarrousel(widget.filteredMeasurements),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Adherencia al Monitoreo',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('¿En que horas suelo realizar más mediciones?'),
            ),
            buildRiskHeatmapCard(widget.filteredMeasurements, widget.pregnancy?.lastMenstrualPeriod ?? DateTime.now(), widget.selectedPeriod),
            SizedBox(height: 50),
          
          _buildRiskFactorList(widget.pregnancy?.riskFactors ?? []),
          SizedBox(height: 12),
        ],
      ),
    );
  }


Widget _buildKpiCarrousel() {
  final theme = Theme.of(context);
  final lastRisk = widget.filteredMeasurements.isNotEmpty
      ? widget.filteredMeasurements.last.riskLevel
      : null;
  final fechafur = widget.pregnancy?.lastMenstrualPeriod;
  final formattedFur = fechafur != null ? DateFormat.yMMMMEEEEd(Intl.defaultLocale).format(fechafur) : 'No registrada';
  final probableDueDate = fechafur != null
    ? DateFormat.yMMMMEEEEd(Intl.defaultLocale).format(fechafur.add(const Duration(days: 280)))
    : 'No disponible';
  final week = fechafur != null
      ? DateTime.now().difference(widget.pregnancy!.lastMenstrualPeriod).inDays ~/ 7
      : null;

  final streak = calculateCurrentStreak(widget.filteredMeasurements);
  final totalMeasurements = widget.filteredMeasurements.length;
  final riskLabel = ['Bajo', 'Moderado', 'Alto', 'Sin Medir'][lastRisk ?? 3];
  final riskCount = widget.pregnancy?.riskFactors?.length ?? 0;

  final items = [
    ('Edad Gestacional', 'Semana $week'),
    ('Total de Mediciones', '$totalMeasurements'),
    ('Nivel de Riesgo', riskLabel),
    ('Racha de Seguimiento', '$streak días'),
    ('Factores de Riesgo', '$riskCount'),
  ];

  Color getRiskColor(int? risk) {
    switch (risk) {
      case 0:
        return Colors.green[100]!;
      case 1:
        return Colors.orange[100]!;
      case 2:
        return Colors.red[200]!;
      default:
        return Colors.blue[100]!;
    }
  }

  final explanations = [
    [Text(items[0].$1), Text('Indica el progreso actual del embarazo en semanas, calculado a partir de la Fecha de Última Regla (FUR).''\n\n📅 Fecha FUR: $formattedFur''\n\n🤱 Fecha probable de parto: $probableDueDate')],
    [Text(items[1].$1), Text('Número total de registros que has ingresado en la app dentro del período de tiempo seleccionado.')],
    [Text(items[2].$1), Text('Indica el riesgo estimado según tus signos vitales dentro del período de tiempo seleccionado.\n\nConsulta con tu médico si mantienes un riesgo alto tras varias mediciones.')],
    [Text(items[3].$1), Text('Cantidad de días consecutivos en los que realizaste mediciones. Refleja tu constancia en el control de salud.')],
    [Text(items[4].$1), Text('Factores detectados por los datos del cuestionario de embarazo.\n\nSon importantes ante otros transtornos hipertensivos como Preeclampsia.')],
  ];

  return SizedBox(
    height: 115,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, i) {
        final (title, value) = items[i];
        final isRisk = i == 2;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 135,
          padding: const EdgeInsets.only(top: 6, bottom: 10, left: 10, right: 2),
          decoration: BoxDecoration(
            color: isRisk
                ? getRiskColor(lastRisk)
                : theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          final dialognavigator = Navigator.of(dialogContext);
                          return AlertDialog(
                            title: explanations[i][0],
                            content: explanations[i][1],
                            actions: [
                              TextButton(child: const Text('Cerrar'), onPressed: () {dialognavigator.pop();}),
                            ], 
                          );
                        }
                      );
                    },
                    icon:  Icon(
                      Icons.info_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}



  // Widget _buildKpiCarrousel() {
  //   final theme = Theme.of(context);
  //   final lastRisk = widget.filteredMeasurements.isNotEmpty ? widget.filteredMeasurements.last.riskLevel : null;
  //   final week = widget.pregnancy?.lastMenstrualPeriod != null
  //       ? DateTime.now().difference(widget.pregnancy!.lastMenstrualPeriod).inDays ~/ 7
  //       : null;

  //   final streak = calculateCurrentStreak(widget.filteredMeasurements);
  //   final totalMeasurements = widget.filteredMeasurements.length;
  //   final riskLabel = ['Bajo', 'Moderado', 'Alto', 'Sin Medir'][lastRisk ?? 3];
  //   final riskCount = widget.pregnancy?.riskFactors?.length ?? 0;

  //   final chipLabels = [
  //     'Semana $week',
  //     '$totalMeasurements',
  //     riskLabel,
  //     '$streak días',
  //     '$riskCount',
  //   ];

  //   final chipTitles = [
  //     'Tiempo de\nEmbarazo',
  //     'Total de\nMediciones',
  //     'Último\nRiesgo',
  //     'Tu Última\nRacha',
  //     'Factores de\nRiesgo',
  //   ];

  //   Color getRiskColor(int? risk) {
  //     switch (risk) {
  //       case 0: return Colors.green[100]!;
  //       case 1: return Colors.orange[100]!;
  //       case 2: return Colors.red[200]!;
  //       default: return Colors.blue[100]!;
  //     }
  //   }

  //   return SizedBox(
  //     height: 95,
  //     child: ListView.builder(
  //       padding: const EdgeInsets.symmetric(horizontal: 4),
  //       scrollDirection: Axis.horizontal,
  //       itemCount: chipLabels.length,
  //       itemBuilder: (context, i) {
  //         final isRiskChip = i == 2;
  //         return Card(
  //           margin: const EdgeInsets.symmetric(horizontal: 4),
  //           elevation: 0,
  //           color: isRiskChip ? getRiskColor(lastRisk) : theme.colorScheme.secondaryFixed,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Text(
  //                   chipTitles[i],
  //                   style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryFixed),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 Chip(
  //                   label: Text(chipLabels[i], style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal, color: theme.colorScheme.onPrimaryFixed)),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildChartCard(List<MeasurementModel> measurements) {
    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];
    for (int i = 0; i < measurements.length; i++) {
      systolicSpots.add(FlSpot(i.toDouble(), measurements[i].systolicBP.toDouble()));
      diastolicSpots.add(FlSpot(i.toDouble(), measurements[i].diastolicBP.toDouble()));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true
                ),
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
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) {
                        final index = barData.spots.indexOf(spot);
                        return index == 0 || index == barData.spots.length -1;
                      }
                    ),
                  ),
                  LineChartBarData(
                    spots: diastolicSpots,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) {
                        final index = barData.spots.indexOf(spot);
                        return index == 0 || index == barData.spots.length -1;
                      }
                    ),
                  ),
                ],
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 140,
                      color: Colors.red.shade500,
                      strokeWidth: 1,
                      dashArray: [8, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        style: TextStyle(fontStyle: FontStyle.italic),
                        alignment: Alignment.topRight,
                        labelResolver: (_) => '140 mmHg'
                      )
                    ),
                    HorizontalLine(
                      y: 90,
                      color: Colors.blue.shade500,
                      strokeWidth: 1,
                      dashArray: [8, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        style: TextStyle(fontStyle: FontStyle.italic),
                        alignment: Alignment.topRight,
                        labelResolver: (_) => '90 mmHg'
                      )
                    ),
                  ]
                )
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
        ],
      ),
    );
  }

  Widget _buildGraphCarrousel (List<MeasurementModel> measurements) {
    final withRisk = measurements.where((m) => m.riskLevel != null).toList();
    final riskCounts = {0: 0, 1: 0, 2: 0};
    int unmeasured = 0;

    for (var m in measurements) {
      final r = m.riskLevel;
      if (r != null && riskCounts.containsKey(r)) {
        riskCounts[r] = riskCounts[r]! + 1;
      } else {unmeasured++;}
    }

    final total = measurements.length;

    final sections = [
      PieChartSectionData(
        color: Colors.green[400],
        value: riskCounts[0]!.toDouble(),
        title: '${((100 * riskCounts[0]!) / total).toStringAsFixed(0)} %',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
        radius: 80,
      ),
      PieChartSectionData(
        color: Colors.orange[400],
        value: riskCounts[1]!.toDouble(),
        title: '${((100 * riskCounts[1]!) / total).toStringAsFixed(0)} %',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
        radius: 80,
      ),
      PieChartSectionData(
        color: Colors.red[400],
        value: riskCounts[2]!.toDouble(),
        title: '${((100 * riskCounts[2]!) / total).toStringAsFixed(0)} %',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
        radius: 80,
      ),
      PieChartSectionData(
        color: Colors.blue[400],
        value: unmeasured.toDouble(),
        title: '${((100 * unmeasured) / total).toStringAsFixed(0)} %',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
        radius: 80,
      ),
    ];

    final List<Map<String, dynamic>> dayRisk = List.generate(7, (_) => {
          'risks': <int>[],
          'averageRisk': 0.0,
          'total': 0,
        });

    for (final m in withRisk) {
      final index = m.date.weekday - 1;
      dayRisk[index]['risks'].add(m.riskLevel!);
    }

    for (final d in dayRisk) {
      final risks = d['risks'] as List<int>;
      if (risks.isNotEmpty) {
        final avg = risks.reduce((a, b) => a + b) / risks.length;
        d['averageRisk'] = avg == 0.0 ? 0.05 : avg;
        d['total'] = risks.length;
      }
    }

    final barGroups = List.generate(7, (i) {
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
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text('¿Estoy en riesgo?',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (measurements.isEmpty) Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 20),
                        width: 150,
                        height: 170,
                        child: Text('No se han registrado mediciones para este rango de tiempo.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                      ) else SizedBox(
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
                ],
              )
            ),
          ),
          SizedBox(
            width: 320,
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              margin: EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text('¿Qué Día me afecta más?',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                  SizedBox(height: 20),
                  SizedBox(
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
                            child: Text('${weekIdx + 1}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: isActive ? FontStyle.normal : FontStyle.italic, color: isActive ? Theme.of(context).colorScheme.onPrimaryFixed : Colors.grey)),
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

  Widget _buildRiskFactorList(List<String> riskFactors) {
    if (riskFactors.isEmpty) return SizedBox.shrink();

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      margin: EdgeInsets.symmetric(horizontal: 12),
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            Text('Factores de Riesgo',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
            Text('Ante otras enfermedades hipertensivas del embarazo'),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 0,
              children: riskFactors.map((factor) {
                return Chip(
                  label: Text(factor),
                  avatar: Icon(Icons.warning, color: Colors.red),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRiskChip(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color, radius: 5),
        SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed)),
      ],
    );
  }

  // int calculateCurrentStreak(List<MeasurementModel> measurements) {
  //   if (measurements.isEmpty) return 0;

  //   // Agrupar por fecha (ignorando hora)
  //   final uniqueDates = measurements
  //       .map((m) => DateTime(m.date.year, m.date.month, m.date.day))
  //       .toSet()
  //       .toList()
  //     ..sort((a, b) => b.compareTo(a)); // De más reciente a más antigua

  //   int streak = 1;
  //   for (int i = 1; i < uniqueDates.length; i++) {
  //     final diff = uniqueDates[i - 1].difference(uniqueDates[i]).inDays;
  //     if (diff == 1) {streak++;} else if (diff > 1) {break;}
  //   }

  //   return streak;
  // }


  int calculateCurrentStreak(List<MeasurementModel> measurements) {
    if (measurements.isEmpty) return 0;

    // Normalizamos fechas sin hora y las ordenamos de más recientes a antiguas
    final uniqueDates = measurements
        .map((m) => DateTime(m.date.year, m.date.month, m.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 1;

    for (int i = 1; i < uniqueDates.length; i++) {
      final diff = uniqueDates[i - 1].difference(uniqueDates[i]).inDays;

      if (diff == 1) {
        streak++;
      } else if (diff > 1) {
        // Si hay más de 1 día de diferencia, se rompe la racha
        break;
      }
    }

    // Si la última medición no fue ayer o hoy, la racha se considera inactiva
    final lastMeasurement = uniqueDates.first;
    final daysSinceLast = DateTime.now()
        .difference(DateTime(lastMeasurement.year, lastMeasurement.month, lastMeasurement.day))
        .inDays;

    if (daysSinceLast > 1) return 0;

    return streak;
  }
}