import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:backpack/routing/routing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/error_provider.dart';
import '../application/auth_state_provider.dart';
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

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    DeviceType deviceType = getDeviceType(MediaQuery.of(context));
    Orientation orientation = MediaQuery.of(context).orientation;

    String? emailError = ref.watch(errorProvider).emailError;
    String? passwordError = ref.watch(errorProvider).passwordError;

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
                    await ref.read(authStateProvider.notifier).createUser(
                          email: txtEmail.text,
                          password: txtPassword.text,
                        );
                    if (ref.read(authStateProvider) is AuthInProgress)
                      AppRouter.goSetup(context);
                  },
                  child: const Text('Create Account'),
                ),
              ),
            ),
            Row(
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => AppRouter.goLogin(context),
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
