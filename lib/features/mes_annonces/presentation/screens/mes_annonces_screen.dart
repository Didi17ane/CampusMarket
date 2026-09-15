import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/mes_annonces_provider.dart';
import '../widgets/annonce_card.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/custom_header.dart';
import 'modifier_annonce_screen.dart';

class MesAnnoncesScreen extends ConsumerWidget {
  const MesAnnoncesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final annoncesAsync = ref.watch(mesAnnoncesProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomHeader(
        // Le nombre d'annonces reste toujours visible, sur 2 lignes.
        title: annoncesAsync.when(
          data: (annonces) =>
              'Mes annonces\n${annonces.length} annonce${annonces.length > 1 ? 's' : ''} publiée${annonces.length > 1 ? 's' : ''}',
          loading: () => 'Mes annonces',
          error: (_, __) => 'Mes annonces',
        ),
        showLogo: true,
        centerTitle: false,
        leftWidget: const SizedBox.shrink(),
        leadingWidth: 0,
        toolbarHeight: 64,
        rightAction: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: annoncesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
        data: (annonces) {
          if (annonces.isEmpty) {
            return const Center(child: Text('Aucune annonce publiée pour le moment.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: annonces.length,
            itemBuilder: (context, index) {
              final annonce = annonces[index];
              return AnnonceCard(
                annonce: annonce,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModifierAnnonceScreen(annonce: annonce),
                    ),
                  );
                },
                onDelete: () => _confirmerSuppression(context, ref, annonce.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B00),
        onPressed: () => context.push('/publier'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmerSuppression(BuildContext context, WidgetRef ref, String articleId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette annonce ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(mesAnnoncesRepositoryProvider).deleteAnnonce(articleId);
              Navigator.pop(ctx);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}