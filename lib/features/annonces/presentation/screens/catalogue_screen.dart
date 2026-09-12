import 'package:flutter/material.dart';
import '../../data/repositories/annonces_repository.dart';
import '../../data/repositories/categories_repository.dart';
import '../../../auth/data/models/articles_models.dart';
import '../../../auth/data/models/categories_models.dart';
import '../widgets/product_card.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/search_bar_widget.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final AnnoncesRepository _annoncesRepository = AnnoncesRepository();
  final CategoriesRepository _categoriesRepository = CategoriesRepository();

  static const String _autresCategorieId = '__autres__';
  static const int _taillePage = 15;

  String? _categorieSelectionnee;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  final TextEditingController _rechercheController = TextEditingController();
  String _texteRecherche = '';

  int _pageActuelle = 0;

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    _rechercheController.dispose();
    super.dispose();
  }

  void _reinitialiserPagination() {
    setState(() => _pageActuelle = 0);
  }

  List<ArticlesModels> _appliquerFiltres(
      List<ArticlesModels> produits, List<CategoriesModels> categories) {
    final idsConnus = categories.map((c) => c.id).toSet();

    return produits.where((p) {
      if (_categorieSelectionnee != null) {
        if (_categorieSelectionnee == _autresCategorieId) {
          final estAutres = p.categorieId.isEmpty || !idsConnus.contains(p.categorieId);
          if (!estAutres) return false;
        } else if (p.categorieId != _categorieSelectionnee) {
          return false;
        }
      }
      final min = int.tryParse(_minController.text);
      if (min != null && p.prix < min) return false;
      final max = int.tryParse(_maxController.text);
      if (max != null && p.prix > max) return false;

      // recherche par titre (insensible à la casse et aux espaces superflus)
      if (_texteRecherche.trim().isNotEmpty) {
        final texte = _texteRecherche.trim().toLowerCase();
        final titreCorrespond = p.nameArticle.toLowerCase().contains(texte);
        final descriptionCorrespond = p.description.toLowerCase().contains(texte);
        if (!titreCorrespond && !descriptionCorrespond) return false;
      }
      return true;
    }).toList();
  }

  void _reinitialiserFiltres() {
    setState(() {
      _categorieSelectionnee = null;
      _minController.clear();
      _maxController.clear();
      _rechercheController.clear();
      _texteRecherche = '';
      _pageActuelle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F2),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'CampusMarket'),
            SearchBarWidget(
              enabled: true,
              controller: _rechercheController,
              onChanged: (valeur) {
                setState(() => _texteRecherche = valeur);
                _reinitialiserPagination();
              },
            ),
            Expanded(
              child: StreamBuilder<List<CategoriesModels>>(
                stream: _categoriesRepository.getCategories(),
                builder: (context, categorieSnapshot) {
                  final categories = categorieSnapshot.data ?? [];
                  return Column(
                    children: [
                      _buildCategoryChips(categories),
                      _buildPriceFilter(),
                      Expanded(
                        child: StreamBuilder<List<ArticlesModels>>(
                          stream: _annoncesRepository.getProduits(),
                          builder: (context, produitSnapshot) {
                            if (produitSnapshot.hasError) {
                              return Center(child: Text('Erreur : ${produitSnapshot.error}'));
                            }
                            if (produitSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(color: Color(0xFFFF6600)),
                              );
                            }

                            final produitsFiltres = _appliquerFiltres(
                              produitSnapshot.data ?? [],
                              categories,
                            );

                            if (produitsFiltres.isEmpty) {
                              return _buildEmptyState();
                            }

                            final totalPages =
                                (produitsFiltres.length / _taillePage).ceil();

                            if (_pageActuelle >= totalPages) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() => _pageActuelle = 0);
                              });
                            }

                            final debut = _pageActuelle * _taillePage;
                            final fin = (debut + _taillePage > produitsFiltres.length)
                                ? produitsFiltres.length
                                : debut + _taillePage;
                            final produitsAffiches = produitsFiltres.sublist(debut, fin);

                            return Column(
                              children: [
                                Expanded(
                                  child: GridView.builder(
                                    padding: const EdgeInsets.all(16),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.68,
                                    ),
                                    itemCount: produitsAffiches.length,
                                    itemBuilder: (context, index) {
                                      final produit = produitsAffiches[index];
                                      return ProductCard(
                                        produit: produit,
                                        onTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Produit : ${produit.nameArticle}')),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                _buildPagination(totalPages),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    final estPremierePage = _pageActuelle == 0;
    final estDernierePage = _pageActuelle >= totalPages - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFF0F0F2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: estPremierePage
                ? null
                : () => setState(() => _pageActuelle--),
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            label: const Text('Précédent'),
            style: TextButton.styleFrom(
              foregroundColor: estPremierePage ? Colors.grey : const Color(0xFFFF6600),
            ),
          ),
          Text(
            'Page ${_pageActuelle + 1} / $totalPages',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          TextButton.icon(
            onPressed: estDernierePage
                ? null
                : () => setState(() => _pageActuelle++),
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            label: const Text('Suivant'),
            style: TextButton.styleFrom(
              foregroundColor: estDernierePage ? Colors.grey : const Color(0xFFFF6600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(List<CategoriesModels> categories) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(
            label: 'Toutes',
            active: _categorieSelectionnee == null,
            onTap: () {
              setState(() => _categorieSelectionnee = null);
              _reinitialiserPagination();
            },
          ),
          const SizedBox(width: 10),
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _chip(
                  label: cat.nameCategorie,
                  active: _categorieSelectionnee == cat.id,
                  onTap: () {
                    setState(() => _categorieSelectionnee = cat.id);
                    _reinitialiserPagination();
                  },
                ),
              )),
          _chip(
            label: 'Autre',
            active: _categorieSelectionnee == _autresCategorieId,
            onTap: () {
              setState(() => _categorieSelectionnee = _autresCategorieId);
              _reinitialiserPagination();
            },
          ),
        ],
      ),
    );
  }

  Widget _chip({required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: active ? const Color(0xFFFF6600) : Colors.white,
        labelStyle: TextStyle(color: active ? Colors.white : Colors.black87),
        side: BorderSide(color: active ? Colors.transparent : Colors.grey.shade300),
      ),
    );
  }

  Widget _buildPriceFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          const Text('Prix :', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _minController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Min',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (_) => _reinitialiserPagination(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _maxController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Max',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (_) => _reinitialiserPagination(),
            ),
          ),
          TextButton(
            onPressed: _reinitialiserFiltres,
            child: const Text('Réinitialiser',
                style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('Aucun produit ne correspond à ces filtres', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}