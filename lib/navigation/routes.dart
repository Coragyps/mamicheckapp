import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens/screens.dart';

class AppRouting {
  static const initialRoute = 'LoginScreen';
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> appRoute = {};

    appRoute.addAll({
      "LoginScreen":(BuildContext context) => LoginScreen(),
      "RegisterScreen":(BuildContext context) => RegisterScreen(),

      "MeasurementsScreen":(BuildContext context) => MeasurementsScreen(),

      "APITest":(BuildContext context) => ApiTest(),
      "MyHomePage": (BuildContext context) {
        final args = ModalRoute.of(context)!.settings.arguments as MyHomePageArguments;
        //final args = MyHomePageArguments(title: 'Flutter Demo Home Page');
        return MyHomePage(title: args.title);
      },

      "HomeScreen":(BuildContext context) => HomeScreen(),

      "HelpScreen":(BuildContext context) => HelpScreen(),
      "NotificationScreen":(BuildContext context) => NotificationScreen(),
      "ProfileScreen":(BuildContext context) => ProfileScreen(),
      "SettingsScreen":(BuildContext context) => SettingsScreen() 
    });

    appRoute.addAll({
      "APITest":(BuildContext context) => ApiTest() 
    });
    
    return appRoute;
  }
}