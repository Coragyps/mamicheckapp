import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/services/measurement_service.dart';
import 'package:http/http.dart' as http;

class MeasurementSheet extends StatefulWidget {
  final ScrollController scrollController;
  final MeasurementModel measurement;
  final List<MeasurementModel> measurements;
  final String pregnancyId;

  const MeasurementSheet({
    super.key,
    required this.scrollController,
    required this.measurement,
    required this.measurements,
    required this.pregnancyId,
  });

  @override
  State<MeasurementSheet> createState() => _MeasurementSheetState();
}

class _MeasurementSheetState extends State<MeasurementSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bloodSugarController = TextEditingController();
  final _temperatureController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.measurement.bloodSugar != null) {
      _bloodSugarController.text = widget.measurement.bloodSugar.toString();
    }
    if (widget.measurement.temperature != null) {
      _temperatureController.text = widget.measurement.temperature.toString();
    }
  }

  @override
  void dispose() {
    _bloodSugarController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showBloodSugar = widget.measurement.bloodSugar == null;
    final showTemperature = widget.measurement.temperature == null;

    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          controller: widget.scrollController,
          children: [
            const Text(
              'Completa los campos faltantes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (showBloodSugar)
              TextFormField(
                enabled: !_isSaving,
                controller: _bloodSugarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Glucosa en sangre (mmol/L)', border: OutlineInputBorder(), suffixText: 'mmol/L'),
                validator: (value) {
                  if (value!.trim().isEmpty) return 'Ingresa un valor de glucosa';
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null) return 'Debe ser un número válido';
                  if (parsed < 2.0 || parsed > 22.0) return 'Debe estar entre 2.0 y 22.0 mmol/L';
                  return null;
                },
              ),
              const SizedBox(height: 16),
            if (showTemperature)
              TextFormField(
                enabled: !_isSaving,
                controller: _temperatureController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Temperatura', border: OutlineInputBorder(), suffixText: '°C'),
                validator: (value) {
                  if (value!.trim().isEmpty) return 'Ingresa una temperatura';
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null) return 'Debe ser un número válido';
                  if (parsed < 34 || parsed > 42) return 'Debe estar entre 34.0 y 42.0 °C';
                  return null;
                },
              ),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveChanges,
              child: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
              : const Text('Guardar')
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      int? riskLevel;

      final age = widget.measurement.age; // Asumimos que ya existe
      final systolic = widget.measurement.systolicBP;
      final diastolic = widget.measurement.diastolicBP;
      final heartRate = widget.measurement.heartRate;
      final bloodSugar = double.tryParse(_bloodSugarController.text);
      final temperature = double.tryParse(_temperatureController.text);

      if (bloodSugar != null && temperature != null) {
        final url = Uri.parse("https://mamiboot-6zrxpp23tq-uc.a.run.app");
        final body = {
          "Age": age,
          "SystolicBP": systolic,
          "DiastolicBP": diastolic,
          "BS": bloodSugar,
          "BodyTemp": temperature,
          "HeartRate": heartRate,
        };

        try {
          final response = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: json.encode(body),
          );

          if (response.statusCode == 200) {
            final decoded = json.decode(response.body);
            riskLevel = int.tryParse(decoded.toString());

            final riskText = switch (riskLevel) {
              0 => 'Riesgo Bajo',
              1 => 'Riesgo Medio',
              2 => 'Riesgo Alto',
              _ => 'Riesgo Desconocido'
            };
            final riskColor = switch (riskLevel) {
              0 => Colors.green,
              1 => Colors.orange,
              2 => Colors.red,
              _ => Colors.blue
            };

            messenger.clearSnackBars();
            messenger.showSnackBar(SnackBar(content: Text('Medición guardada con $riskText'),backgroundColor: riskColor,));

          } else {
            messenger.clearSnackBars();
            messenger.showSnackBar(SnackBar(content: Text('Error ${response.statusCode}: ${response.body}'),backgroundColor: Colors.blue,));
          }
        } catch (e) {
          messenger.clearSnackBars();
          messenger.showSnackBar(SnackBar(content: Text('Error de red: $e'),backgroundColor: Colors.blue,));
        }
      }

      final updated = widget.measurement.copyWith(
        bloodSugar: widget.measurement.bloodSugar ?? bloodSugar,
        temperature: widget.measurement.temperature ?? temperature,
        riskLevel: riskLevel ?? widget.measurement.riskLevel,
      );

      await MeasurementService().updateMeasurement(
        pregnancyId: widget.pregnancyId,
        currentMeasurements: widget.measurements,
        updatedMeasurement: updated,
      );

      setState(() => _isSaving = false);
      navigator.pop();
    }
  }
}