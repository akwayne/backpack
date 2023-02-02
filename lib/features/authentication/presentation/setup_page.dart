import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/account_type_provider.dart';
import 'account_toggle.dart';
import 'auth_text_field.dart';
import 'login_background.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  SetupPageState createState() => SetupPageState();
}

class SetupPageState extends ConsumerState<SetupPage> {
  final _setupKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  final _txtDisplayName = TextEditingController();
  final _txtSchool = TextEditingController();

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    bool isTeacher = ref.watch(accountTypeProvider)[1];

    return Scaffold(
      body: LoginBackground(
        child: Form(
          key: _setupKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Finish creating your account',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              AuthTextField(
                controller: _txtDisplayName,
                hintText: 'Name',
              ),
              AuthTextField(
                controller: _txtSchool,
                hintText: 'School',
              ),
              const AccountTypeToggle(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Confirm that all fields were filled out
                      if (_setupKey.currentState!.validate()) {
                        await ref
                            .read(authStateProvider.notifier)
                            .createUserDetail(
                              isTeacher: isTeacher,
                              displayName: _txtDisplayName.text,
                              school: _txtSchool.text,
                            );

                        // Continue to Home
                        if (!mounted) return;
                        AppRouter.goHome(context);
                      }
                    },
                    child: const Text('Finish'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
