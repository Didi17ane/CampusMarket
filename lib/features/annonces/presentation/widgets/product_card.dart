import 'package:flutter/material.dart';
import '../../../auth/data/models/articles_models.dart';

class ProductCard extends StatelessWidget {
  final ArticlesModels produit;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.produit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 1.4,
                child: produit.photo.isNotEmpty
                    ? Image.network(
                        produit.photo,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: Text('Chargement...', style: TextStyle(fontSize: 10)),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // on affiche l'erreur réelle pour comprendre le problème
                          debugPrint('❌ Erreur image : $error');
                          return Container(
                            color: const Color(0xFFF0F0F2),
                            padding: const EdgeInsets.all(4),
                            child: const Text(
                              'Erreur photo',
                              style: TextStyle(fontSize: 9, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: const Color(0xFFF0F0F2),
                        child: const Text('photo vide', style: TextStyle(fontSize: 10)),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produit.nameArticle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${produit.prix} FCFA',
                    style: const TextStyle(
                      color: Color(0xFFFF6600), // notre orange pur
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}