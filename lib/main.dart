import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/annonces/presentation/screens/catalogue_screen.dart';
import 'seed_data.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await seedArticles();
  runApp(const CampusMarketApp());
}

class CampusMarketApp extends StatelessWidget {
  const CampusMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusMarket',
      debugShowCheckedModeBanner: false,
      // home: const Scaffold(
      //   body: Center(child: Text('CampusMarket 🚀')),
      // ),
      home: const CatalogueScreen(),
    );
  }
}


