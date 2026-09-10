import 'package:flutter/material.dart';

void main() {
  runApp(const CampusMarketApp());
}

class CampusMarketApp extends StatelessWidget {
  const CampusMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusMarket',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('CampusMarket 🚀')),
      ),
    );
  }
}