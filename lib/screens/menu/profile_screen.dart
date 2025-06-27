// import 'package:flutter/material.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userModel = context.watch<UserModel?>();
//     final messenger = ScaffoldMessenger.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('profile'),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:mamicheckapp/models/user_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        title: const Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.primaries[userModel.uid.hashCode.abs() % Colors.primaries.length].shade900,
                    child: Text(userModel.firstName[0]+userModel.lastName[0], style: TextStyle(color: Colors.primaries[userModel.uid.hashCode.abs() % Colors.primaries.length].shade100)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${userModel.firstName} ${userModel.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  Text(
                    userModel.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 72),
            _buildInfoTile(context, Icons.cake, 'Fecha de nacimiento', '${userModel.birthDate.day}/${userModel.birthDate.month}/${userModel.birthDate.year}'),
            const SizedBox(height: 12),
            _buildInfoTile(context, Icons.phone, 'Teléfono', userModel.telephoneNumber),
            const SizedBox(height: 12),
            _buildInfoTile(context, Icons.badge, 'ID de usuario', userModel.uid),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    // return ListTile(
    //   tileColor: Colors.red,
    //   contentPadding: EdgeInsets.symmetric(horizontal: 12),
    //   leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
    //   title: Text(label, style: Theme.of(context).textTheme.labelMedium),
    //   subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    // );
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label, style: Theme.of(context).textTheme.labelMedium),
        subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}