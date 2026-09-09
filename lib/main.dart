import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'core/providers/auth_providers.dart';
import 'features/auth/presentation/screens/profil_screen.dart';

// ⚠️ ID UTILISATEUR DE TEST — uniquement pour visualiser Profil avant que
// T-01 (Auth) soit terminé. À retirer dès que la vraie connexion existe.
const String kTestUserId = 'test-user-001';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      overrides: [
        currentUserIdProvider.overrideWithValue(kTestUserId),
      ],
      child: const CampusMarketApp(),
    ),
  );
}

class CampusMarketApp extends StatelessWidget {
  const CampusMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          primary: const Color(0xFFFF6B00),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const ProfilScreen(),
    );
  }
}