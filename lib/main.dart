import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Inicializa zonas horarias
//   tz.initializeTimeZones();
//   tz.setLocalLocation(tz.getLocation('America/Lima')); // o tu zona horaria local

//   // Inicializar notificaciones
//   const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//   const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   // Leer color favorito guardado o usar el por defecto
//   final prefs = await SharedPreferences.getInstance();
//   final colorValue = prefs.getInt('favoriteColor');
//   final seedColor = colorValue == null ? const Color.fromRGBO(212, 0, 255, 1) : Color(colorValue);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {

//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(212, 0, 255, 1)));
//     final dummyPregnancy = PregnancyModel(id: 'dummy', name: '', isActive: false, lastMenstrualPeriod: DateTime(2000), followers: {}, measurements: []);

//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {return MaterialApp(title: 'Mamicheck', debugShowCheckedModeBanner: false, theme: theme,home: Scaffold(body: Center(child: CircularProgressIndicator())));}
//         final user = snapshot.data;
//         if (user == null) {return MaterialApp(title: 'Mamicheck', debugShowCheckedModeBanner: false, theme: theme, home: LoginScreen());}
//         return MultiProvider(
//           providers: [
//             StreamProvider<UserModel?>(
//               create: (_) => UserService().watchUser(user.uid),
//               initialData: null,
//               lazy: false,
//             ),
//             StreamProvider<List<PregnancyModel>>(
//               create: (_) => PregnancyService().watchFollowedPregnancies(user.uid).map((pregnancies) {
//                 pregnancies.sort((a, b) {
//                   final activeCompare = b.isActive.toString().compareTo(a.isActive.toString());
//                   if (activeCompare != 0) return activeCompare;

//                   final roleA = a.followers[user.uid];
//                   final roleB = b.followers[user.uid];
//                   if (roleA == roleB) return 0;
//                   if (roleA == 'owner') return -1;
//                   return 1;
//                 });
//                 return pregnancies;
//               }),
//               initialData: [dummyPregnancy],
//               lazy: false,
//             ),
//           ],
//           child: MaterialApp(
//             title: 'Mamicheck',
//             debugShowCheckedModeBanner: false,
//             theme: theme,
//             home: const HomeScreen(),
//             onGenerateRoute: AppRouting.onGenerateRoute,
//           ),
//         );
//       },
//     );
//   }
// }


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      title: 'Mamicheck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(212, 0, 255, 1))),
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