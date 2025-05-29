import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final avatarText = user?.displayName ?? '???';
        final baseColor = _profileColor(avatarText);

        return CircleAvatar(
          backgroundColor: baseColor.shade900,
          child: Text(
            avatarText[0]+avatarText[1],
            style: TextStyle(color: baseColor.shade100),
          ),
        );
      },
    );
  }

  MaterialColor _profileColor(String avatarText) {
    return Colors.primaries[avatarText.hashCode.abs() % Colors.primaries.length];
  }
}