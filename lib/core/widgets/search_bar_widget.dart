import 'package:flutter/material.dart';

/// Barre de recherche blanche, posée sur le fond gris, sous le header noir.
/// Désactivée tant que T-10 (Maniga) n'est pas terminée.
class SearchBarWidget extends StatelessWidget {
  final bool enabled;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({
    super.key,
    this.enabled = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: enabled
                      ? 'Rechercher un article...'
                      : 'Rechercher un article...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}