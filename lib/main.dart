import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MamiCheck',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouting.initialRoute,
      routes: AppRouting.getRoutes(),
    );
  }
}