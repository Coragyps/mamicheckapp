import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/services/measurement_service.dart';

class MeasurementDialog extends StatefulWidget {
  final String pregnancyId;
  final DateTime birthDate;
  const MeasurementDialog({super.key, required this.pregnancyId, required this.birthDate});

  @override
  State<MeasurementDialog> createState() => _MeasurementDialogState();
}

class _MeasurementDialogState extends State<MeasurementDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _riskLevelController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _bloodSugarController.dispose();
    _temperatureController.dispose();
    _heartRateController.dispose();
    _riskLevelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Fecha picker simplificado
              ListTile(
                title: Text('Fecha: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: _systolicController,
                decoration: const InputDecoration(labelText: 'Presión Sistólica (opcional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _diastolicController,
                decoration: const InputDecoration(labelText: 'Presión Diastólica (opcional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _bloodSugarController,
                decoration: const InputDecoration(labelText: 'Glucosa en sangre (opcional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _temperatureController,
                decoration: const InputDecoration(labelText: 'Temperatura (opcional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _heartRateController,
                decoration: const InputDecoration(labelText: 'Frecuencia Cardíaca (opcional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _riskLevelController,
                decoration: const InputDecoration(labelText: 'Nivel de Riesgo (opcional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notas (opcional)'),
                keyboardType: TextInputType.text,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleCreateMeasurement() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);

    try {
      final measurement = MeasurementModel(
        id: '', // Firestore generará el ID
        date: _selectedDate,
        age: _calculateAge(widget.birthDate),
        systolicBP: _systolicController.text.trim().isEmpty ? null : int.parse(_systolicController.text.trim()),
        diastolicBP: _diastolicController.text.trim().isEmpty ? null : int.parse(_diastolicController.text.trim()),
        bloodSugar: _bloodSugarController.text.trim().isEmpty ? null : int.parse(_bloodSugarController.text.trim()),
        temperature: _temperatureController.text.trim().isEmpty ? null : int.parse(_temperatureController.text.trim()),
        heartRate: _heartRateController.text.trim().isEmpty ? null : int.parse(_heartRateController.text.trim()),
        riskLevel: _riskLevelController.text.trim().isEmpty ? null : int.parse(_riskLevelController.text.trim()),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await MeasurementService().createMeasurement(widget.pregnancyId, measurement);

      navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error al guardar la medición: $e')),
      );
    }
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
