import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/account_type_provider.dart';

class AccountTypeToggle extends ConsumerWidget {
  const AccountTypeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccount = ref.watch(accountTypeProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return ToggleButtons(
          selectedBorderColor: Theme.of(context).colorScheme.primary,
          fillColor: Theme.of(context).colorScheme.primary,
          selectedColor: Theme.of(context).colorScheme.onPrimary,
          color: Theme.of(context).colorScheme.primary,
          constraints: BoxConstraints(
            minHeight: 50,
            minWidth: (constraints.minWidth / 2) - 3,
          ),
          isSelected: selectedAccount,
          onPressed: (index) {
            (index == 0)
                ? ref.read(accountTypeProvider.notifier).selectStudent()
                : ref.read(accountTypeProvider.notifier).selectTeacher();
          },
          children: const [
            Text('Student'),
            Text('Teacher'),
          ],
        );
      }),
    );
  }
}
