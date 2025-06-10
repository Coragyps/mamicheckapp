import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/services/measurement_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeasurementDialog extends StatefulWidget {
  final PregnancyModel pregnancy;
  final DateTime birthDate;
  const MeasurementDialog({super.key, required this.pregnancy, required this.birthDate});

  @override
  State<MeasurementDialog> createState() => _MeasurementDialogState();
}

class _MeasurementDialogState extends State<MeasurementDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final DateTime _measurementDate = DateTime.now();

  bool _camposCompletos() {
    return _systolicController.text.trim().isNotEmpty &&
           _diastolicController.text.trim().isNotEmpty &&
           _heartRateController.text.trim().isNotEmpty &&
           _bloodSugarController.text.trim().isNotEmpty &&
           _temperatureController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _bloodSugarController.dispose();
    _temperatureController.dispose();
    _heartRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _titlebar(context),
      body: _body(context),
    );
  }

  PreferredSizeWidget _titlebar(BuildContext context) {
    return AppBar(
      title: const Text('Nueva Medición'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FilledButton(
            onPressed: _handleCreateMeasurement,
            child: const Text('Guardar'),
          ),
        )
      ],
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Fecha picker simplificado
              ListTile(
                title: Text('Embarazo: ${widget.pregnancy.name}'),
              ),
              ListTile(
                title: Text('Fecha: ${_measurementDate.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
              ),
              TextFormField(
                controller: _systolicController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Presión Sistólica (opcional)', border: OutlineInputBorder(),suffixText: 'mmHg'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.trim().isEmpty) return 'Este campo es obligatorio';
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null) return 'Debe ser un número entero';
                  if (parsed < 80 || parsed > 200) return 'Debe estar entre 80 y 200';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diastolicController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Presión Diastólica (opcional)', border: OutlineInputBorder(), suffixText: 'mmHg'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.trim().isEmpty) return 'Este campo es obligatorio';
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null) return 'Debe ser un número entero';
                  if (parsed < 50 || parsed > 130) return 'Debe estar entre 50 y 130';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heartRateController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Frecuencia Cardíaca (opcional)', border: OutlineInputBorder(), suffixText: 'bpm'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.trim().isEmpty) return 'Este campo es obligatorio';
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null) return 'Debe ser un número entero';
                  if (parsed < 40 || parsed > 200) return 'Debe estar entre 40 y 200';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bloodSugarController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Glucosa en sangre (mmol/L) (opcional)', border: OutlineInputBorder(), suffixText: 'mmol/L'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.trim().isEmpty) return null;
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null) return 'Debe ser un número válido';
                  if (parsed < 2.0 || parsed > 22.0) return 'Debe estar entre 2.0 y 22.0 mmol/L';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Temperatura (opcional)', border: OutlineInputBorder(), suffixText: '°C'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.trim().isEmpty) return null;
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null) return 'Debe ser un número válido';
                  if (parsed < 34 || parsed > 42) return 'Debe estar entre 34.0 y 42.0 °C';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Notas (opcional)', border: OutlineInputBorder(),),
                keyboardType: TextInputType.text,
                maxLines: 3,
                validator: (value) {
                  // Opcionalmente puedes validar longitud si es necesario
                  if (value != null && value.length > 500) {
                    return 'Máximo 500 caracteres';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _handleCreateMeasurement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    int? riskLevel;

    // try {
    //   final measurement = MeasurementModel(
    //     date: _measurementDate,
    //     age: _calculateAge(widget.birthDate),
    //     systolicBP: int.parse(_systolicController.text.trim()),
    //     diastolicBP: int.parse(_diastolicController.text.trim()),
    //     heartRate: int.parse(_heartRateController.text.trim()),
    //     bloodSugar: _bloodSugarController.text.trim().isEmpty ? null : double.parse(_bloodSugarController.text.trim()),
    //     temperature: _temperatureController.text.trim().isEmpty ? null : double.parse(_temperatureController.text.trim()),
    //     riskLevel: 0,
    //     notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    //   );

    //   await MeasurementService().createMeasurement(widget.pregnancy, measurement);

    //   navigator.pop();
    // } catch (e) {
    //   messenger.showSnackBar(
    //     SnackBar(content: Text('Error al guardar la medición: $e')),
    //   );
    // }

    try {
      if (_camposCompletos()) {
        //api
        final url = Uri.parse("https://predict-kuhtf7qpsa-uc.a.run.app/us-central1/predict");
        final body = {
          "Age": _calculateAge(widget.birthDate),
          "SystolicBP": int.parse(_systolicController.text.trim()),
          "DiastolicBP": int.parse(_diastolicController.text.trim()),
          "BS": double.parse(_bloodSugarController.text.trim()),
          "BodyTemp": double.parse(_temperatureController.text.trim()),
          "HeartRate": int.parse(_heartRateController.text.trim()),
        };

        final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(body));

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body); // Ej: 0, 1, 2
          riskLevel = int.tryParse(decoded.toString());

          // Asignar texto y color según el nivel de riesgo
          final riskText = switch (riskLevel) {0 => 'Riesgo Bajo', 1 => 'Riesgo Medio', 2 => 'Riesgo Alto', _ => 'Riesgo Desconocido'};
          final riskColor = switch (riskLevel) {0 => Colors.green, 1 => Colors.orange, 2 => Colors.red, _ => Colors.blue};

          messenger.showSnackBar(
            SnackBar(
              content: Text(riskText),
              backgroundColor: riskColor,
            ),
          );

        } else {
          messenger.showSnackBar(SnackBar(
            content: Text('Error ${response.statusCode}: ${response.body}'),
            backgroundColor: Colors.blue,
          ));
        }
      } else {
        messenger.showSnackBar(SnackBar(
          content: Text('Medición guardada sin cálculo de riesgo.'),
          backgroundColor: Colors.blue,
        ));
      }

      final measurement = MeasurementModel(
        date: _measurementDate,
        age: _calculateAge(widget.birthDate),
        systolicBP: int.parse(_systolicController.text.trim()),
        diastolicBP: int.parse(_diastolicController.text.trim()),
        heartRate: int.parse(_heartRateController.text.trim()),
        bloodSugar: _bloodSugarController.text.trim().isEmpty ? null : double.parse(_bloodSugarController.text.trim()),
        temperature: _temperatureController.text.trim().isEmpty ? null : double.parse(_temperatureController.text.trim()),
        riskLevel: riskLevel,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await MeasurementService().createMeasurement(widget.pregnancy, measurement);
      navigator.pop();

    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error al guardar la medición: $e')));
    }
    
    setState(() => _isSaving = false);
  }


  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {age--;}
    return age;
  }
}
