import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/navigation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mamicheckapp/screens/login_screen.dart';
import 'package:mamicheckapp/screens/home_screen.dart';
import 'package:mamicheckapp/services/pregnancy_service.dart';
import 'package:mamicheckapp/services/user_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final systemLocale = await findSystemLocale();
  Intl.defaultLocale = systemLocale; // Ejemplo: 'es_PE'
  await initializeDateFormatting(Intl.defaultLocale, null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Lima'));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final colorss = ColorScheme.fromSeed(seedColor: Color.fromRGBO(212, 0, 255, 1));
    return MaterialApp(
      title: 'Mamicheck',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(212, 0, 255, 1))),

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorss,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: colorss.onPrimaryFixed,
        ),
      ),

      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {        
        //if (snapshot.connectionState == ConnectionState.waiting) {return const Scaffold(body: Center(child: CircularProgressIndicator(),));}


        final user = snapshot.data;

        // return AnimatedSwitcher(
        //   duration: const Duration(milliseconds: 5000),
        //   switchInCurve: Curves.easeOut,              
        //   switchOutCurve: Curves.easeIn,      
        //   transitionBuilder: (child, animation) {
        //     //return FadeTransition(opacity: animation, child: child);
        //     return SlideTransition(position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation), child: child);
        //   },
        //   child: user != null ? AuthenticatedApp(user: user, key: ValueKey('auth_${user.uid}')) : const LoginScreen(key: ValueKey('login'))
        // );

        return user != null ? AuthenticatedApp(user: user) : LoginScreen();
      },
    );
  }
}

class AuthenticatedApp extends StatelessWidget {
  final User user;
  final PregnancyModel dummyPregnancy = PregnancyModel(id: 'dummy', name: '', isActive: false, lastMenstrualPeriod: DateTime(2000), followers: {}, measurements: []);

  AuthenticatedApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>(create: (_) => UserService().watchUser(user.uid), initialData: null, lazy: false),
        StreamProvider<List<PregnancyModel>>(
          create: (_) => PregnancyService().watchFollowedPregnancies(user.uid).map((pregnancies) {

            String getRoleFromFollowerData(String? followerData) {
              if (followerData == null || followerData.isEmpty) return 'none';
              final parts = followerData.split('||');
              return parts.first; 
            }

            pregnancies.sort((a, b) {
              final activeCompare = b.isActive.toString().compareTo(a.isActive.toString());
              if (activeCompare != 0) return activeCompare;

              final roleA = getRoleFromFollowerData(a.followers[user.uid]);
              final roleB = getRoleFromFollowerData(b.followers[user.uid]);
              if (roleA == roleB) return 0;
              if (roleA == 'owner') return -1;
              return 1;
            });
            return pregnancies;
          }),
          initialData: [dummyPregnancy],
          lazy: false,
        ),
      ],
      child: Navigator(
        onGenerateRoute: (settings) {
          if (settings.name == null) {return MaterialPageRoute(builder: (_) => const HomeScreen());}
          return AppRouting.onGenerateRoute(settings);
        },
      ),
    );
  }
}