import 'package:backpack/student/view/profile_update.dart';
import 'package:flutter/material.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'home/home_nav.dart';
import 'student/view/login_page.dart';
import 'student/view/profile_page.dart';
import 'student/viewmodel/student_provider.dart';
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
    // Check for user when app starts
    ref.read(studentProvider.notifier).getUser();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
      routes: _appRoutes,
    );
  }
}

final _appRoutes = <String, WidgetBuilder>{
  '/': (context) => const HomeNavigation(),
  '/login': (context) => const LoginPage(),
  '/profile': (context) => const ProfilePage(),
  '/profileupdate': (context) => const ProfileUpdate(),
};
