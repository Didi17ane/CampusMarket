import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './core/constants/theme_contants.dart';
import 'firebase_options.dart';
import './routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  // Plus d'utilisateur de test : l'app utilise maintenant le vrai
  // utilisateur connecté via Firebase Auth (routerProvider gère aussi
  // les redirections /login selon l'état de connexion réel).
  runApp(const ProviderScope(child: CampusMarketApp()));
}

class CampusMarketApp extends ConsumerWidget {
  const CampusMarketApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CampusMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          primary: const Color(0xFFFF6B00),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
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
          iconTheme: IconThemeData(color: AppColors.blanc),
        ),
      ),
      routerConfig: router,
    );
  }
}
