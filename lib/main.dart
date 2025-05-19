import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mamicheckapp/screens/access/auth_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final user = FirebaseAuth.instance.currentUser;
  final initialRoute = user == null ? 'LoginScreen' : 'HomeScreen';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MamiCheck',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffCA3E7F)),
      ),
      debugShowCheckedModeBanner: true,
      //initialRoute: AppRouting.initialRoute,
      //home: const AuthScreen(),
      initialRoute: initialRoute,
      routes: AppRouting.getRoutes(),
    );
  }
}