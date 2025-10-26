import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              '¿Qué es Mamicheck?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Mamicheck es una aplicación diseñada para apoyar a gestantes y sus acompañantes en el monitoreo de su salud durante el embarazo. Puedes registrar tus signos vitales, ver tu progreso y recibir alertas personalizadas.',
              style: textStyle,
            ),
            const SizedBox(height: 16),

            Text(
              'Registro de mediciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Desde la pantalla principal puedes registrar tu presión arterial, frecuencia cardíaca, temperatura, glucosa y más. Estos datos se analizan automáticamente para detectar niveles de riesgo.',
              style: textStyle,
            ),
            const SizedBox(height: 16),

            Text(
              'Riesgo y alertas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Cada medición puede generar un nivel de riesgo (bajo, medio o alto) según tus resultados. Si se detectan riesgos altos frecuentes, recibirás una alerta para que tomes acción o contactes a un profesional.',
              style: textStyle,
            ),
            const SizedBox(height: 16),

            Text(
              'Notificaciones personalizadas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Puedes activar notificaciones diarias en el horario que prefieras y elegir los días de la semana en los que deseas recibir recordatorios. Esto te ayuda a mantener una rutina constante de monitoreo.',
              style: textStyle,
            ),
            const SizedBox(height: 16),

            Text(
              'Colores personalizados',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Si lo deseas, puedes cambiar el color principal de la app desde la pantalla de configuración para adaptarlo a tu preferencia. El color se guardará y se aplicará al reiniciar la app.',
              style: textStyle,
            ),
            const SizedBox(height: 16),

            Text(
              '¿Quién puede usar la app?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'La app puede ser usada tanto por personas gestantes como por sus acompañantes, como parejas, familiares o personal médico. Los roles se asignan al crear o seguir un embarazo.',
              style: textStyle,
            ),
            const SizedBox(height: 16),

            Text(
              'Soporte',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Si tienes dudas o problemas con la app, por favor contacta al equipo de soporte cuando esté disponible.',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
