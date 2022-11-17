import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/utilities.dart';
import '../../viewmodel/user_provider.dart';
import 'auth_text_field.dart';
import 'login_background.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends ConsumerState<RegisterPage> {
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
    DeviceType deviceType = getDeviceType(MediaQuery.of(context));
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: LoginBackground(
        child: ListView(
          children: [
            // no empty space on mobile in landscape mode
            if (!(deviceType == DeviceType.mobile &&
                orientation == Orientation.landscape))
              Column(
                children: [
                  SizedBox(
                    height: getDeviceType(MediaQuery.of(context)) ==
                            DeviceType.mobile
                        ? 250
                        : 300,
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                'Create an Account',
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
            // AuthTextField(controller: txtPassword, label: 'Confirm Password'),
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
                      await ref.read(userProvider.notifier).createUser();
                      await ref.read(userProvider.notifier).getUser();
                      if (!mounted) return;
                      context.goNamed('setup');
                    } on FirebaseAuthException catch (e) {
                      // Clear previous error messages
                      setState(() {
                        emailError = null;
                        passwordError = null;
                      });

                      switch (e.code) {
                        case 'email-already-in-use':
                          setState(
                              () => emailError = 'Email is already in use');
                          break;
                        case 'invalid-email':
                          setState(
                              () => emailError = 'Please enter a valid email');
                          break;
                        case 'weak-password':
                          setState(() => passwordError =
                              'Password must be at least 6 characters');
                          break;
                        default:
                          setState(() {
                            emailError = 'Error';
                            passwordError = 'Error';
                          });
                      }
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
                  onPressed: () => context.pop(),
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
