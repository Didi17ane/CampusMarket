import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Onglet actif de la bottom nav (0 = Annonces, 1 = Profil pour l'instant).
/// Permet à n'importe quel écran (Profil, Drawer...) de changer d'onglet
/// sans empiler un nouvel écran par-dessus (ce qui ferait disparaître la
/// bottom nav).
final currentTabIndexProvider = StateProvider<int>((ref) => 0);
