import 'package:flutter/material.dart';
import 'package:mamicheckapp/screens/access/register_dialog.dart';
import 'package:mamicheckapp/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 75,
      //   centerTitle: true,
      //   title: ListTile(
      //     leading: Image(image: AssetImage('assets/img/logo.png'), fit: BoxFit.contain),
      //     title: Text('Mamicheck'),
      //     titleTextStyle: Theme.of(context).textTheme.displayMedium?.copyWith(fontFamily: 'caveat', color: Color(0xffCA3E7F), height: 0.9),
      //     subtitle: Text('Tu Aliado en el Embarazo'),
      //     subtitleTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed),
      //   ),
      // ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/img/logo.png'), fit: BoxFit.contain, height: 54),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Mamicheck', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontFamily: 'caveat', color: Color(0xffCA3E7F), height: 0.8)),
                Text('Tu Aliado en el Embarazo', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryFixed)),
              ],
            ),
          ],
        ),
      ),
      body: _body(context),
      bottomNavigationBar: _navbar(context),
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                              labelText: 'Correo Electronico',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>  value == null || value.isEmpty ? 'El correo no puede estar en blanco' : null,
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
                            validator: (value) => value == null || value.isEmpty ? 'La contraseña no puede estar en blanco' : null,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // FilledButton(
                //   onPressed: () {
                //     _emailController.text = 'mamicheckroot@gmail.com';
                //     _passwordController.text = '123456';
                //     _handleSignin(context);
                //   }, child: const Text("mamicheckroot (debug)"),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navbar(BuildContext context) {
    return BottomAppBar(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton.icon(
              icon: const Icon(Icons.login),
              onPressed: () => _handleSignin(context),
              label: const Text('Ingresar'),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                _formKey.currentState?.reset();
                //Navigator.pushNamed(context, 'RegisterDialog');
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterDialog(), fullscreenDialog: true));
              },
              label: const Text('Registrarse'),
            )
          ],
        ),
    );
  }

  Future <void> _handleSignin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final messenger = ScaffoldMessenger.of(context);

      final error = await AuthService().signin(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // if (error == null) {
      //   // navigator.pushNamedAndRemoveUntil('HomeScreen', (_) => false);
      //   navigator.pushReplacementNamed('HomeScreen');
      // } else {
      //   messenger.showSnackBar(
      //     SnackBar(content: Text(error))
      //   );
      // }
      if (error != null) {
        messenger.showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }
}
