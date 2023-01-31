import 'package:backpack/features/auth/auth.dart';
import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:backpack/constants/constants.dart';
import 'package:backpack/firebase/firebase.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: googleClientId),
  ]);

  runApp(
    // Setup Riverpod
    const ProviderScope(child: BackpackApp()),
  );
}

class BackpackApp extends ConsumerWidget {
  const BackpackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find out who is logged in
    ref.read(userProvider.notifier).getUser();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
