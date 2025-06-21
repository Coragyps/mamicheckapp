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
      appBar: AppBar(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mi Historial:', style: TextStyle(
                  fontFamily: 'Caveat',
                  fontSize: 42,
                )),
                //const SizedBox(height: 16),
                Text('Quisit odio, at nobis minima, ullam. Minimaquos, cumque aut velit sunt, animi! Nihiliure, hic tempora amet dolores libero. Hicneque tempora sit, quam eos odit! Laborumanimi, quo, tempora ad tempora animi! Nesciuntsed unde alias unde sit, ad. Aliasdolores rem, in rem, ipsum sed. Temporasunt eveniet nobis amet ullam in. Modiad ullam, vero et amet ut? Sintvitae in, nesciunt, quis nihil eos! '),
                const SizedBox(height: 46),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Correo Electronico",
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'El correo no puede estar en blanco' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Contraseña",
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
                  validator: (value) =>
                      value == null || value.isEmpty ? 'La contraseña no puede estar en blanco' : null,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => _handleSignin(context),
                  child: const Text("Ingresar"),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    _emailController.text = 'mamicheckroot@gmail.com';
                    _passwordController.text = '123456';
                    _handleSignin(context);
                  },
                  child: const Text(
                    "mamicheckroot (debug)",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                )
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('¿Aun no tienes una cuenta?',),
            ElevatedButton.icon(
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
