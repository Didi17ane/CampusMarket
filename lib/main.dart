import 'package:flutter/material.dart';
import './features/auth/presentation/screens/signin.dart';

void main() {
  runApp(const SignIn());
}

class CampusMarketApp extends StatelessWidget {
  const CampusMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusMarket',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: Center(child: Text('CampusMarket 🚀'))),
    );
  }
}
