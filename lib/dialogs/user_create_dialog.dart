import 'package:firebase_auth/firebase_auth.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/services/user_service.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _birthDateController = TextEditingController();

  DateTime? _selectedBirthDate;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _telephoneController.dispose();
    _birthDateController.dispose();
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
      title: Text('Registrarse'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: () => _handleSignup(context),
            child: const Text('Enviar'),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombres *',
                            hintText: 'Ejemplo: María Fernanda',
                          ),
                          validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu Nombre';
                              }
                              if (value.contains('||')) {
                                return 'El símbolo "||" no está permitido aquí.';
                              }
                              return null;
                            },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Apellidos *',
                            hintText: 'Ejemplo: Torres Paredes',
                          ),
                          validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tus Apellidos';
                              }
                              // ⚠️ Validación del separador '||'
                              if (value.contains('||')) {
                                return 'El símbolo "||" no está permitido aquí.';
                              }
                              return null;
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 36),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(Icons.cake_outlined),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _birthDateController,
                          decoration: const InputDecoration(hintText: 'Indica tu fecha de nacimiento', border: OutlineInputBorder(), labelText: 'Fecha de Nacimiento *', suffixIcon: Icon(Icons.calendar_today)),
                          readOnly: true,
                          onTap: () async {
                            final initial = DateTime(1995);
                            final firstDate = DateTime(1900);
                            final lastDate = DateTime(2020);
                            final pickedDate = await showDatePicker(
                              context: context, 
                              initialDate: initial,
                              firstDate: firstDate,
                              lastDate: lastDate,
                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                              initialDatePickerMode: DatePickerMode.year,
                              helpText: 'Selecciona tu fecha de nacimiento',
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _selectedBirthDate = pickedDate;
                                _birthDateController.text = 
                                  "${pickedDate.day.toString().padLeft(2, '0')}/"
                                  "${pickedDate.month.toString().padLeft(2, '0')}/"
                                  "${pickedDate.year}";
                              });
                            }
                          },
                          validator: (value) => value == null || value.isEmpty ? 'Selecciona tu fecha de Nacimiento' : null,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 36),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(Icons.mail_outline),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Correo electrónico *',
                            hintText: 'Ejemplo: usuario@gmail.com',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu correo electrónico.';
                            }
                            if (value.contains('||')) {
                              return 'Formato inválido. El símbolo "||" no está permitido.';
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              caseSensitive: false, // Ignora mayúsculas/minúsculas
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'Ingresa un formato de correo electrónico válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Contraseña *',
                            hintText: 'Mínimo 6 caracteres',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {_obscurePassword = !_obscurePassword;});
                              },
                            ),
                          ),
                          validator: (value) => value != null && value.length < 6 ? 'Minimo 6 Caracteres' : null,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 36),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(Icons.phone_outlined),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _telephoneController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Número de Celular *',
                            hintText: 'Ejemplo: 987654321',
                            helperText: 'Solo números (9 dígitos)',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa un número telefónico';
                            }
                            if (!RegExp(r'^\d{9,15}$').hasMatch(value)) {
                              return 'Número inválido';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future <void> _handleSignup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      final error = await AuthService().signup(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (error == null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final firstName = _firstNameController.text.trim();
          final lastName = _lastNameController.text.trim();

          final newUser = UserModel(
            uid: user.uid,
            email: _emailController.text.trim(),
            firstName: firstName,
            lastName: lastName,
            telephoneNumber: _telephoneController.text.trim(),
            birthDate: _selectedBirthDate!,
            isPregnant: false,
            notifications: [],
          );
          await UserService().createUserDocument(newUser);
          await user.updateDisplayName('${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}$firstName');
        }

        if (navigator.canPop()) {navigator.pop();}

      } else {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(content: Text(error))
        );
      }
    }
  }
}