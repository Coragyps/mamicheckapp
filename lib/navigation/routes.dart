import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens/screens.dart';

class AppRouting {
  static const initialRoute = 'LoginScreen';
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> appRoute = {};

    appRoute.addAll({
      "LoginScreen":(BuildContext context) => LoginScreen() 
    });

    appRoute.addAll({
      "RegisterScreen":(BuildContext context) => RegisterScreen() 
    });

    appRoute.addAll({
      "MeasurementsScreen":(BuildContext context) => MeasurementsScreen() 
    });

    appRoute.addAll({
      "APITest":(BuildContext context) => ApiTest() 
    });

    appRoute.addAll({
      "MyHomePage": (BuildContext context) {
        final args = ModalRoute.of(context)!.settings.arguments as MyHomePageArguments;
        //final args = MyHomePageArguments(title: 'Flutter Demo Home Page');
        return MyHomePage(title: args.title);
      }
    });

    appRoute.addAll({
      "HomeScreen":(BuildContext context) => HomeScreen() 
    });

    appRoute.addAll({
      "HelpScreen":(BuildContext context) => HelpScreen() 
    });

    appRoute.addAll({
      "NotificationScreen":(BuildContext context) => NotificationScreen() 
    });

    appRoute.addAll({
      "ProfileScreen":(BuildContext context) => ProfileScreen() 
    });

    appRoute.addAll({
      "SettingsScreen":(BuildContext context) => SettingsScreen() 
    });

    return appRoute;
  }
}