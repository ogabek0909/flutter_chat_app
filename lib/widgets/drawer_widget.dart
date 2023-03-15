import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.star,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text("Log out"),
            onTap: () {
              FirebaseAuth.instance.signOut().then((_) {
                context.go('/authScreen');
              });
            },
          )
        ],
      ),
    );
  }
}
