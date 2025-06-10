import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';

class PregnancyDialog extends StatefulWidget {
  final String uid;
  final DateTime birthDate;
  final String firstName;
  const PregnancyDialog({super.key, required this.birthDate, required this.firstName, required this.uid});

  @override
  State<PregnancyDialog> createState() => _PregnancyDialogState();
}

class _PregnancyDialogState extends State<PregnancyDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _lastMenstrualPeriodController = TextEditingController();
  final TextEditingController _gravidityController = TextEditingController();
  final TextEditingController _parityController = TextEditingController();
  final TextEditingController _intervalController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  DateTime? _selectedLastMenstrualPeriod;
  DateTime? _selectedlastBirthDate;
  int _fetalCount = 0;
  bool _isFirstPregnancy = false;
  bool _previousHypertensiveDisorder = false;
  bool _assistedReproduction = false;
  bool _lupus = false;
  bool _antiphospholipidSyndrome = false;
  String _diabetesHistory = 'Ninguno';
  bool _familyHistoryPreeclampsia = false;
  bool _chronicHypertension = false;
  bool _chronicKidneyDisease = false;

  @override
  void dispose() {
    _lastMenstrualPeriodController.dispose();
    _gravidityController.dispose();
    _parityController.dispose();
    _intervalController.dispose();
    _weightController.dispose();
    _heightController.dispose();
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
      title: Text('Embarazo'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FilledButton(
            onPressed: () => _handleCreatePregnancy(context),
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
              // Fecha de última menstruación (calcular semanas)
              TextFormField(
                controller: _lastMenstrualPeriodController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Last Menstrual Period',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    helpText: 'Select the Last Menstrual Period (LMP)',
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedLastMenstrualPeriod = picked;
                      _lastMenstrualPeriodController.text =
                          '${picked.day.toString().padLeft(2, '0')}/'
                          '${picked.month.toString().padLeft(2, '0')}/'
                          '${picked.year}';
                    });
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Select the LMP date' : null,
              ),
              const SizedBox(height: 16),

              // ¿Es su primer embarazo?
              SwitchListTile(
                title: Text('¿Este es tu primer embarazo?'),
                value: _isFirstPregnancy,
                onChanged: (value) {
                  setState(() {
                    _isFirstPregnancy = value;
                    if (_isFirstPregnancy) {
                      _gravidityController.text = '1';
                      _parityController.text = '0';
                      _selectedlastBirthDate = _selectedLastMenstrualPeriod;
                      _intervalController.text = 'Sin Fecha';
                    } else {
                      _gravidityController.clear();
                      _parityController.clear();
                      _intervalController.clear();
                      _selectedlastBirthDate = null;
                    }
                  });
                },
              ),

              TextFormField(
                controller: _gravidityController,
                decoration: InputDecoration(
                  labelText: 'Número de embarazos (gravidez)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Ingrese la cantidad de embarazos' : null,
                readOnly: _isFirstPregnancy,
                enabled: !_isFirstPregnancy,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _parityController,
                decoration: InputDecoration(
                  labelText: 'Número de partos (paridad)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                readOnly: _isFirstPregnancy,
                enabled: !_isFirstPregnancy,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _intervalController,
                readOnly: true,
                enabled: !_isFirstPregnancy, // Deshabilita totalmente el campo si es el primer embarazo
                decoration: const InputDecoration(
                  labelText: 'Fecha del último parto (Intervalo intergenesico)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _isFirstPregnancy
                    ? null
                    : () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                          helpText: 'Selecciona el año y mes del último parto',
                          initialDatePickerMode: DatePickerMode.year,
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedlastBirthDate = picked;
                            _intervalController.text =
                                '${picked.day.toString().padLeft(2, '0')}/'
                                '${picked.month.toString().padLeft(2, '0')}/'
                                '${picked.year}';
                          });
                        }
                      },
                validator: (value) => !_isFirstPregnancy && (value == null || value.isEmpty)
                    ? 'Seleccione la fecha del último parto'
                    : null,
              ),

              const SizedBox(height: 16),

              CheckboxListTile(
                title: Text('¿Tuviste complicación hipertensiva o preeclampsia antes?'),
                value: _previousHypertensiveDisorder,
                onChanged: _isFirstPregnancy
                    ? null
                    : (val) => setState(() => _previousHypertensiveDisorder = val ?? false),
              ),

              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Tipo de embarazo',
                  border: OutlineInputBorder(),
                ),
                value: _fetalCount,
                onChanged: (val) => setState(() => _fetalCount = val!),
                items: [
                  {'label': 'Aún no sé', 'value': 0},
                  {'label': 'Embarazo Único', 'value': 1},
                  {'label': 'Mellizos', 'value': 2},
                  {'label': 'Trillizos o más', 'value': 3},
                ].map((e) {
                  return DropdownMenuItem<int>(
                    value: e['value'] as int,
                    child: Text(e['label'] as String),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              CheckboxListTile(
                title: Text('¿Usó técnicas de reproducción asistida?'),
                value: _assistedReproduction,
                onChanged: (val) => setState(() => _assistedReproduction = val ?? false),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso pregestacional (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Talla pregestacional (cm)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text('¿Lupus Eritematoso Sistémico?'),
                value: _lupus,
                onChanged: (val) => setState(() => _lupus = val ?? false),
              ),
              CheckboxListTile(
                title: Text('¿Síndrome Antifosfolípido?'),
                value: _antiphospholipidSyndrome,
                onChanged: (val) => setState(() => _antiphospholipidSyndrome = val ?? false),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Historial de diabetes',
                  border: OutlineInputBorder(),
                ),
                value: _diabetesHistory,
                onChanged: (val) => setState(() => _diabetesHistory = val!),
                items: ['Ninguno', 'Diabetes Tipo 1', 'Diabetes Tipo 2']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text('¿Antecedente familiar de preeclampsia?'),
                value: _familyHistoryPreeclampsia,
                onChanged: (val) => setState(() => _familyHistoryPreeclampsia = val ?? false),
              ),
              CheckboxListTile(
                title: Text('¿Hipertensión crónica?'),
                value: _chronicHypertension,
                onChanged: (val) => setState(() => _chronicHypertension = val ?? false),
              ),
              CheckboxListTile(
                title: Text('¿Enfermedad Renal crónica?'),
                value: _chronicKidneyDisease,
                onChanged: (val) => setState(() => _chronicKidneyDisease = val ?? false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreatePregnancy(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context, rootNavigator: true);

      try {
        final weight = double.parse(_weightController.text.trim());
        final height = double.parse(_heightController.text.trim());
        final bmi = (10000 * weight) / (height * height);
        final yearsDifference = _selectedLastMenstrualPeriod!.difference(_selectedlastBirthDate!).inDays / 365.25;

        final List<String> riskFactorsList = [];
        if (_calculateAge(widget.birthDate) >= 40) {riskFactorsList.add('Edad Materna >= 40 años');}
        if (bmi >= 30) {riskFactorsList.add('IMC >= 30 kg/m2');}
        if (yearsDifference >= 10) {riskFactorsList.add('Intervalo Intergenésico >= 10 años');}
        if (_fetalCount >= 2) {riskFactorsList.add('Embarazo Múltiple');}
        if (_diabetesHistory != 'Ninguno') {riskFactorsList.add(_diabetesHistory);}
        if (_antiphospholipidSyndrome) {riskFactorsList.add('Síndrome Antifosfolípido');}
        if (_lupus) {riskFactorsList.add('Lupus Eritematoso Sistémico');}
        if (_previousHypertensiveDisorder) {riskFactorsList.add('Enfermedad Hipertensiva en Embarazo Anterior');}
        if (_familyHistoryPreeclampsia) {riskFactorsList.add('Antecedente Familiar de Preeclampsia');}
        if (_chronicHypertension) {riskFactorsList.add('Hipertensión Crónica');}
        if (_chronicKidneyDisease) {riskFactorsList.add('Enfermedad Renal Crónica');}

        final pregnancy = PregnancyModel(
          id:'',
          name: '${_fetalCount >= 2 ? 'Bebés de ' : 'Bebé de '}${widget.firstName}',
          isActive: true,
          lastMenstrualPeriod: _selectedLastMenstrualPeriod!,
          obstetricData: {
            'gravidity': int.parse(_gravidityController.text.trim()),
            'parity': int.parse(_parityController.text.trim()),
            'fetalCount': _fetalCount,
          },
          riskFactors: riskFactorsList,
          followers: {
            widget.uid: 'owner',
            'nNF18EWgOBb786CFQboARQN8gB53': 'admin',
          },
          measurements: [], // Vacío al inicio
        );

        await PregnancyService().createPregnancyDocument(pregnancy);
        navigator.pop(); // cerrar diálogo o regresar después de guardar

      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text("Error al guardar el embarazo: $e")),);
        //navigator.pop();
      }
    }
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {age--;}
    return age;
  }

}