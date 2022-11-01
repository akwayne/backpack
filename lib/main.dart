import 'package:flutter/material.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'user/viewmodel/student_provider.dart';
import 'utilities/utilities.dart';

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
    // Initialize gorouter
    late final router = AppRouter().router;

    // Find out who is logged in
    ref.read(studentProvider.notifier).getUser();

    return MaterialApp.router(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,

      debugShowCheckedModeBanner: false,

      // Setup Go Router
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
