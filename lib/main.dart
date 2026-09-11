import 'package:flutter/material.dart';
import './routes/routes.dart';

void main() {
  runApp(const CampusMarketApp());
}

class CampusMarketApp extends StatelessWidget {
  const CampusMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
