import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mes_annonces_provider.dart';
import '../../../annonces/data/models/articles_models.dart';

class ModifierAnnonceScreen extends ConsumerStatefulWidget {
  final ArticlesModels annonce;
  const ModifierAnnonceScreen({super.key, required this.annonce});

  @override
  ConsumerState<ModifierAnnonceScreen> createState() => _ModifierAnnonceScreenState();
}

class _ModifierAnnonceScreenState extends ConsumerState<ModifierAnnonceScreen> {
  late final TextEditingController _titreCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _prixCtrl;
  late String _statut;
  bool _enregistrement = false;

  @override
  void initState() {
    super.initState();
    _titreCtrl = TextEditingController(text: widget.annonce.nameArticle);
    _descriptionCtrl = TextEditingController(text: widget.annonce.description);
    _prixCtrl = TextEditingController(text: widget.annonce.prix.toString());
    _statut = widget.annonce.statut;
  }

  @override
  void dispose() {
    _titreCtrl.dispose();
    _descriptionCtrl.dispose();
    _prixCtrl.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    setState(() => _enregistrement = true);
    final annonceMiseAJour = ArticlesModels(
      id: widget.annonce.id,
      photo: widget.annonce.photo, // photo inchangée ici
      nameArticle: _titreCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      prix: int.tryParse(_prixCtrl.text.trim()) ?? widget.annonce.prix,
      vendeurId: widget.annonce.vendeurId,
      categorieId: widget.annonce.categorieId, // catégorie inchangée ici
      statut: _statut,
    );
    await ref.read(mesAnnoncesRepositoryProvider).updateAnnonce(annonceMiseAJour);
    if (mounted) {
      setState(() => _enregistrement = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Annonce mise à jour')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Modifier l\'annonce'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.annonce.photo.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(widget.annonce.photo, height: 140, fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _titreCtrl,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _prixCtrl,
              decoration: const InputDecoration(labelText: 'Prix (FCFA)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _statut,
              decoration: const InputDecoration(labelText: 'Statut'),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'vendue', child: Text('Vendue')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _statut = value);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _enregistrement ? null : _enregistrer,
              child: _enregistrement
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Enregistrer', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}