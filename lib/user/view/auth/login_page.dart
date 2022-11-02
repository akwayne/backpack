import 'package:backpack/user/viewmodel/student_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_text_field.dart';
import 'login_background.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    final txtEmail = TextEditingController();
    final txtPassword = TextEditingController();

    return Scaffold(
      body: LoginBackground(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Image.asset(
                // Designed by stockgiu / Freepik
                'assets/backpack.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Login to Backpack',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: txtEmail,
              hintText: 'Email',
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: txtPassword,
              hintText: 'Password',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: txtEmail.text,
                      password: txtPassword.text,
                    );
                    await ref.read(studentProvider.notifier).getUser();
                    if (!mounted) return;
                    context.goNamed('home');
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                },
                child: const Text('Log In'),
              ),
            ),
            TextButton(
              onPressed: () => context.goNamed('register'),
              child: const Text('Or create a new account'),
            ),
          ],
        ),
      ),
    );
  }
}
