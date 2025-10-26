import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mamicheckapp/main.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:mamicheckapp/services/authentication_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TimeOfDay? notificationTime;
  List<bool> daysOfWeek = List.filled(7, false);
  final dayNames = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  
  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forceRequestAllPermissions();
    });
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      // Cargar hora (si existe)
      final savedHour = prefs.getInt('notification_hour');
      final savedMinute = prefs.getInt('notification_minute');
      if (savedHour != null && savedMinute != null) {
        notificationTime = TimeOfDay(hour: savedHour, minute: savedMinute);
      }
      
      // Cargar días de la semana
      for (int i = 0; i < 7; i++) {
        daysOfWeek[i] = prefs.getBool('day_$i') ?? false;
      }
    });
  }

  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Guardar hora
    if (notificationTime != null) {
      await prefs.setInt('notification_hour', notificationTime!.hour);
      await prefs.setInt('notification_minute', notificationTime!.minute);
    }
    
    // Guardar días de la semana
    for (int i = 0; i < 7; i++) {await prefs.setBool('day_$i', daysOfWeek[i]);}
  }

  Future<void> _saveAndScheduleNotification() async {
    final contextNotifications = ScaffoldMessenger.of(context);

    try {
      final selectedDays = daysOfWeek.asMap().entries.where((entry) => entry.value).toList();
      if (notificationTime == null) {contextNotifications.showSnackBar(const SnackBar(content: Text('⚠️ Selecciona una hora primero'))); return;}      
      if (selectedDays.isEmpty) {contextNotifications.showSnackBar(const SnackBar(content: Text('⚠️ Selecciona al menos un día de la semana'))); return;}
      await flutterLocalNotificationsPlugin.cancelAll();
      await _saveNotificationSettings();

      int notificationId = 1;
      for (var dayEntry in selectedDays) {
        int dayIndex = dayEntry.key;
        int weekdayForFlutter = dayIndex + 1;
        final scheduledDate = _nextInstanceOfWeekdayAndTime(weekdayForFlutter, notificationTime!);
        
        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId++,
          '🤱 Recordatorio de Medición',
          'No olvides registrar tus datos de salud de hoy',
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'mamicheck_recordatorios',
              'Recordatorios Semanales',
              channelDescription: 'Recordatorios para registrar mediciones',
              importance: Importance.high,
              priority: Priority.high,
              ticker: 'ticker',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }

      final daysList = selectedDays.map((entry) => dayNames[entry.key]).join(', ');
      contextNotifications.showSnackBar(
        SnackBar(content: Text('✅ Recordatorios programados: $daysList a las ${notificationTime!.format(context)}'),),
      );
      
    } catch (e) {
      print('❌ Error programando notificaciones: $e');
      contextNotifications.showSnackBar(SnackBar(content: Text('Error al programar recordatorios: $e')),);
    }
  }

  tz.TZDateTime _nextInstanceOfWeekdayAndTime(int weekday, TimeOfDay time) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      time.hour,
      time.minute,
    );
    while (scheduledDate.weekday != weekday) {scheduledDate = scheduledDate.add(const Duration(days: 1));}
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {scheduledDate = scheduledDate.add(const Duration(days: 7));}
    return scheduledDate;
  }

  Future<void> _forceRequestAllPermissions() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.notification.request();
    }
    final status2 = await Permission.scheduleExactAlarm.status;
    if (status2.isDenied || status2.isPermanentlyDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> _checkPermissionStatus() async {
    final contextPermissions = ScaffoldMessenger.of(context);
    
    try {
      final notificationStatus = await Permission.notification.status;
      final scheduleStatus = await Permission.scheduleExactAlarm.status;
      print('📱 Notification status: $notificationStatus');
      print('⏰ Schedule status: $scheduleStatus');
      
      String message = '';
      if (notificationStatus.isGranted && scheduleStatus.isGranted) {message = '✅ Todos los permisos están concedidos';} 
      else if (notificationStatus.isGranted) {message = '⚠️ Solo notificaciones concedidas. Faltan alarmas exactas';} 
      else if (scheduleStatus.isGranted) {message = '⚠️ Solo alarmas exactas concedidas. Faltan notificaciones';} 
      else {message = '❌ Faltan ambos permisos';}
      contextPermissions.showSnackBar(SnackBar(content: Text(message)));

      // Si faltan permisos, ofrecer solicitarlos
      if (!notificationStatus.isGranted || !scheduleStatus.isGranted) {_showPermissionDialog('los permisos faltantes');}
      
    } catch (e) {print('Error: $e');contextPermissions.showSnackBar(SnackBar(content: Text('Error: $e')));}
  }

  void _showPermissionDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Se Requieren Permisos'),
          content: Text('Para recibir recordatorios importantes sobre tu embarazo, necesitas habilitar $permissionType en la configuración del sistema.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
            TextButton(onPressed: () {Navigator.of(context).pop(); openAppSettings();}, child: Text('Ir a Configuración')),
          ],
        );
      },
    );
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: notificationTime ?? TimeOfDay.now(),
      helpText: 'Selecciona la hora de tu recordatorio',
      cancelText: 'Cancelar',
      confirmText: 'OK',
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked != null) {setState(() => notificationTime = picked);}
  }

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel?>();

    if (userModel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil y Ajustes'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.primaries[userModel.uid.hashCode.abs() % Colors.primaries.length].shade900,
                      child: Text(userModel.firstName[0]+userModel.lastName[0], style: TextStyle(color: Colors.primaries[userModel.uid.hashCode.abs() % Colors.primaries.length].shade100)),
                    ),
                    const SizedBox(height: 12),
                    Text('${userModel.firstName} ${userModel.lastName}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),),
                    Text(userModel.email, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.cake, color: Theme.of(context).colorScheme.primary),
                    title: Text('Fecha de nacimiento', style: Theme.of(context).textTheme.labelMedium),
                    subtitle: Text('${userModel.birthDate.day}/${userModel.birthDate.month}/${userModel.birthDate.year}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Theme.of(context).colorScheme.primary),
                    title: Text('Teléfono', style: Theme.of(context).textTheme.labelMedium),
                    subtitle: Text(userModel.telephoneNumber, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
                    title: Text('Contraseña', style: Theme.of(context).textTheme.labelMedium),
                    subtitle: Text('Vigente', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                    trailing: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          final dialognavigator = Navigator.of(dialogContext);
                          return AlertDialog(
                            title: const Text('¿Deseas cambiar tu Contraseña?'),
                            content: const Text('Se enviará un enlace a tu correo electrónico para que puedas crear una nueva contraseña. Por favor, revisa tu bandeja de entrada y, si no lo encuentras, revisa también la carpeta de spam.'),
                            actions: [
                              FilledButton(child: const Text('No gracias'), onPressed: () {dialognavigator.pop();}),
                              TextButton(
                                child: const Text('Acepto'),
                                onPressed: () async {
                                  final emailMessenger = ScaffoldMessenger.of(context);
                                  try {
                                    await FirebaseAuth.instance.sendPasswordResetEmail(email: userModel.email);
                                    emailMessenger.showSnackBar(const SnackBar(content: Text('Se envio un correo de cambio de contraseña')));
                                    dialognavigator.pop();         
                                  } catch (e) {
                                    emailMessenger.showSnackBar(const SnackBar(content: Text('Error al enviar el correo. Intenta de nuevo.')));          
                                  }
                                },
                              )
                            ], 
                          );
                        }
                      );
                    },
                      child: const Text('Cambiar'),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text('Recordatorios',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.access_time_filled, color: Theme.of(context).colorScheme.primary),
                    title: Text('Hora de alerta', style: Theme.of(context).textTheme.labelMedium),
                    subtitle: Text(notificationTime?.format(context) ?? 'No establecida', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                    trailing: TextButton(
                      onPressed:  _selectTime,
                      child: const Text('Cambiar'),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.primary),
                    title: Text('Día(s) de la alerta', style: Theme.of(context).textTheme.labelMedium),
                    subtitle: Text(
                      daysOfWeek.asMap().entries.where((e) => e.value).map((e) => dayNames[e.key]).join(', ').isEmpty ? 'No establecido' :
                      daysOfWeek.asMap().entries.where((e) => e.value).map((e) => dayNames[e.key]).join(', '),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        showDialog<List<bool>>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            final dialognavigator = Navigator.of(dialogContext);

                            List<bool> tempDays = List.from(daysOfWeek);

                            return AlertDialog(
                              title: const Text('¿Qué días deseas recibir el Recordatorio?'),
                              content: StatefulBuilder(
                                builder: (context, setState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Haz clic para escoger los días de la semana en los que te gustaría que la app te envíe una notificación.'),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        children: List.generate(7, (i) {
                                          return FilterChip(
                                            label: Text(dayNames[i], style: TextStyle(color: tempDays[i] ? Colors.white : null,),),
                                            selected: tempDays[i],
                                            selectedColor: Colors.red,
                                            checkmarkColor: Colors.white,
                                            onSelected: (_) {setState(() => tempDays[i] = !tempDays[i]);},
                                          );
                                        }),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              actions: [
                                TextButton(child: const Text('Cancelar'), onPressed: () {dialognavigator.pop();},), // no devuelve nada
                                TextButton(child: const Text('OK'), onPressed: () {dialognavigator.pop(tempDays);},), // 👈 devolvemos la selección
                              ],
                            );
                          },
                        ).then((result) {if (result != null) {setState(() => daysOfWeek = result);}}); // 👈 solo actualizamos al guardar
                      },
                      child: const Text('Cambiar'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceContainerHigh,             
                child: Column(
                  spacing: 0,
                  children: [
                    ListTile(
                      title: Text('Configura la hora y dias de la semana para que te enviemos recordatorios según tu disponibilidad', style: Theme.of(context).textTheme.labelMedium),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                FilledButton.icon(onPressed: () {
                  _saveAndScheduleNotification();
                }, icon: const Icon(Icons.save), label: Text('Guardar cambios')),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        final dialognavigator = Navigator.of(dialogContext);
                        return AlertDialog(
                          title: const Text('¿Cuándo programar mis recordatorios?'),
                          content: const Text('Es importante que tomes tus mediciones a una hora fija. Piensa en tu rutina y elige un momento en el que no tengas prisa. Te sugerimos la siguiente frecuencia:\n\n1er trimestre: Al menos una vez a la semana.\n2do trimestre: Al menos dos veces a la semana.\n3er trimestre: Al menos tres veces a la semana.'),
                          actions: [TextButton(child: const Text('OK'), onPressed: () {dialognavigator.pop();})], 
                        );
                      }
                    );
                  }, 
                  child: Text('Ayuda')
                ),
              ],),
            ),
            const SizedBox(height: 24),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text('Activar Notificaciones',style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                  const SizedBox(height: 8),
                  Text('Configura el acceso a notificaciones en tu Celular. Tambien puedes ver una previsualización'),
                  const SizedBox(height: 8),
                  Row(children: [
                    OutlinedButton(onPressed: _checkPermissionStatus, child: Text('Solicitar Permisos')),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Se envio una notificacion de prueba')),
                        );
                        _showTestNotification();
                      }, 
                      child: Text('Demostración')
                    ),
                  ],)
                ],
              ),
            ),
            const SizedBox(height: 24),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton.icon(
                icon: Icon(Icons.logout, color: Color.fromRGBO(183, 28, 28, 1)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      final dialognavigator = Navigator.of(dialogContext);
                      return AlertDialog(
                        title: const Text('¿Deseas cerrar sesión?'),
                        content: const Text('Si continuas, se cerrará la sesión de tu cuenta y volverás a la pantalla de login.\n\nTendrás que volver a acceder para usar el resto de funciones.'),
                        actions: [
                          FilledButton(
                            child: const Text('No gracias'),
                            onPressed: () {
                              dialognavigator.pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Acepto'),
                            onPressed: () async {
                              dialognavigator.pop();
                              await Future.delayed(Duration.zero);
                              await AuthService().signout();                              
                            },
                          )
                        ], 
                      );
                    }
                  );
                },
                label: Text('Cerrar Sesión', style: TextStyle(color: Color.fromRGBO(183, 28, 28, 1)))
              )
            ),

TextButton(
  onPressed: _testImmediateNotification,
  child: Text('Test Timezone'),
),
TextButton(
  onPressed: _testTimezone2,
  child: Text('Test Timezone2 eeeeeeeeeeee'),
),

            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }

  Future<void> _showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'mamicheck_channel',
      'Mamicheck Notificaciones',
      channelDescription: 'Notificaciones de ejemplo',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Mamicheck',
      'Esta es una Notificación de Ejemplo',
      notificationDetails,
    );
  }

  Future<void> _testImmediateNotification() async {
    try {
      final testTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));
      
      await flutterLocalNotificationsPlugin.zonedSchedule(
        999,
        '🧪 TEST INMEDIATO',
        'Si ves esto, las notificaciones programadas funcionan!',
        testTime,
        // ✅ USAR EL CANAL QUE SABEMOS QUE FUNCIONA
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mamicheck_channel',        // ← Mismo canal
            'Mamicheck Notificaciones',
            channelDescription: 'Notificaciones de ejemplo',
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⏱️ Test con canal conocido programado para 10 segundos')),
      );
      
    } catch (e) {
      print('Error test: $e');
    }
  }


  Future<void> _testTimezone2() async {

  try {
    final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('📱 Total pendientes: ${pending.length}');
    
    if (pending.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ No hay notificaciones pendientes - no se programaron')),
      );
    } else {
      for (var notification in pending) {
        print('✅ ID ${notification.id}: ${notification.title}');
        print('   Payload: ${notification.payload}');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('📱 ${pending.length} notificaciones están programadas')),
      );
    }
  } catch (e) {
    print('Error verificando: $e');
  }

  _checkNotificationPermissions();
}

Future<void> _checkNotificationPermissions() async {
  // Verificar si pueden mostrar notificaciones
  final plugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
  final bool? result = await plugin?.areNotificationsEnabled();
  print('📱 Notificaciones habilitadas: $result');
  
  if (result == false) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Las notificaciones están deshabilitadas en el sistema')),
    );
  }
}



}