import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/navigation_provider.dart';
import '../../features/auth/presentation/providers/route_auth_provider.dart';
import '../../features/auth/presentation/screens/profil_screen.dart';
import '../../features/mes_annonces/presentation/screens/mes_annonces_screen.dart';
import '../../features/annonces/presentation/screens/catalogue_screen.dart';

/// Bottom nav principale : Catalogue (public), Publier, Mes annonces,
/// Profil (ces 3 derniers réservés aux utilisateurs connectés).
///
/// "Mes annonces" et "Profil" restent affichés à l'intérieur de ce shell
/// sans changer d'URL, donc pas couverts par le redirect de routes.dart —
/// on vérifie l'état de connexion nous-mêmes avant de switcher dessus.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const screens = [
    CatalogueScreen(),
    MesAnnoncesScreen(),
    ProfilScreen(),
  ];

  static bool _estPrive(int realIndex) => realIndex == 1 || realIndex == 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realIndex = ref.watch(currentTabIndexProvider); // 0..2
    final visualIndex = realIndex < 1 ? realIndex : realIndex + 1;
    final authNotifier = ref.watch(routerAuthNotifierProvider);

    return Scaffold(
      body: screens[realIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: visualIndex,
        selectedItemColor: const Color(0xFFFF6B00),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (tapped) {
          if (tapped == 1) {
            context.push('/publier');
            return;
          }
          final newRealIndex = tapped < 1 ? tapped : tapped - 1;

          if (_estPrive(newRealIndex) && authNotifier.isLoading) {
            return;
          }

          if (_estPrive(newRealIndex) && !authNotifier.isConnected) {
            context.go('/login');
            return;
          }
          ref.read(currentTabIndexProvider.notifier).state = newRealIndex;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Catalogue',
          ),
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
