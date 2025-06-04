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
    return MaterialApp(
      title: 'MamiCheck',
      theme: ThemeData(
        useMaterial3: true,
        //colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffCA3E7F)),
      ),
      debugShowCheckedModeBanner: true,
      home: const AuthWrapper(),
      onGenerateRoute: AppRouting.onGenerateRoute,
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()),);
//         } else if (snapshot.hasData) {
//           return const HomeScreen();
//         } else {
//           return const LoginScreen();
//         }
//       },
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
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         } else if (snapshot.hasData) {
//           final user = snapshot.data!;
//           return MultiProvider(
//             providers: [
//               StreamProvider<OwnedPregnancies>(
//                 create: (_) => PregnancyService()
//                     .watchOwnedPregnancies(user.uid)
//                     .map((list) => OwnedPregnancies(list)),
//                 initialData: OwnedPregnancies([]),
//               ),
//               StreamProvider<FollowedPregnancies>(
//                 create: (_) => PregnancyService()
//                     .watchFollowedPregnancies(user.uid)
//                     .map((list) => FollowedPregnancies(list)),
//                 initialData: FollowedPregnancies([]),
//               ),
//             ],
//             child: HomeScreen(),
//           );
//         } else {
//           return const LoginScreen();
//         }
//       },
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
//         } else if (snapshot.hasData) {
//           final user = snapshot.data!;
//           return MultiProvider(
//             providers: [
//               Provider<User>.value(value: user), // 👉 inyecta el usuario
//               StreamProvider<OwnedPregnancies>(
//                 create: (_) => PregnancyService()
//                     .watchOwnedPregnancies(user.uid)
//                     .map((list) => OwnedPregnancies(list)),
//                 initialData: OwnedPregnancies([]),
//                 lazy: false,
//               ),
//               StreamProvider<FollowedPregnancies>(
//                 create: (_) => PregnancyService()
//                     .watchFollowedPregnancies(user.uid)
//                     .map((list) => FollowedPregnancies(list)),
//                 initialData: FollowedPregnancies([]),
//                 lazy: false,
//               ),
//             ],
//             builder: (context, child) => const HomeScreen(),
//           );
//         } else {
//           return const LoginScreen();
//         }
//       },
//     );
//   }
// }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {return const LoginScreen();}
        // return Provider<User>.value(
        //   value: user,
        //   child: StreamProvider<List<PregnancyModel>>(
        //     create: (_) => PregnancyService().watchFollowedPregnancies(user.uid),
        //     initialData: const [],
        //     lazy: false,
        //     child: const HomeScreen(),
        //   ),
        // );
        // return Provider<User>.value(
        //   value: user,
        //   child: FutureProvider<UserModel?>(
        //     create: (_) => UserService().getUser(user.uid),
        //     initialData: null,
        //     child: StreamProvider<List<PregnancyModel>>(
        //       create: (_) => PregnancyService().watchFollowedPregnancies(user.uid),
        //       initialData: const [],
        //       lazy: false,
        //       child: const HomeScreen(),
        //     ),
        //   ),
        // );
        
        return MultiProvider(
          providers: [
            Provider<User>.value(value: user),
            FutureProvider<UserModel?>(
              create: (_) => UserService().getUser(user.uid),
              initialData: null,
              lazy: false,
            ),
            StreamProvider<List<PregnancyModel>>(
              create: (_) => PregnancyService().watchFollowedPregnancies(user.uid),
              initialData: const [],
              lazy: false,
            ),
          ],
          child: const HomeScreen(),
        );

      },
    );
  }
}