import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mamicheckapp/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  TimeOfDay? notificationTime;
  List<bool> daysOfWeek = List.filled(7, false);
  Color? favoriteColor;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _loadSettings();
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      final hour = prefs.getInt('notificationHour');
      final minute = prefs.getInt('notificationMinute');
      if (hour != null && minute != null) {
        notificationTime = TimeOfDay(hour: hour, minute: minute);
      }
      daysOfWeek = List.generate(7, (i) => prefs.getBool('day_$i') ?? false);
      final colorValue = prefs.getInt('favoriteColor');
      if (colorValue != null) {
        favoriteColor = Color(colorValue);
      }
    });
  }

  Future<void> _saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('favoriteColor', color.value);
    setState(() => favoriteColor = color);
  }

  Future<void> _resetColor() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favoriteColor');
    setState(() => favoriteColor = null);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: notificationTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('notificationHour', picked.hour);
      await prefs.setInt('notificationMinute', picked.minute);
      setState(() => notificationTime = picked);
    }
  }

  void _toggleDay(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      daysOfWeek[index] = !daysOfWeek[index];
    });
    await prefs.setBool('day_$index', daysOfWeek[index]);
  }

  Future<void> _updateNotificationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      notificationsEnabled = value;
      if (!value) {
        daysOfWeek = List.filled(7, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final themeColor = favoriteColor ?? Color.fromRGBO(212, 0, 255, 1);
    

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text('Habilitar notificaciones', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                  value: notificationsEnabled,
                  onChanged: _updateNotificationEnabled,
                ),
                ListTile(
                  title: const Text('Hora de alerta'),
                  subtitle: Text(notificationTime?.format(context) ?? 'No establecida'),
                  trailing: ElevatedButton.icon(
                    label: Text('Cambiar'),
                    icon: const Icon(Icons.access_time),
                    onPressed: notificationsEnabled ? _selectTime : null,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Días para recibir alertas', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 8,
                    children: List.generate(7, (i) {
                      const dayNames = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
                      return FilterChip(
                        label: Text(
                          dayNames[i],
                          style: TextStyle(
                            color: daysOfWeek[i] ? Colors.white : null,
                          ),
                        ),
                        selected: daysOfWeek[i],
                        selectedColor: Theme.of(context).colorScheme.primary,
                        checkmarkColor: Colors.white,
                        onSelected: (_) => _toggleDay(i),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: notificationsEnabled ? showTestNotification : null,
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('Previsualizar notificación'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            elevation: 0,
            child: Row(
              children: [
                ColorPicker(
                  wheelDiameter: 150,
                  color: themeColor,
                  onColorChanged: _saveColor,
                  enableShadesSelection: false,
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.wheel: true,
                    ColorPickerType.primary: false,
                    ColorPickerType.accent: false,
                  },
                  borderRadius: 8,
                ),
                Column(
                  children: [
                    Text('Color de la App', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryFixed)),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _resetColor,
                      child: const Text('Restablecer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'mamicheck_channel',
      'Mamicheck Notificaciones',
      channelDescription: 'Notificaciones de ejemplo',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, 'Mamicheck', '¡No te olvides de tu Medición de Hoy! La clave esta en la constancia', notificationDetails,
    );
  }
}