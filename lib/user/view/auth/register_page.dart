import 'package:backpack/user/view/auth/auth_text_field.dart';
import 'package:backpack/user/view/auth/login_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodel/student_provider.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    final txtEmail = TextEditingController();
    final txtPassword = TextEditingController();

    return Scaffold(
      body: LoginBackground(
        child: Column(
          children: [
            const SizedBox(height: 300),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                'Create an Account',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            AuthTextField(controller: txtEmail, hintText: 'Email'),
            AuthTextField(controller: txtPassword, hintText: 'Password'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: txtEmail.text,
                        password: txtPassword.text,
                      );
                      await ref.read(studentProvider.notifier).createUser();
                      await ref.read(studentProvider.notifier).getUser();
                      if (!mounted) return;
                      context.goNamed('setup');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('Create Account'),
                ),
              ),
            ),
            Row(
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => context.goNamed('login'),
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
