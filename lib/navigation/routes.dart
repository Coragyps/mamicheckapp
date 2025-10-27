import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens.dart';

class AppRouting {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //access
      case 'LoginScreen':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      
      case 'RegisterDialog':
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const RegisterDialog(),
        );

      case 'MeasurementsScreen':
        final args = settings.arguments as MeasurementsScreenArguments;
        return MaterialPageRoute(builder: (_) => MeasurementsScreen(pregnancyId: args.pregnancyId));

      case 'MeasurementDialog':
        final args = settings.arguments as MeasurementDialogArguments;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => MeasurementDialog(birthDate: args.birthDate, pregnancyId: args.pregnancyId, currentMeasurements: args.currentMeasurements), 
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

      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}