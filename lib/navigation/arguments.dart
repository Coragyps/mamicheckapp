import 'package:mamicheckapp/models/measurement_model.dart';

class MyHomePageArguments {
  final String title;
  MyHomePageArguments({required this.title});
}
class MeasurementDialogArguments{
  final String pregnancyId;
  final List<MeasurementModel> currentMeasurements;
  final DateTime birthDate;
  MeasurementDialogArguments({required this.birthDate, required this.currentMeasurements, required this.pregnancyId});
}
class PregnancyDialogArguments{
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime birthDate;
  PregnancyDialogArguments({required this.uid, required this.firstName, required this.birthDate, required this.lastName, required this.email,});
}
class MeasurementsScreenArguments{
  final String pregnancyId;
  MeasurementsScreenArguments({required this.pregnancyId});
}