import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/navigation_provider.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../providers/user_provider.dart';
import 'modifier_profil_screen.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: CustomHeader(
        title: 'Mon profil',
        showLogo: true,
        centerTitle: false,
        leftWidget: const SizedBox.shrink(),
        leadingWidth: 0,
        rightAction: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Aucun utilisateur connecté.'));
          }
          final initiales = _initiales(user.name, user.lastname);

          return ListView(
            children: [
              Container(
                width: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFFF6B00),
                    child: Text(
                      initiales,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${user.name} ${user.lastname}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _ProfilTile(
                label: 'Modifier mes informations',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModifierProfilScreen(user: user),
                    ),
                  );
                },
              ),
              _ProfilTile(
                label: 'Paramètres de notification',
                onTap: () => _bientotDisponible(context),
              ),
              _ProfilTile(
                label: 'Aide & support',
                onTap: () => _bientotDisponible(context),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF6B00),
                      side: const BorderSide(color: Color(0xFFFF6B00)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      ref.read(currentTabIndexProvider.notifier).state = 0;
                      if (context.mounted) {
                        context.go('/');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vous êtes déconnecté(e)')),
                        );
                      }
                    },
                    child: const Text('Se déconnecter'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  void _bientotDisponible(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bientôt disponible')),
    );
  }

  String _initiales(String name, String lastname) {
    final a = name.isNotEmpty ? name[0] : '';
    final b = lastname.isNotEmpty ? lastname[0] : '';
    return (a + b).toUpperCase();
  }
}

class _ProfilTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ProfilTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}