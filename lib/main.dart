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

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MamiCheck',
//       theme: ThemeData(
//         useMaterial3: true,
//         //colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffCA3E7F)),
//       ),
//       debugShowCheckedModeBanner: true,
//       home: const AuthWrapper(),
//       onGenerateRoute: AppRouting.onGenerateRoute,
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         final user = snapshot.data;
//         if (user == null) {return const LoginScreen();}
//         return MultiProvider(
//           providers: [
//             Provider<User>.value(value: user),
//             FutureProvider<UserModel?>(
//               create: (_) => UserService().getUser(user.uid),
//               initialData: null,
//               lazy: false,
//             ),
//             StreamProvider<List<PregnancyModel>>(
//               create: (_) => PregnancyService().watchFollowedPregnancies(user.uid),
//               initialData: const [],
//               lazy: false,
//             ),
//           ],
//           child: const HomeScreen(),
//         );

//       },
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));}
        final user = snapshot.data;
        if (user == null) {return const MaterialApp(home: LoginScreen());}
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
                  // Primero por activos (true > false)
                  final activeCompare = b.isActive.toString().compareTo(a.isActive.toString());
                  if (activeCompare != 0) return activeCompare;

                  // Luego por rol del usuario (owner antes que companion)
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
            // StreamProvider<PregnancyGroups>(
            //   create: (_) => PregnancyService().watchFollowedPregnancies(user.uid).map((pregnancies) {
            //     return PregnancyGroups(
            //       ownedActive: pregnancies.where((p) =>
            //         p.followers[user.uid] == 'owner' && p.isActive).toList(), 
            //       followedActive: pregnancies.where((p) =>
            //         p.followers[user.uid] == 'companion' && p.isActive).toList(), 
            //       finished: pregnancies.where((p) => !p.isActive).toList(), 
            //     );
            //   }),
            //   initialData: PregnancyGroups(),
            //   lazy: false,
            // ),
          ],
          child: MaterialApp(
            title: 'MamiCheck',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(212, 0, 255, 1))),
            //theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(18, 169, 56, 1))),
            //theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(60, 49, 27, 1))),
            home: const HomeScreen(),
            onGenerateRoute: AppRouting.onGenerateRoute,
          ),
        );
      },
    );
  }
}