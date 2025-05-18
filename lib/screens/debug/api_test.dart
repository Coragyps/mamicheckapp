import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiTest extends StatefulWidget {
  const ApiTest({super.key});

  @override
  State<ApiTest> createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  final _formKey = GlobalKey<FormState>();

  final _age = TextEditingController(text: '25');
  final _systolicBP = TextEditingController(text: '140');
  final _diastolicBP = TextEditingController(text: '80');
  final _bs = TextEditingController(text: '6.7');
  final _temp = TextEditingController(text: '36.67');
  final _heartRate = TextEditingController(text: '70');

  bool _isLoading = false;

  Future<void> _sendToApi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final url = Uri.parse("https://predict-kuhtf7qpsa-uc.a.run.app/us-central1/predict");

    final body = {
      "Age": int.parse(_age.text),
      "SystolicBP": int.parse(_systolicBP.text),
      "DiastolicBP": int.parse(_diastolicBP.text),
      "BS": double.parse(_bs.text),
      "BodyTemp": double.parse(_temp.text),
      "HeartRate": int.parse(_heartRate.text),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final risk = decoded["RiskLevel"] ?? "Desconocido";

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nivel de riesgo: $risk'),
            backgroundColor: (() {
              switch (risk) {
                case 'HighRisk':
                  return Colors.red;
                case 'MediumRisk':
                  return Colors.orange;
                case 'LowRisk':
                  return Colors.green;
                default:
                  return Colors.blue;
              }
            })(),
          ),
        );
      } else {
        _showError('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _showError('Error al conectar con la API: $e');
    }

    setState(() => _isLoading = false);
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.blue, behavior: SnackBarBehavior.floating,),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool isDecimal = false,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint, // Si prefieres hint en vez de valor inicial, usa esto
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Requerido';
        final parsed = isDecimal ? double.tryParse(value) : int.tryParse(value);
        if (parsed == null) return 'Número inválido';
        return null;
      },
    );
  }

  @override
  void dispose() {
    _age.dispose();
    _systolicBP.dispose();
    _diastolicBP.dispose();
    _bs.dispose();
    _temp.dispose();
    _heartRate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de API')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Edad", _age),
              _buildField("Sistólica", _systolicBP),
              _buildField("Diastólica", _diastolicBP),
              _buildField("Nivel de azúcar (BS)", _bs, isDecimal: true),
              _buildField("Temperatura corporal", _temp, isDecimal: true),
              _buildField("Frecuencia cardíaca", _heartRate),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendToApi,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}