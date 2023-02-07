import 'package:backpack/components/components.dart';
import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'components/background.dart';
import '../application/error_provider.dart';

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

  final _txtEmail = TextEditingController();
  final _txtPassword = TextEditingController();
  final _txtConfirmPassword = TextEditingController();

  @override
  void dispose() {
    _txtEmail.dispose();
    _txtPassword.dispose();
    _txtConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = getDeviceType(MediaQuery.of(context));
    Orientation orientation = MediaQuery.of(context).orientation;

    final authState = ref.watch(authProvider);
    String? emailError = ref.watch(errorProvider).emailError;
    String? passwordError = ref.watch(errorProvider).passwordError;
    String? confirmPasswordError =
        ref.watch(errorProvider).confirmPasswordError;

    return Scaffold(
      body: SchoolSuppliesBackground(
        child: (authState is AuthInProgress)
            ? const ProgressView()
            : ListView(
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
                  CustomTextField(
                    controller: _txtConfirmPassword,
                    label: 'Confirm Password',
                    errorText: confirmPasswordError,
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async =>
                            await ref.read(authProvider.notifier).createUser(
                                  email: _txtEmail.text,
                                  password: _txtPassword.text,
                                  confirmPassword: _txtConfirmPassword.text,
                                ),
                        child: const Text('Create Account'),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () => context.goNamed(RouteName.login),
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
