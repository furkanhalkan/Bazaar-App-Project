import 'package:flutter/material.dart';
import '../screens/profil.dart';

class ProfileWidget extends StatelessWidget {
  final List<Profile> profiles = [
    Profile('Profil 1'),
    Profile('Profil 2'),
    // Diğer profiller...
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(profiles[index].title),
        );
      },
    );
  }
}
