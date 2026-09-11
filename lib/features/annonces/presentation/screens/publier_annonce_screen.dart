import 'dart:io';
import 'package:campusmarket/core/constants/theme_contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

import '../../presentation/providers/published_provider.dart';

class PublierAnnonceScreen extends ConsumerStatefulWidget {
  const PublierAnnonceScreen({super.key});

  @override
  ConsumerState<PublierAnnonceScreen> createState() =>
      _PublierAnnonceScreenState();
}

class _PublierAnnonceScreenState extends ConsumerState<PublierAnnonceScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer les saisies textuelles
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();
  final _nouvelleCategorieController = TextEditingController();

  String? _categorieSelectionnee;
  File? _imageSelectionnee;
  final ImagePicker _picker = ImagePicker();

  bool _isNouvelleCategorie =
      false; // permettre de saisir une nouvelle categorie

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    _nouvelleCategorieController.dispose();
    super.dispose();
  }

  // Fonction pour ouvrir la boîte de dialogue de sélection d'image (Caméra ou Galerie)
  Future<void> _choisirImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_camera,
                color: AppColors.orangePrincipal,
              ),
              title: const Text('Prendre une photo'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? photo = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null)
                  setState(() => _imageSelectionnee = File(photo.path));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.orangePrincipal,
              ),
              title: const Text('Choisir dans la galerie'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null)
                  setState(() => _imageSelectionnee = File(image.path));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _soumettreAnnonce() {
    if (_formKey.currentState!.validate()) {
      String? categorieFinale;

      if (_isNouvelleCategorie) {
        categorieFinale = _nouvelleCategorieController.text.trim();
      } else {
        categorieFinale = _categorieSelectionnee;
      }
      if (categorieFinale == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner ou saisir une catégorie'),
          ),
        );
        return;
      }

      final prix = int.tryParse(_prixController.text) ?? 0;

      // Appel de  provider Riverpod pour envoyer les données à Firestore
      ref
          .read(publishProvider.notifier)
          .publierAnnonce(
            name: _titreController.text.trim(),
            description: _descriptionController.text.trim(),
            prix: prix,
            categorieSaisie: categorieFinale!,
            imageFile: _imageSelectionnee,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écoute de l'état de chargement ou d'erreur depuis le provider Riverpod
    ref.listen<PublishState>(publishProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Annonce publiée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        // Réinitialiser les champs après un succès
        _titreController.clear();
        _descriptionController.clear();
        _prixController.clear();
        setState(() {
          _imageSelectionnee = null;
          _categorieSelectionnee = null;
        });
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final publishState = ref. watch(publishProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blanc),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            // Symbole de l'étudiant de la maquette représenté temporairement par une icône
            const Icon(
              Icons.directions_run,
              color: AppColors.orangePrincipal,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Publier une annonce',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Zone de sélection photo (Reproduction fidèle de la maquette)
              GestureDetector(
                onTap: _choisirImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.blanc,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grisClair),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _imageSelectionnee != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _imageSelectionnee!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: AppColors.grisTexte,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Prendre une photo / Choisir dans la galerie',
                              style: TextStyle(
                                color: AppColors.grisTexte,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Champ : Titre de l'annonce
              CustomTextField(
                label: "Titre de l'annonce",
                hintText: 'Ex : Manuel d\'algorithmique S3',
                controller: _titreController,
                validator: (val) => val == null || val.isEmpty
                    ? 'Ce champ est obligatoire'
                    : null,
              ),

              //Champ : Description
              CustomTextField(
                label: 'Description',
                hintText: 'Décris l\'état, les détails utiles...',
                controller: _descriptionController,
                maxLines: 4,
                validator: (val) => val == null || val.isEmpty
                    ? 'Ce champ est obligatoire'
                    : null,
              ),

              // Champ : Prix (FCFA)
              CustomTextField(
                label: 'Prix (FCFA)',
                hintText: 'Ex : 5000',
                controller: _prixController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Ce champ est obligatoire';
                  if (int.tryParse(val) == null)
                    return 'Veuillez entrer un montant valide';
                  return null;
                },
              ),

              // Menu Déroulant : Catégorie
              const Text(
                'Catégorie',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: AppColors.noir,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              ref
                  .watch(categoriesStreamProvider)
                  .when(
                    data: (listeCategories) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _isNouvelleCategorie
                                ? 'autre_option'
                                : _categorieSelectionnee,
                            hint: const Text(
                              'Sélectionner une catégorie',
                              style: TextStyle(
                                color: AppColors.grisTexte,
                                fontSize: 14,
                              ),
                            ),
                            decoration: InputDecoration(
                              fillColor: AppColors.blanc,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.grisClair,
                                ),
                              ),
                            ),
                            items: [
                              // On affiche d'abord les catégories venues de Firestore
                              ...listeCategories.map((cat) {
                                return DropdownMenuItem<String>(
                                  value: cat['nom'],
                                  child: Text(
                                    cat['nom']!,
                                    style: const TextStyle(
                                      color: AppColors.noir,
                                    ),
                                  ),
                                );
                              }),
                              // On ajoute l'option magique tout en bas de la liste
                              const DropdownMenuItem<String>(
                                value: 'autre_option',
                                child: Text(
                                  '➕ Autre (Créer une catégorie...)',
                                  style: TextStyle(
                                    color: AppColors.orangePrincipal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value == 'autre_option') {
                                  _isNouvelleCategorie = true;
                                  _categorieSelectionnee = null;
                                } else {
                                  _isNouvelleCategorie = false;
                                  _categorieSelectionnee = value;
                                }
                              });
                            },
                          ),

                          // Si l'utilisateur a choisi "Autre", on fait apparaître le champ de saisie avec animation
                          if (_isNouvelleCategorie) ...[
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: "Nom de la nouvelle catégorie",
                              hintText:
                                  "Ex: Électroménager, Outils, Jeux vidéo...",
                              controller: _nouvelleCategorieController,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Veuillez saisir le nom de la catégorie'
                                  : null,
                            ),
                          ],
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orangePrincipal,
                      ),
                    ),
                    error: (err, stack) =>
                        Text('Erreur de chargement des catégories : $err'),
                  ),

              const SizedBox(height: 32),

              // Bouton Principal de Publication
              CustomButton(
                text: "Publier l'annonce",
                isLoading: publishState.isLoading,
                onPressed: _soumettreAnnonce,
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  '* Tous les champs sont obligatoires',
                  style: TextStyle(
                    color: AppColors.grisTexte,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
