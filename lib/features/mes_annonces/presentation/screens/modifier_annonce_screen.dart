import 'dart:io';

import 'package:campusmarket/core/constants/theme_contants.dart';
import 'package:campusmarket/core/widgets/custom_button.dart';
import 'package:campusmarket/core/widgets/custom_header.dart';
import 'package:campusmarket/core/widgets/custom_input_modal.dart';
import 'package:campusmarket/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/firestore_service.dart';
import '../../../annonces/data/models/articles_models.dart';
import '../../../annonces/presentation/providers/published_provider.dart';
import '../providers/mes_annonces_provider.dart';

class ModifierAnnonceScreen extends ConsumerStatefulWidget {
  final ArticlesModels annonce;

  const ModifierAnnonceScreen({super.key, required this.annonce});

  @override
  ConsumerState<ModifierAnnonceScreen> createState() =>
      _ModifierAnnonceScreenState();
}

class _ModifierAnnonceScreenState extends ConsumerState<ModifierAnnonceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _firestoreService = FirestoreService();

  late final TextEditingController _titreCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _prixCtrl;
  late String _statut;
  String _categorieSelectionnee = '';

  File? _photoPrincipaleSelectionnee;
  final List<File> _nouvellesImagesDetails = [];
  late List<String> _imagesDetailsExistantes;
  bool _enregistrement = false;
  bool _garderPhotoActuelle = true;

  @override
  void initState() {
    super.initState();
    _titreCtrl = TextEditingController(text: widget.annonce.nameArticle);
    _descriptionCtrl = TextEditingController(text: widget.annonce.description);
    _prixCtrl = TextEditingController(text: widget.annonce.prix.toString());
    _statut = widget.annonce.statut;
    _imagesDetailsExistantes = List<String>.from(widget.annonce.imagesDetails);
    _categorieSelectionnee = widget.annonce.categorieId; // Fallback while loading name
    _resolveCategorieName();
  }

  Future<void> _resolveCategorieName() async {
    try {
      final nom = await _firestoreService.getCategorieNomById(widget.annonce.categorieId);
      if (mounted) {
        setState(() => _categorieSelectionnee = nom);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _categorieSelectionnee = widget.annonce.categorieId);
      }
    }
  }

  @override
  void dispose() {
    _titreCtrl.dispose();
    _descriptionCtrl.dispose();
    _prixCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirPhotoPrincipale() async {
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
                if (photo != null) {
                  setState(() {
                    _photoPrincipaleSelectionnee = File(photo.path);
                    _garderPhotoActuelle = false;
                  });
                }
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
                if (image != null) {
                  setState(() {
                    _photoPrincipaleSelectionnee = File(image.path);
                    _garderPhotoActuelle = false;
                  });
                }
              },
            ),
            if (!_garderPhotoActuelle)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Conserver la photo actuelle'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _photoPrincipaleSelectionnee = null;
                    _garderPhotoActuelle = true;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _ajouterPhotosDetails() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _nouvellesImagesDetails.addAll(
            images.map((xFile) => File(xFile.path)).toList(),
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection des images : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _supprimerImageDetails(int index) {
    setState(() {
      if (index < _imagesDetailsExistantes.length) {
        _imagesDetailsExistantes.removeAt(index);
      } else {
        _nouvellesImagesDetails.removeAt(index - _imagesDetailsExistantes.length);
      }
    });
  }

  void _enregistrer() {
    if (!_formKey.currentState!.validate()) return;

    final prix = int.tryParse(_prixCtrl.text.trim());
    if (prix == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un montant valide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_categorieSelectionnee.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez renseigner une catégorie'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _enregistrement = true);

    _enregistrerAsync(prix);
  }

  Future<void> _enregistrerAsync(int prix) async {
    try {
      String photoFinale;
      if (_photoPrincipaleSelectionnee != null) {
        photoFinale = await _firestoreService.uploadArticleImage(
          _photoPrincipaleSelectionnee!,
          widget.annonce.vendeurId,
        );
      } else if (_garderPhotoActuelle) {
        photoFinale = widget.annonce.photo;
      } else {
        photoFinale = '';
      }

      final nouvellesUrls = <String>[];
      for (final image in _nouvellesImagesDetails) {
        final url = await _firestoreService.uploadArticleImage(
          image,
          widget.annonce.vendeurId,
        );
        nouvellesUrls.add(url);
      }

      final categorieId = await _firestoreService.getOrCreateCategorieId(
        _categorieSelectionnee,
      );

      final annonceMiseAJour = ArticlesModels(
        id: widget.annonce.id,
        photo: photoFinale,
        imagesDetails: [..._imagesDetailsExistantes, ...nouvellesUrls],
        nameArticle: _titreCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        prix: prix,
        vendeurId: widget.annonce.vendeurId,
        categorieId: categorieId,
        statut: _statut,
      );

      await ref
          .read(mesAnnoncesRepositoryProvider)
          .updateAnnonce(annonceMiseAJour);

      if (!mounted) return;
      setState(() => _enregistrement = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Annonce mise à jour')));
    } catch (e) {
      if (!mounted) return;
      setState(() => _enregistrement = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoAafficher = _photoPrincipaleSelectionnee != null
        ? Image.file(_photoPrincipaleSelectionnee!, fit: BoxFit.cover)
        : _garderPhotoActuelle && widget.annonce.photo.isNotEmpty
        ? Image.network(widget.annonce.photo, fit: BoxFit.cover)
        : const Center(
            child: Icon(
              Icons.camera_alt_outlined,
              size: 40,
              color: AppColors.grisTexte,
            ),
          );

    return Scaffold(
      appBar: CustomHeader(
        title: 'Modifier l\'annonce',
        showLogo: true,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _choisirPhotoPrincipale,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: photoAafficher,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Photos de détails (${_imagesDetailsExistantes.length + _nouvellesImagesDetails.length})',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.grisTexte,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _ajouterPhotosDetails,
                    icon: const Icon(
                      Icons.add_a_photo,
                      size: 16,
                      color: AppColors.orangePrincipal,
                    ),
                    label: const Text(
                      'Ajouter plus',
                      style: TextStyle(
                        color: AppColors.orangePrincipal,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (_imagesDetailsExistantes.isNotEmpty ||
                  _nouvellesImagesDetails.isNotEmpty)
                SizedBox(
                  height: 96,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        _imagesDetailsExistantes.length +
                        _nouvellesImagesDetails.length,
                    itemBuilder: (context, index) {
                      final estExistante =
                          index < _imagesDetailsExistantes.length;
                      final widgetImage = estExistante
                          ? Image.network(
                              _imagesDetailsExistantes[index],
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _nouvellesImagesDetails[index -
                                  _imagesDetailsExistantes.length],
                              fit: BoxFit.cover,
                            );

                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.grisClair),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: widgetImage,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 10,
                            child: GestureDetector(
                              onTap: () => _supprimerImageDetails(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Titre de l'annonce",
                hintText: 'Ex : Manuel d\'algorithmique S3',
                controller: _titreCtrl,
                validator: (val) => val == null || val.isEmpty
                    ? 'Ce champ est obligatoire'
                    : null,
              ),
              CustomTextField(
                label: 'Description',
                hintText: 'Décris l\'état, les détails utiles...',
                controller: _descriptionCtrl,
                maxLines: 4,
                validator: (val) => val == null || val.isEmpty
                    ? 'Ce champ est obligatoire'
                    : null,
              ),
              CustomTextField(
                label: 'Prix (FCFA)',
                hintText: 'Ex : 5000',
                controller: _prixCtrl,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  if (int.tryParse(val) == null) {
                    return 'Veuillez entrer un montant valide';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Catégorie',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: AppColors.noir,
                      fontSize: 14,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final nouvelleCatSaisie = await CustomInputModal.show(
                        context,
                        title: 'Nouvelle catégorie',
                        label: 'Nom de la catégorie',
                        hintText: 'Ex: Électroménager, Événements...',
                        submitButtonText: 'Créer',
                      );

                      if (nouvelleCatSaisie != null &&
                          nouvelleCatSaisie.trim().isNotEmpty) {
                        setState(() {
                          _categorieSelectionnee = nouvelleCatSaisie.trim();
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 16,
                      color: AppColors.orangePrincipal,
                    ),
                    label: const Text(
                      'Créer une catégorie',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: AppColors.orangePrincipal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ref
                  .watch(categoriesStreamProvider)
                  .when(
                    data: (listeCategories) {
                      final nExistePasDansLaListe =
                          !listeCategories.any(
                            (cat) => cat['nom'] == _categorieSelectionnee,
                          );
                      return DropdownButtonFormField<String>(
                        initialValue: _categorieSelectionnee,
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
                          ...listeCategories.map((cat) {
                            return DropdownMenuItem(
                              value: cat['nom'],
                              child: Text(
                                cat['nom']!,
                                style: const TextStyle(color: AppColors.noir),
                              ),
                            );
                          }),
                          if (nExistePasDansLaListe)
                            DropdownMenuItem(
                              value: _categorieSelectionnee,
                              child: Text(
                                '✨ $_categorieSelectionnee',
                                style: const TextStyle(color: AppColors.noir),
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _categorieSelectionnee = value);
                          }
                        },
                        validator: (val) => val == null || val.isEmpty
                            ? 'Veuillez choisir une catégorie'
                            : null,
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orangePrincipal,
                      ),
                    ),
                    error: (err, stack) => Text('Erreur de chargement : $err'),
                  ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _statut,
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
                    borderSide: const BorderSide(color: AppColors.grisClair),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'vendue', child: Text('Vendue')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _statut = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Enregistrer',
                isLoading: _enregistrement,
                onPressed: _enregistrement ? () {} : _enregistrer,
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  '* Les images non supprimées sont conservées',
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