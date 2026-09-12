import 'package:flutter/material.dart';
import 'app_drawer.dart';

/// Écran temporaire pour une route pas encore implémentée par son
/// responsable. À remplacer dans app_router.dart dès que l'écran réel
/// existe — évite un écran blanc ou un crash en attendant.
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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icon/icon.png', width: 24, height: 24),
            const SizedBox(width: 8),
            Text(titre),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: const Center(child: Text('Bientôt disponible')),
    );
  }
}