import 'package:mamicheckapp/models/pregnancy_model.dart';

class MyHomePageArguments {
  final String title;
  MyHomePageArguments({required this.title});
}
class MeasurementDialogArguments{
  final PregnancyModel pregnancy;
  final DateTime birthDate;
  MeasurementDialogArguments({required this.pregnancy, required this.birthDate});
}
class PregnancyDialogArguments{
  final String uid;
  final String firstName;
  final DateTime birthDate;
  PregnancyDialogArguments({required this.uid, required this.firstName, required this.birthDate});
}
class MeasurementsScreenArguments{
  final String pregnancyId;
  MeasurementsScreenArguments({required this.pregnancyId});
}