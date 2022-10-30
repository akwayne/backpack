import 'package:backpack/student/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SignInScreen(
        headerBuilder: (context, constraints, shrinkOffset) {
          return Image.asset('assets/backpack.png');
        },
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) async {
            ref.read(studentProvider.notifier).getUser();
            Navigator.pushReplacementNamed(context, '/');
          })
        ],
      ),
    );
  }
}
