import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'core/providers/auth_providers.dart';
import 'features/auth/presentation/screens/profil_screen.dart';
import 'features/mes_annonces/presentation/screens/mes_annonces_screen.dart';

// ⚠️ ID UTILISATEUR DE TEST — uniquement pour visualiser Profil/Mes annonces
// avant que T-01 (Auth) soit terminé. À retirer dès que la vraie connexion
// existe : il suffira de supprimer ce override.
const String kTestUserId = 'test-user-001';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      overrides: [currentUserIdProvider.overrideWithValue(kTestUserId)],
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
      home: const _TestNav(),
    );
  }
}

/// Navigation temporaire, juste pour tester Profil et Mes annonces.
/// À remplacer par la vraie bottom nav (module Architecture & intégration).
class _TestNav extends StatefulWidget {
  const _TestNav();
  @override
  State<_TestNav> createState() => _TestNavState();
}

class _TestNavState extends State<_TestNav> {
  int index = 0;
  final screens = const [MesAnnoncesScreen(), ProfilScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: const Color(0xFFFF6B00),
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
