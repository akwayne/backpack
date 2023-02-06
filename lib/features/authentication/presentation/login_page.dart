import 'package:backpack/components/components.dart';
import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/error_provider.dart';
import 'components/background.dart';

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

  final _txtEmail = TextEditingController();
  final _txtPassword = TextEditingController();

  @override
  void dispose() {
    _txtEmail.dispose();
    _txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = getDeviceType(MediaQuery.of(context));
    Orientation orientation = MediaQuery.of(context).orientation;

    final authState = ref.watch(authProvider);
    String? emailError = ref.watch(errorProvider).emailError;
    String? passwordError = ref.watch(errorProvider).passwordError;

    return Scaffold(
      body: SchoolSuppliesBackground(
        child: (authState is AuthInProgress)
            ? const ProgressView()
            : ListView(
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
                  CustomTextField(
                    controller: _txtEmail,
                    label: 'Email',
                    errorText: emailError,
                  ),
                  CustomTextField(
                    controller: _txtPassword,
                    label: 'Password',
                    errorText: passwordError,
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async =>
                            await ref.read(authProvider.notifier).signIn(
                                  email: _txtEmail.text,
                                  password: _txtPassword.text,
                                ),
                        child: const Text('Log In'),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(errorProvider.notifier).clearErrors();
                      context.goNamed(RouteName.register);
                    },
                    child: const Text('Or create a new account'),
                  ),
                ],
              ),
      ),
    );
  }
}
