import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens/screens.dart';

// class AppRouting {
//   static Map<String, Widget Function(BuildContext)> getRoutes() {
//     Map<String, Widget Function(BuildContext)> appRoute = {};

//     appRoute.addAll({
//       "LoginScreen":(BuildContext context) => LoginScreen(),
//       "RegisterScreen":(BuildContext context) => const RegisterScreen(),

//       "MeasurementsScreen":(BuildContext context) => MeasurementsScreen(),

//       "APITest":(BuildContext context) => ApiTest(),
//       "MyHomePage": (BuildContext context) {
//         final args = ModalRoute.of(context)!.settings.arguments as MyHomePageArguments;
//         return MyHomePage(title: args.title);
//       },

//       "HomeScreen":(BuildContext context) => HomeScreen(),

//       "HelpScreen":(BuildContext context) => HelpScreen(),
//       "NotificationScreen":(BuildContext context) => NotificationScreen(),
//       "ProfileScreen":(BuildContext context) => ProfileScreen(),
//       "SettingsScreen":(BuildContext context) => SettingsScreen() 
//     });
//     return appRoute;
//   }
// }

class AppRouting {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //access
      case 'LoginScreen':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      
      case 'RegisterDialog':
        return MaterialPageRoute(
          fullscreenDialog: true, // estilo Material 3 para formularios
          builder: (_) => const RegisterDialog(),
        );

      // case 'MeasurementsScreen':
      //   return MaterialPageRoute(builder: (_) => MeasurementsScreen());

      case 'MeasurementsScreen':
        final args = settings.arguments as MeasurementsScreenArguments;
        return MaterialPageRoute(builder: (_) => MeasurementsScreen(pregnancyId: args.pregnancyId));

      case 'APITest':
        return MaterialPageRoute(builder: (_) => ApiTest());

      case 'MyHomePage':
        final args = settings.arguments as MyHomePageArguments;
        return MaterialPageRoute(
          builder: (_) => MyHomePage(title: args.title),
        );

      case 'MeasurementDialog':
        final args = settings.arguments as MeasurementDialogArguments;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => MeasurementDialog(pregnancy: args.pregnancy, birthDate: args.birthDate,), 
        );

      case 'PregnancyDialog':
        final args = settings.arguments as PregnancyDialogArguments;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => PregnancyDialog(firstName: args.firstName, birthDate: args.birthDate, uid: args.uid,),
        );

      case 'HomeScreen':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case 'HelpScreen':
        return MaterialPageRoute(builder: (_) => HelpScreen());

      case 'NotificationScreen':
        return MaterialPageRoute(builder: (_) => NotificationScreen());

      case 'ProfileScreen':
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case 'SettingsScreen':
        return MaterialPageRoute(builder: (_) => SettingsScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
    }
  }
}