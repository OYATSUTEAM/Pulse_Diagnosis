import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulse_diagnosis/Pages/Auth/Login_Page.dart';
import 'package:pulse_diagnosis/Pages/NavigationPage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Navigationpage(selectedIndex: 0,);
        } else {
          return Login_Page();
        }
      },
    );
  }
}
