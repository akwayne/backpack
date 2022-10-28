import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(
        headerBuilder: (context, constraints, shrinkOffset) {
          return Image.asset('assets/backpack.png');
        },
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            Navigator.pushReplacementNamed(context, '/');
          })
        ],
      ),
    );
  }
}
