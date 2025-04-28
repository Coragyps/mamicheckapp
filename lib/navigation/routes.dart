import 'package:flutter/material.dart';
import 'package:mamicheckapp/navigation/arguments.dart';
import 'package:mamicheckapp/screens/my_home_page.dart';

class AppRouting {
  static const initialRoute = 'MyHomePage';
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> appRoute = {};

    appRoute.addAll({
      "MyHomePage": (BuildContext context) {
        //final args = ModalRoute.of(context)!.settings.arguments as MyHomePageArguments;
        final args = MyHomePageArguments(title: 'Flutter Demo Home Page');
        return MyHomePage(title: args.title);
      }
    });

    return appRoute;
  }
}