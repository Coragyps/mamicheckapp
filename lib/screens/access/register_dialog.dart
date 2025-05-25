import 'package:firebase_auth/firebase_auth.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/services/auth_service.dart';
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
  final _birthDateController = TextEditingController();

  DateTime? _selectedBirthDate;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _titlebar(context),
      body: _body(context),
      //body: Text('aea'),
      // bottomNavigationBar: _navbar(context),
    );
  }

  PreferredSizeWidget _titlebar(BuildContext context) {
    return AppBar(
      title: Text('Registrarse'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FilledButton(
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
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombres',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter your First Name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Apellidos',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter your Last Name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthDateController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Birth Date', suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () async {
                  final initial = DateTime(2000);
                  final firstDate = DateTime(1900);
                  final lastDate = DateTime(2020);
                  final pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: initial,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDatePickerMode: DatePickerMode.year,
                    helpText: 'Fecha de Nacimiento',
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
                validator: (value) => value == null || value.isEmpty ? 'Select Birth Date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo Electronico',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Enter an email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
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
                validator: (value) => value != null && value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _navbar(BuildContext context) {
  //   return BottomAppBar(
  //     child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           //Text('¿Ya tienes una cuenta?'),
  //           ElevatedButton.icon(
  //             icon: const Icon(Icons.home),
  //             onPressed: () {
  //               //_formKey.currentState?.reset();
  //               Navigator.pop(context);
  //             },
  //             label: const Text('Regresar a Inicio'),
  //           )
  //         ],
  //       ),
  //   );
  // }  

  Future <void> _handleSignup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context, rootNavigator: true);

      final error = await AuthService().signup(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (error == null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final newUser = UserModel(
            uid: user.uid,
            email: _emailController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            birthDate: _selectedBirthDate!,
            isPregnant: false,
          );
          await UserService().createUserDocument(newUser);
        }
        navigator.pushNamedAndRemoveUntil('HomeScreen', (_) => false);
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text(error))
        );
      }
    }
  }
}