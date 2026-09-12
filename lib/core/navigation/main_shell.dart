import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/navigation_provider.dart';
import '../widgets/coming_soon_screen.dart';
import '../../features/auth/presentation/screens/profil_screen.dart';
import '../../features/mes_annonces/presentation/screens/mes_annonces_screen.dart';

/// Bottom nav principale de l'app, conforme à la maquette (5 icônes) :
/// Catalogue, Rechercher, Publier, Mes annonces, Profil.
///
/// IMPORTANT : "Publier" (au milieu) n'est PAS un onglet persistant comme
/// les 4 autres — c'est un raccourci qui ouvre PublierAnnonceScreen
/// par-dessus (context.push), exactement comme le bouton "+" de Mes
/// annonces ou le tile du drawer. Pourquoi : cet écran a sa propre flèche
/// retour (Navigator.pop), qui plante si l'écran n'a pas été "poussé"
/// (ce qui arrive si on en fait un onglet classique avec juste un
/// changement d'index — rien à dépiler, go_router crashe).
///
/// Catalogue et Rechercher sont en "Bientôt disponible" tant que Baba (T-02)
/// et Maniga (T-10) n'ont pas livré leurs écrans — remplacer ComingSoonScreen
/// par le vrai écran dès qu'il existe, une seule ligne à changer ici.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  // 4 vrais onglets seulement (Publier est géré à part, voir onTap).
  static const screens = [
    ComingSoonScreen(titre: 'Catalogue'),
    ComingSoonScreen(titre: 'Rechercher'),
    MesAnnoncesScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realIndex = ref.watch(currentTabIndexProvider); // 0..3

    // La bottom bar affiche 5 icônes, mais "Publier" (position 2) ne
    // correspond à aucun onglet réel : on décale l'affichage pour que les
    // 4 vrais onglets s'allument correctement au bon endroit visuel.
    final visualIndex = realIndex < 2 ? realIndex : realIndex + 1;

    return Scaffold(
      body: screens[realIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: visualIndex,
        selectedItemColor: const Color(0xFFFF6B00),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (tapped) {
          if (tapped == 2) {
            // Publier : toujours un vrai push, jamais un changement d'onglet.
            context.push('/publier');
            return;
          }
          final newRealIndex = tapped < 2 ? tapped : tapped - 1;
          ref.read(currentTabIndexProvider.notifier).state = newRealIndex;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Catalogue'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, color: Color(0xFFFF6B00)), label: 'Publier'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Annonces'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}