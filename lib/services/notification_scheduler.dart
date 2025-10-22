import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mamicheckapp/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Llama esto en main() al inicio
void initializeTimezones() {
  tz.initializeTimeZones();
}

/// Programa notificaciones semanales en los días y hora seleccionados
Future<void> scheduleWeeklyNotifications(TimeOfDay notificationTime, List<bool> daysOfWeek) async {
  final plugin = flutterLocalNotificationsPlugin;
  await plugin.cancelAll(); // Borra notificaciones anteriores

  final androidDetails = AndroidNotificationDetails(
    'mamicheck_channel',
    'Mamicheck Notificaciones',
    channelDescription: 'Recordatorios de mediciones',
    importance: Importance.max,
    priority: Priority.high,
  );

  final notificationDetails = NotificationDetails(android: androidDetails);

  for (int i = 0; i < 7; i++) {
    if (daysOfWeek[i]) {
      final scheduledDate = _nextInstanceOfWeekday(i + 1, notificationTime.hour, notificationTime.minute);
      await plugin.zonedSchedule(
        i + 1, // ID único por día
        'Mamicheck',
        '¡No te olvides de tu Medición de Hoy!',
        scheduledDate,
        notificationDetails,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexact,
      );
    }
  }
}

/// Encuentra la próxima fecha que coincide con un día de la semana y hora específicos
tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}
