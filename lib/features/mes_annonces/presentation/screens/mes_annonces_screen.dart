import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mes_annonces_provider.dart';
import '../widgets/annonce_card.dart';

class MesAnnoncesScreen extends ConsumerWidget {
  const MesAnnoncesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final annoncesAsync = ref.watch(mesAnnoncesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: annoncesAsync.when(
          data: (annonces) => Text(
            'Mes annonces\n${annonces.length} annonce${annonces.length > 1 ? 's' : ''} publiée${annonces.length > 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 16),
          ),
          loading: () => const Text('Mes annonces'),
          error: (_, __) => const Text('Mes annonces'),
        ),
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
                  // TODO: naviguer vers l'écran d'édition (réutilise le formulaire T-07 de Maniga)
                },
                onDelete: () => _confirmerSuppression(context, ref, annonce.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B00),
        onPressed: () {
          // TODO: naviguer vers l'écran de publication (T-07)
        },
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
