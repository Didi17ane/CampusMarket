import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/presentation/providers/user_provider.dart';
import '../providers/navigation_provider.dart';
import 'package:campusmarket/features/annonces/presentation/screens/publier_annonce_screen.dart';
import 'package:go_router/go_router.dart';

/// Menu latéral (drawer), conforme à la maquette (page "Menu latéral").
/// Regroupe les mêmes destinations que la bottom nav + Aide & support et
/// Se déconnecter. À utiliser sur chaque écran principal via `drawer: const AppDrawer()`.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 16),
            child: Image.asset(
              'assets/logo/CampusMarket_logo_horizontal_fond_noir.png',
              height: 48,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: userAsync.when(
              data: (user) => Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFFF6B00),
                    child: Text(
                      user != null
                          ? '${user.name.isNotEmpty ? user.name[0] : ''}${user.lastname.isNotEmpty ? user.lastname[0] : ''}'
                                .toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user != null
                              ? '${user.name} ${user.lastname}'
                              : 'Non connecté',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user != null)
                          Text(
                            user.email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox(height: 44),
              error: (_, __) => const SizedBox(height: 44),
            ),
          ),
          const SizedBox(height: 8),
          _DrawerItem(
            icon: Icons.home_outlined,
            label: 'Catalogue',
            onTap: () => _bientotDisponible(context),
          ),
          _DrawerItem(
            icon: Icons.search,
            label: 'Rechercher',
            onTap: () => _bientotDisponible(context),
          ),
          _DrawerItem(
            icon: Icons.add_circle_outline,
            label: 'Publier une annonce',
            onTap: () {
              Navigator.pop(context); // ferme le drawer
              context.push('/publier');
            },
          ),
          _DrawerItem(
            icon: Icons.storefront_outlined,
            label: 'Mes annonces',
            onTap: () {
              Navigator.pop(context);
              ref.read(currentTabIndexProvider.notifier).state = 2;
            },
          ),
          _DrawerItem(
            icon: Icons.person_outline,
            label: 'Mon profil',
            onTap: () {
              Navigator.pop(context);
              ref.read(currentTabIndexProvider.notifier).state = 3;
            },
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.help_outline,
            label: 'Aide & support',
            onTap: () => _bientotDisponible(context),
          ),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Se déconnecter',
            color: Colors.red,
            onTap: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
            },
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'CampusMarket v1.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _bientotDisponible(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Bientôt disponible')));
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(label, style: TextStyle(color: color ?? Colors.black87)),
      onTap: onTap,
    );
  }
}
