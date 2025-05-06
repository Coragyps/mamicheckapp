import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/services/auth_service.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _titlebar(context),
      body: _body(context),
    );
  }

  PreferredSizeWidget _titlebar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(FirebaseAuth.instance.currentUser!.email!.toString(),),
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hello👋'),
              const SizedBox(height: 16,),
              ElevatedButton(
                onPressed: () async {
                  await AuthService().signout();
                  Navigator.pushReplacementNamed(context, "LoginScreen");
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}