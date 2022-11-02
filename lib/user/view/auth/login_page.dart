import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodel/student_provider.dart';
import 'auth_text_field.dart';
import 'login_background.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();

  String? emailError;
  String? passwordError;

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                'Login to Backpack',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            AuthTextField(
              controller: txtEmail,
              hintText: 'Email',
              errorText: emailError,
            ),
            AuthTextField(
              controller: txtPassword,
              hintText: 'Password',
              errorText: passwordError,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
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
                      // Clear previous error messages
                      setState(() {
                        emailError = null;
                        passwordError = null;
                      });

                      switch (e.code) {
                        case 'user-not-found':
                        case 'invalid-email':
                          setState(() =>
                              emailError = 'No user found for that email.');
                          break;
                        case 'wrong-password':
                          setState(() => passwordError = 'Incorrect password');
                          break;
                        default:
                          setState(() {
                            emailError = 'Error';
                            passwordError = 'Error';
                          });
                      }
                    }
                  },
                  child: const Text('Log In'),
                ),
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
