import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'core/providers/auth_providers.dart';
import 'core/providers/navigation_provider.dart';
import 'features/auth/presentation/screens/profil_screen.dart';
import 'features/mes_annonces/presentation/screens/mes_annonces_screen.dart';

// ⚠️ ID UTILISATEUR DE TEST — uniquement pour visualiser Profil/Mes annonces
// avant que T-01 (Auth) soit terminé. À retirer dès que la vraie connexion
// existe : il suffira de supprimer ce override.
const String kTestUserId = 'vendeur_etudiant_id_999';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

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
        // Typographie : titres en Inter Bold, texte courant en Inter Regular.
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
          headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.bold),
          headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.inter(fontWeight: FontWeight.bold),
          titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      home: const _TestNav(),
    );
  }
}

/// Navigation temporaire, juste pour tester Profil et Mes annonces.
/// À remplacer par la vraie bottom nav (module Architecture & intégration).
/// L'onglet actif vient de [currentTabIndexProvider], partagé avec Profil
/// et le Drawer, pour que "Mes annonces" / "Mon profil" changent d'onglet
/// au lieu d'empiler un nouvel écran par-dessus.
class _TestNav extends ConsumerWidget {
  const _TestNav();

  static const screens = [MesAnnoncesScreen(), ProfilScreen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(currentTabIndexProvider);

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: const Color(0xFFFF6B00),
        onTap: (i) => ref.read(currentTabIndexProvider.notifier).state = i,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Annonces'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}