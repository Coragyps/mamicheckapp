import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
      bottomNavigationBar: _signmethod(context),
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
                    filled: true,
                    labelText: "Email",
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Email is Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Password",
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
                      value == null || value.isEmpty ? 'Password is Required' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final error = await AuthService().signin(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      if (!mounted) return;
                      if (error == null) {
                        Navigator.pushReplacementNamed(context, "HomeScreen");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error), behavior: SnackBarBehavior.floating),
                        );
                      }
                    }
                  },
                  child: const Text("Sign In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signmethod(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "New user? ",
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: "Create Account",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
              ..onTap = () {
                _formKey.currentState?.reset();
                Navigator.pushNamed(context, "RegisterScreen");
              }
            ),
          ],
        ),
      ),
    );
  }
}
