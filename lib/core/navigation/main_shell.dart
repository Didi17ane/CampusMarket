import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../../features/auth/presentation/screens/profil_screen.dart';
import '../../features/mes_annonces/presentation/screens/mes_annonces_screen.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const screens = [MesAnnoncesScreen(), ProfilScreen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(currentTabIndexProvider);

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: const Color(0xFFFF6B00),
        onTap: (i) => ref.read(currentTabIndexProvider.notifier).state = i,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Annonces'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}