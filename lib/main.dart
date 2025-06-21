import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/navigation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mamicheckapp/screens/access/login_screen.dart';
import 'package:mamicheckapp/screens/home/home_screen.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';
import 'package:mamicheckapp/services/user_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(212, 0, 255, 1)));
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {return MaterialApp(theme: theme,home: Scaffold(body: Center(child: CircularProgressIndicator())));}
        final user = snapshot.data;
        if (user == null) {return MaterialApp(theme: theme, home: LoginScreen());}
        return MultiProvider(
          providers: [
            Provider<User>.value(value: user),
            FutureProvider<UserModel?>(
              create: (_) => UserService().getUser(user.uid),
              initialData: null,
              lazy: false,
            ),
            StreamProvider<List<PregnancyModel>>(
              create: (_) => PregnancyService().watchFollowedPregnancies(user.uid).map((pregnancies) {
                pregnancies.sort((a, b) {
                  final activeCompare = b.isActive.toString().compareTo(a.isActive.toString());
                  if (activeCompare != 0) return activeCompare;

                  final roleA = a.followers[user.uid];
                  final roleB = b.followers[user.uid];
                  if (roleA == roleB) return 0;
                  if (roleA == 'owner') return -1;
                  return 1;
                });
                return pregnancies;
              }),
              initialData: const [],
              lazy: false,
            ),
          ],
          child: MaterialApp(
            title: 'Mamicheck',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: const HomeScreen(),
            onGenerateRoute: AppRouting.onGenerateRoute,
          ),
        );
      },
    );
  }
}