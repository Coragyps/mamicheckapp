import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';

class PregnancyDialog extends StatefulWidget {
  const PregnancyDialog({super.key});

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
  bool _isFirstPregnancy = false;
  bool _previousHypertensiveDisorder = false;
  String _multiplePregnancyType = 'Embarazo Único';
  bool _assistedReproduction = false;
  String _autoimmuneDisease = 'Ninguno';
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
                      _selectedlastBirthDate = DateTime(1900);
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


              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tipo de embarazo',
                  border: OutlineInputBorder(),
                ),
                value: _multiplePregnancyType,
                onChanged: (val) => setState(() => _multiplePregnancyType = val!),
                items: [
                  'Embarazo Único',
                  'Aún no sé',
                  'Mellizos',
                  'Trillizos o más'
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Enfermedad autoinmune',
                  border: OutlineInputBorder(),
                ),
                value: _autoimmuneDisease,
                onChanged: (val) => setState(() => _autoimmuneDisease = val!),
                items: ['Ninguno', 'Lupus Eritematoso Sistémico', 'Síndrome Antifosfolípido', 'Otro']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text("No hay sesión activa"))
        );
        return;
      }

      try {
        final String nameTemporal = (currentUser.displayName?.length ?? 0) > 2
          ? currentUser.displayName!.substring(2)
          : '???';
        final pregnancy = PregnancyModel(
          id: '', // ID vacío porque Firestore lo genera automáticamente
          name: 'Bebe de $nameTemporal',
          ownerId: currentUser.uid,
          followers: ['nNF18EWgOBb786CFQboARQN8gB53'],
          isActive: true,

          lastMenstrualPeriod: _selectedLastMenstrualPeriod!,
          gravidity: int.parse(_gravidityController.text.trim()),
          parity: int.parse(_parityController.text.trim()),
          interpregnancyInterval: _selectedlastBirthDate!,
          previousHypertensiveDisorder: _previousHypertensiveDisorder,

          multiplePregnancyType: _multiplePregnancyType,
          assistedReproduction: _assistedReproduction,

          prePregnancyWeight: int.parse(_weightController.text.trim()),
          prePregnancyHeight: int.parse(_heightController.text.trim()),

          autoimmuneDisease: _autoimmuneDisease,
          diabetesHistory: _diabetesHistory,
          familyHistoryPreeclampsia: _familyHistoryPreeclampsia,
          chronicHypertension: _chronicHypertension,
          chronicKidneyDisease: _chronicKidneyDisease, // si aún no se usa
        );

        await PregnancyService().createPregnancyDocument(pregnancy);
        navigator.pop(); // cerrar diálogo o regresar después de guardar

      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text("Error al guardar el embarazo: $e")),
        );
      }
    }
  }

  
}

// class _PregnancyDialogState extends State<PregnancyDialog> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _furController = TextEditingController(); // Fecha FUR
  
//   final TextEditingController _gravidityController = TextEditingController();
//   final TextEditingController _parityController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();

//   DateTime? _selectedFur;
//   DateTime? _selectedIntervalDate;

//   bool _hasPreviousPregnancy = false;
//   bool _previousHypertensiveDisorder = false;
//   bool _assistedReproduction = false;
//   bool _familyHistoryPreeclampsia = false;
//   bool _chronicHypertension = false;
//   bool _chronicKidneyDisease = false;

//   String _multiplePregnancyType = 'Embarazo Único';
//   String _autoimmuneDisease = 'Ninguno';
//   String _diabetesHistory = 'Ninguno';

//   final List<String> multipleTypes = [
//     'Embarazo Único',
//     'Aún no sé',
//     'Mellizos',
//     'Trillizos o más'
//   ];

//   final List<String> autoimmuneOptions = [
//     'Ninguno',
//     'Lupus Eritematoso Sistémico',
//     'Síndrome Antifosfolípido',
//     'Otro',
//   ];

//   final List<String> diabetesOptions = [
//     'Ninguno',
//     'Diabetes Tipo 1',
//     'Diabetes Tipo 2',
//   ];


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _titlebar(context),
//       body: _body(context),
//     );
//   }

//   PreferredSizeWidget _titlebar(BuildContext context) {
//     return AppBar(
//       title: Text('Embarazo'),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 16),
//           child: FilledButton(
//             onPressed: () => {},
//             child: const Text('Guardar'),
//           ),
//         )
//       ],
//     );
//   }



// Widget _body(BuildContext context) {
//   return SafeArea(
//     child: SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Nombre del embarazo'),
//               validator: (value) =>
//                   value == null || value.isEmpty ? 'Requerido' : null,
//             ),
//             const SizedBox(height: 16),

//             _buildDateField(
//               context,
//               label: 'Fecha de última menstruación (FUR)',
//               controller: _furController,
//               selectedDate: _selectedFur,
//               onDateSelected: (date) {
//                 setState(() {
//                   _selectedFur = date;
//                   _furController.text = _formatDate(date);
//                 });
//               },
//             ),

//             const SizedBox(height: 16),
//             _buildCounterField('Gravidez', _gravidity, (value) {
//               setState(() => _gravidity = value);
//             }),
//             _buildCounterField('Paridad', _parity, (value) {
//               setState(() => _parity = value);
//             }),

//             const SizedBox(height: 16),
//             _buildDateField(
//               context,
//               label: 'Intervalo intergestacional',
//               controller: _interpregnancyIntervalController,
//               selectedDate: _selectedInterval,
//               onDateSelected: (date) {
//                 setState(() {
//                   _selectedInterval = date;
//                   _interpregnancyIntervalController.text = _formatDate(date);
//                 });
//               },
//             ),

//             SwitchListTile(
//               value: _previousHypertensiveDisorder,
//               onChanged: (value) =>
//                   setState(() => _previousHypertensiveDisorder = value),
//               title: const Text('Antecedente de trastorno hipertensivo'),
//             ),

//             DropdownButtonFormField<String>(
//               value: _multiplePregnancyType,
//               items: const [
//                 DropdownMenuItem(value: 'Ninguno', child: Text('Ninguno')),
//                 DropdownMenuItem(value: 'Gemelar', child: Text('Gemelar')),
//                 DropdownMenuItem(value: 'Triple o más', child: Text('Triple o más')),
//               ],
//               onChanged: (value) =>
//                   setState(() => _multiplePregnancyType = value!),
//               decoration: const InputDecoration(labelText: 'Tipo de embarazo múltiple'),
//             ),

//             SwitchListTile(
//               value: _assistedReproduction,
//               onChanged: (value) =>
//                   setState(() => _assistedReproduction = value),
//               title: const Text('Reproducción asistida'),
//             ),

//             TextFormField(
//               controller: _weightController,
//               decoration: const InputDecoration(labelText: 'Peso pregestacional (kg)'),
//               keyboardType: TextInputType.number,
//               validator: (value) => value == null || value.isEmpty
//                   ? 'Requerido'
//                   : null,
//             ),

//             TextFormField(
//               controller: _heightController,
//               decoration: const InputDecoration(labelText: 'Talla pregestacional (cm)'),
//               keyboardType: TextInputType.number,
//               validator: (value) => value == null || value.isEmpty
//                   ? 'Requerido'
//                   : null,
//             ),

//             TextFormField(
//               controller: _autoimmuneDiseaseController,
//               decoration: const InputDecoration(labelText: 'Enfermedad autoinmune'),
//             ),
//             TextFormField(
//               controller: _diabetesHistoryController,
//               decoration: const InputDecoration(labelText: 'Antecedentes de diabetes'),
//             ),

//             SwitchListTile(
//               value: _familyHistoryPreeclampsia,
//               onChanged: (value) =>
//                   setState(() => _familyHistoryPreeclampsia = value),
//               title: const Text('Antecedentes familiares de preeclampsia'),
//             ),
//             SwitchListTile(
//               value: _chronicHypertension,
//               onChanged: (value) =>
//                   setState(() => _chronicHypertension = value),
//               title: const Text('Hipertensión crónica'),
//             ),
//             SwitchListTile(
//               value: _chronicKidneyDisease,
//               onChanged: (value) =>
//                   setState(() => _chronicKidneyDisease = value),
//               title: const Text('Enfermedad renal crónica'),
//             ),

//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   // Procesar guardado
//                 }
//               },
//               child: const Text('Guardar'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }



//   // Widget _body(BuildContext context) {
//   //   return SafeArea(
//   //     child: SingleChildScrollView(
//   //       padding: const EdgeInsets.all(16),
//   //       child: Form(
//   //         key: _formKey,
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             // 1. Semana de embarazo
//   //             TextFormField(
//   //               controller: _weeksPregnantController,
//   //               decoration: const InputDecoration(
//   //                 border: OutlineInputBorder(),
//   //                 labelText: 'Semanas de embarazo',
//   //                 suffixText: 'semanas',
//   //               ),
//   //               keyboardType: TextInputType.number,
//   //               validator: (value) {
//   //                 if (value == null || value.isEmpty) {
//   //                   return 'Ingresa la semana de embarazo';
//   //                 }
//   //                 if (int.tryParse(value) == null || int.parse(value) < 0) {
//   //                   return 'Ingresa un número válido';
//   //                 }
//   //                 return null;
//   //               },
//   //             ),
//   //             const SizedBox(height: 16),

//   //             // 2. Primer embarazo
//   //             Row(
//   //               children: [
//   //                 const Expanded(child: Text('¿Este es tu primer embarazo?')),
//   //                 Switch(
//   //                   value: _isFirstPregnancy,
//   //                   onChanged: (value) {
//   //                     setState(() {
//   //                       _isFirstPregnancy = value;
//   //                       if (_isFirstPregnancy) {
//   //                         _pregnancyNumberController.text = '1';
//   //                       } else {
//   //                         _pregnancyNumberController.clear();
//   //                       }
//   //                     });
//   //                   },
//   //                 ),
//   //               ],
//   //             ),
//   //             if (!_isFirstPregnancy) ...[
//   //               const SizedBox(height: 16),
//   //               TextFormField(
//   //                 controller: _pregnancyNumberController,
//   //                 decoration: const InputDecoration(
//   //                   border: OutlineInputBorder(),
//   //                   labelText: 'Número del Embarazo Actual',
//   //                 ),
//   //                 keyboardType: TextInputType.number,
//   //                 validator: (value) {
//   //                   if (!_isFirstPregnancy && (value == null || value.isEmpty)) {
//   //                     return 'Ingresa el número de embarazo';
//   //                   }
//   //                   if (!_isFirstPregnancy && value != null && (int.tryParse(value) == null || int.parse(value) < 2)) {
//   //                     return 'Debe ser 2 o mayor';
//   //                   }
//   //                   return null;
//   //                 },
//   //               ),
//   //               const SizedBox(height: 16),
//   //               TextFormField(
//   //                 initialValue: _parity.toString(),
//   //                 decoration: const InputDecoration(
//   //                   border: OutlineInputBorder(),
//   //                   labelText: 'Número de veces que ha dado a luz',
//   //                 ),
//   //                 keyboardType: TextInputType.number,
//   //                 onChanged: (value) {
//   //                   setState(() {
//   //                     _parity = int.tryParse(value) ?? 0;
//   //                   });
//   //                 },
//   //                 validator: (value) {
//   //                   if (value == null || value.isEmpty) {
//   //                     return 'Ingresa el número de partos';
//   //                   }
//   //                   if (int.tryParse(value) == null || int.parse(value) < 0) {
//   //                     return 'Ingresa un número válido';
//   //                   }
//   //                   return null;
//   //                 },
//   //               ),
//   //               const SizedBox(height: 16),
//   //               InkWell(
//   //                 onTap: () => _selectDate(context, initialDate: _lastBirthDate),
//   //                 child: InputDecorator(
//   //                   decoration: const InputDecoration(
//   //                     border: OutlineInputBorder(),
//   //                     labelText: 'Fecha del último parto (Año y Mes)',
//   //                   ),
//   //                   child: Padding(
//   //                     padding: const EdgeInsets.symmetric(vertical: 12),
//   //                     child: Text(
//   //                       _lastBirthDate == null
//   //                           ? 'Seleccionar fecha'
//   //                           : '${_lastBirthDate!.year}-${_lastBirthDate!.month.toString().padLeft(2, '0')}',
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 16),
//   //               Row(
//   //                 children: [
//   //                   const Expanded(child: Text('¿Complicación Hipertensiva o Preeclampsia en el embarazo anterior?')),
//   //                   Switch(
//   //                     value: _previousHypertension,
//   //                     onChanged: (value) {
//   //                       setState(() {
//   //                         _previousHypertension = value;
//   //                       });
//   //                     },
//   //                   ),
//   //                 ],
//   //               ),
//   //               const SizedBox(height: 16),
//   //             ],

//   //             // 3. Embarazo Multiple
//   //             DropdownButtonFormField<String>(
//   //               decoration: const InputDecoration(
//   //                 border: OutlineInputBorder(),
//   //                 labelText: '¿Sabes si es Embarazo Multiple?',
//   //               ),
//   //               value: _multiplePregnancy,
//   //               items: const [
//   //                 DropdownMenuItem(value: 'Embarazo Unico', child: Text('Embarazo Único')),
//   //                 DropdownMenuItem(value: 'Aun no sé', child: Text('Aún no sé')),
//   //                 DropdownMenuItem(value: 'Mellizos', child: Text('Mellizos')),
//   //                 DropdownMenuItem(value: 'Trillizos', child: Text('Trillizos')),
//   //                 DropdownMenuItem(value: 'Cuatrillizos o más', child: Text('Cuatrillizos o más')),
//   //               ],
//   //               onChanged: (String? value) {
//   //                 setState(() {
//   //                   _multiplePregnancy = value;
//   //                 });
//   //               },
//   //             ),
//   //             const SizedBox(height: 16),
//   //             Row(
//   //               children: [
//   //                 const Expanded(child: Text('¿Se Usó de técnicas de reproducción asistida?')),
//   //                 Switch(
//   //                   value: _assistedReproduction,
//   //                   onChanged: (value) {
//   //                     setState(() {
//   //                       _assistedReproduction = value;
//   //                     });
//   //                   },
//   //                 ),
//   //               ],
//   //             ),
//   //             const SizedBox(height: 16),

//   //             // 4. Peso y Talla
//   //             TextFormField(
//   //               controller: _weightController,
//   //               decoration: const InputDecoration(
//   //                 border: OutlineInputBorder(),
//   //                 labelText: 'Peso al momento (si se acuerda de antes)',
//   //                 suffixText: 'kg',
//   //               ),
//   //               keyboardType: TextInputType.numberWithOptions(decimal: true),
//   //             ),
//   //             const SizedBox(height: 16),
//   //             TextFormField(
//   //               controller: _heightController,
//   //               decoration: const InputDecoration(
//   //                 border: OutlineInputBorder(),
//   //                 labelText: 'Talla al momento (si se acuerda de antes)',
//   //                 suffixText: 'metros',
//   //               ),
//   //               keyboardType: TextInputType.numberWithOptions(decimal: true),
//   //             ),
//   //             const SizedBox(height: 16),

//   //             // 5. Antecedentes de Salud
//   //             DropdownButtonFormField<String>(
//   //               decoration: const InputDecoration(
//   //                 border: OutlineInputBorder(),
//   //                 labelText: 'Enfermedad autoinmune',
//   //               ),
//   //               value: _autoimmuneDisease,
//   //               items: const [
//   //                 DropdownMenuItem(value: 'Ninguno', child: Text('Ninguno')),
//   //                 DropdownMenuItem(value: 'No sé', child: Text('No sé')),
//   //                 DropdownMenuItem(value: 'lupus eritematoso sistémico', child: Text('Lupus eritematoso sistémico')),
//   //                 DropdownMenuItem(value: 'síndrome antifosfolípido', child: Text('Síndrome antifosfolípido')),
//   //                 DropdownMenuItem(value: 'Otro', child: Text('Otro')),
//   //               ],
//   //               onChanged: (String? value) {
//   //                 setState(() {
//   //                   _autoimmuneDisease = value;
//   //                 });
//   //               },
//   //             ),
//   //             const SizedBox(height: 16),
//   //             DropdownButtonFormField<String>(
//   //               decoration: const InputDecoration(
//   //                 border: OutlineInputBorder(),
//   //                 labelText: 'Historial de Diabetes',
//   //               ),
//   //               value: _diabetesHistory,
//   //               items: const [
//   //                 DropdownMenuItem(value: 'Ninguno', child: Text('Ninguno')),
//   //                 DropdownMenuItem(value: 'Diabetes Tipo 1', child: Text('Diabetes Tipo 1')),
//   //                 DropdownMenuItem(value: 'Diabetes Tipo 2', child: Text('Diabetes Tipo 2')),
//   //               ],
//   //               onChanged: (String? value) {
//   //                 setState(() {
//   //                   _diabetesHistory = value;
//   //                 });
//   //               },
//   //             ),
//   //             const SizedBox(height: 16),
//   //             Row(
//   //               children: [
//   //                 const Expanded(child: Text('¿Antecedente Familiar de Preeclampsia?')),
//   //                 Switch(
//   //                   value: _familyPreeclampsiaHistory,
//   //                   onChanged: (value) {
//   //                     setState(() {
//   //                       _familyPreeclampsiaHistory = value;
//   //                     });
//   //                   },
//   //                 ),
//   //               ],
//   //             ),
//   //             const SizedBox(height: 16),
//   //             Row(
//   //               children: [
//   //                 const Expanded(child: Text('¿Hipertensión crónica?')),
//   //                 Switch(
//   //                   value: _chronicHypertension,
//   //                   onChanged: (value) {
//   //                     setState(() {
//   //                       _chronicHypertension = value;
//   //                     });
//   //                   },
//   //                 ),
//   //               ],
//   //             ),
//   //             // const SizedBox(height: 24),

//   //             // Botón para guardar (temporal para pruebas)
//   //             // ElevatedButton(
//   //             //   onPressed: () {
//   //             //     if (_formKey.currentState!.validate()) {
//   //             //       final weeks = int.tryParse(_weeksPregnantController.text) ?? 0;
//   //             //       final conceptionDate = DateTime.now().subtract(Duration(days: weeks * 7));

//   //             //       final pregnancyData = PregnancyModel(
//   //             //         id: '', // Firestore auto-genera el ID
//   //             //         name: 'Mi Embarazo', // Puedes hacerlo dinámico si lo deseas
//   //             //         ownerId: 'user123', // Reemplaza con el ID del usuario autenticado
//   //             //         followers: [],
//   //             //         isActive: true,
//   //             //         lastMenstrualPeriod: DateTime.now().subtract(Duration(days: weeks * 7 + 14)), // Estimación desde la concepción
//   //             //         gravidity: _isFirstPregnancy ? 1 : int.tryParse(_pregnancyNumberController.text) ?? 1,
//   //             //         parity: _parity,
//   //             //         interpregnancyInterval: _lastBirthDate ?? DateTime(1900),
//   //             //         previousHypertensiveDisorder: _previousHypertension,
//   //             //         multiplePregnancyType: _multiplePregnancy ?? 'Aun no sé',
//   //             //         assistedReproduction: _assistedReproduction,
//   //             //         prePregnancyWeight: double.tryParse(_weightController.text) ?? 0.0,
//   //             //         prePregnancyHeight: double.tryParse(_heightController.text) ?? 0.0,
//   //             //         autoimmuneDisease: _autoimmuneDisease ?? 'Ninguno',
//   //             //         diabetesHistory: _diabetesHistory ?? 'Ninguno',
//   //             //         familyHistoryPreeclampsia: _familyPreeclampsiaHistory,
//   //             //         chronicHypertension: _chronicHypertension,
//   //             //         chronicKidneyDisease: false, // No hay pregunta para esto en el formulario
//   //             //       );

//   //             //       print('Datos a guardar: ${pregnancyData.toMap()}');
//   //             //       // Aquí iría la lógica para guardar en Firestore
//   //             //     }
//   //             //   },
//   //             //   child: const Text('Guardar (Temporal)'),
//   //             // ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }



//   // Future <void> _handleSignup(BuildContext context) async {
//   //   if (_formKey.currentState!.validate()) {
//   //     final messenger = ScaffoldMessenger.of(context);
//   //     final navigator = Navigator.of(context, rootNavigator: true);

//   //     final error = await AuthService().signup(
//   //       email: _emailController.text.trim(),
//   //       password: _passwordController.text.trim(),
//   //     );
      
//   //     if (error == null) {
//   //       final user = FirebaseAuth.instance.currentUser;
//   //       if (user != null) {
//   //         final newUser = UserModel(
//   //           uid: user.uid,
//   //           email: _emailController.text.trim(),
//   //           firstName: _firstNameController.text.trim(),
//   //           lastName: _lastNameController.text.trim(),
//   //           telephoneNumber: _telephoneController.text.trim(),
//   //           birthDate: _selectedBirthDate!,
//   //           isPregnant: false,
//   //         );
//   //         await UserService().createUserDocument(newUser);
//   //       }
//   //       navigator.pushNamedAndRemoveUntil('HomeScreen', (_) => false);
//   //     } else {
//   //       messenger.showSnackBar(
//   //         SnackBar(content: Text(error))
//   //       );
//   //     }
//   //   }
//   // }
// }