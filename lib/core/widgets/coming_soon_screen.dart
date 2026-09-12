import 'package:flutter/material.dart';
import 'app_drawer.dart';

/// Écran temporaire pour une destination pas encore implémentée par son
/// responsable. À remplacer dans main_shell.dart dès que l'écran réel
/// existe — une seule ligne à changer.
class ComingSoonScreen extends StatelessWidget {
  final String titre;
  const ComingSoonScreen({super.key, required this.titre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(titre),
      ),
      body: const Center(child: Text('Bientôt disponible')),
    );
  }
}