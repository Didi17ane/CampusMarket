import 'package:campusmarket/features/auth/presentation/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './core/constants/theme_contants.dart';
import 'firebase_options.dart';
import './routes/routes.dart';
import './features/auth/presentation/screens/user_picture.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CampusMarketApp()));
}

class CampusMarketApp extends StatefulWidget {
  const CampusMarketApp({super.key});

  @override
  State<CampusMarketApp> createState() => _CampusMarketAppState();
}

class _CampusMarketAppState extends State<CampusMarketApp> {
  static const Duration _splashDuration = Duration(seconds: 5);

  late final Future<void> _initialization;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initialization = Future.wait<dynamic>([
      _initializeFirebase(),
      dotenv.load(fileName: ".env"),
    ]).then((_) {});
    _initializeAndShowApplication();
  }

  Future<void> _initializeFirebase() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  Future<void> _initializeAndShowApplication() async {
    await Future.wait<dynamic>([
      _initialization,
      Future.delayed(_splashDuration),
    ]);

    if (!mounted) return;
    setState(() => _isReady = true);
  }

  @override
  Widget build(BuildContext context) {
    return _isReady
        ? const CampusMarketRouter()
        : const Directionality(
            textDirection: TextDirection.ltr,
            child: SplashScreen(),
          );
  }
}

class CampusMarketRouter extends ConsumerWidget {
  const CampusMarketRouter({super.key});

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

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/CampusMarket_logo_icone.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}