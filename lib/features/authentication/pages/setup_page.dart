import 'package:backpack/components/components.dart';
import 'package:backpack/routing/routing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/account_toggle.dart';
import '../components/background.dart';
import '../viewmodel/account_type_provider.dart';
import '../viewmodel/auth_provider.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  SetupPageState createState() => SetupPageState();
}

class SetupPageState extends ConsumerState<SetupPage> {
  @override
  void initState() {
    super.initState();
  }

  final _txtDisplayName = TextEditingController();
  final _txtSchool = TextEditingController();

  @override
  void dispose() {
    _txtDisplayName.dispose();
    _txtSchool.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    bool isTeacher = ref.watch(accountTypeProvider)[1];

    return Scaffold(
      body: SchoolSuppliesBackground(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Finish creating your account',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            CustomTextField(
              controller: _txtDisplayName,
              label: 'Name',
            ),
            CustomTextField(
              controller: _txtSchool,
              label: 'School',
            ),
            const AccountTypeToggle(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).createUserDetail(
                          isTeacher: isTeacher,
                          displayName: _txtDisplayName.text,
                          school: _txtSchool.text,
                        );

                    if (!mounted) return;
                    AppRouter.goHome(context);
                  },
                  child: const Text('Finish'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
