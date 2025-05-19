import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/screens/access/login_screen.dart';
import 'package:mamicheckapp/screens/home/home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Esperando la respuesta o conexión activa
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si hay usuario logueado
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Si no hay usuario logueado
        return const LoginScreen();
      }
    );
  }
}