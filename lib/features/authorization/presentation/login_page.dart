import 'package:backpack/features/authorization/authorization.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:backpack/routing/routing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/error_provider.dart';
import 'auth_text_field.dart';
import 'login_background.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends ConsumerState<LogInPage> {
  @override
  void initState() {
    super.initState();
  }

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = getDeviceType(MediaQuery.of(context));
    Orientation orientation = MediaQuery.of(context).orientation;

    String? emailError = ref.watch(errorProvider).emailError;
    String? passwordError = ref.watch(errorProvider).passwordError;

    return Scaffold(
      body: LoginBackground(
        child: ListView(
          children: [
            // do not show image on mobile in landscape mode
            if (!(deviceType == DeviceType.mobile &&
                orientation == Orientation.landscape))
              Column(
                children: [
                  SizedBox(
                    height: deviceType == DeviceType.mobile ? 250 : 300,
                    child: Image.asset(
                      // Designed by stockgiu / Freepik
                      'assets/backpack.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

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
                    await ref.read(authStateProvider.notifier).signIn(
                          email: txtEmail.text,
                          password: txtPassword.text,
                        );
                    if (ref.read(authStateProvider) is AuthSignedIn)
                      AppRouter.goHome(context);
                  },
                  child: const Text('Log In'),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(errorProvider.notifier).clearErrors();
                AppRouter.goRegister(context);
              },
              child: const Text('Or create a new account'),
            ),
          ],
        ),
      ),
    );
  }
}
