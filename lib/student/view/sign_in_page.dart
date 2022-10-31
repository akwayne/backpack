import 'package:backpack/student/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SigninPage extends ConsumerWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    return Scaffold(
      body: SignInScreen(
        headerBuilder: (context, constraints, shrinkOffset) {
          return Image.asset('assets/backpack.png');
        },
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) async {
            await ref.read(studentProvider.notifier).getUser();
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/');
          }),
        ],
      ),
    );
  }
}
