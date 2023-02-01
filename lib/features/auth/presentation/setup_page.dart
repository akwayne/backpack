import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/components.dart';
import '../application/auth_provider.dart';
import '../domain/user_data.dart';
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

  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtSchool = TextEditingController();

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    // User info to display
    final user = ref.watch(authProvider) ?? UserData.empty();

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
                controller: txtFirstName,
                hintText: 'First Name',
              ),
              AuthTextField(
                controller: txtLastName,
                hintText: 'Last Name',
              ),
              AuthTextField(
                controller: txtSchool,
                hintText: 'School',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Confirm that all fields were filled out
                      if (_setupKey.currentState!.validate()) {
                        // Update fields in user object
                        user.firstName = txtFirstName.text;
                        user.lastName = txtLastName.text;
                        user.school = txtSchool.text;

                        // Update in provider and firebase
                        await ref.read(authProvider.notifier).updateUser(user);

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
