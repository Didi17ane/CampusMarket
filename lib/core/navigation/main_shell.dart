import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../widgets/coming_soon_screen.dart';
import '../../features/auth/presentation/screens/profil_screen.dart';
import '../../features/mes_annonces/presentation/screens/mes_annonces_screen.dart';
import '../../features/annonces/presentation/screens/publier_annonce_screen.dart';

/// Bottom nav principale de l'app, conforme à la maquette (5 destinations) :
/// Catalogue, Rechercher, Publier, Mes annonces, Profil.
/// Catalogue et Rechercher sont en "Bientôt disponible" tant que les branches de Baba (T-02)
/// et Maniga (T-10) n'ont pas été mergées : remplacer ComingSoonScreen
/// par le vrai écran dès qu'il existe, une seule ligne à changer ici.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const screens = [
    ComingSoonScreen(titre: 'Catalogue'),
    ComingSoonScreen(titre: 'Rechercher'),
    PublierAnnonceScreen(),
    MesAnnoncesScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(currentTabIndexProvider);

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedItemColor: const Color(0xFFFF6B00),
        onTap: (i) => ref.read(currentTabIndexProvider.notifier).state = i,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Catalogue',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Color(0xFFFF6B00)),
            label: 'Publier',
          ),
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
