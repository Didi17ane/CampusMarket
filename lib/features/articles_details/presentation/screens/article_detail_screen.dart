import 'package:cached_network_image/cached_network_image.dart';
import 'package:campusmarket/core/constants/colors.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';

import 'package:campusmarket/features/articles_details/presentation/providers/article_provider.dart';
import 'package:campusmarket/features/articles_details/presentation/providers/comment_provider.dart';
import 'package:campusmarket/features/articles_details/presentation/widgets/comment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const ArticleDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = ref.watch(articleDetailProvider(widget.id));
    final comments = ref.watch(commentNotifierProvider(widget.id));
    void addComment() {
      final text = commentController.text.trim();
      if (text.isEmpty) return;
      ref
          .read(commentNotifierProvider(widget.id).notifier)
          .addComment(
            CommentairesModels(
              contenu: text,
              datePublication: DateTime.now(),
              produitId: widget.id,
              auteurId: ' test-user-001 ', //user_courant
            ),
          );
      commentController.clear();
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: article.when(
                    data: (data) {
                      print("data article: ${data.nameArticle}");
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: data.photo.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: data.photo,
                                    height: 350,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    // Optimisation RAM : redimensionne l'image au décodage pour ne pas saturer la mémoire
                                    memCacheWidth: 800,
                                    memCacheHeight: 800,
                                    // Optimisation Disque : limite la taille du fichier enregistré dans le cache
                                    maxWidthDiskCache: 800,
                                    maxHeightDiskCache: 800,
                                    fadeInDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    progressIndicatorBuilder:
                                        (
                                          context,
                                          url,
                                          downloadProgress,
                                        ) => Container(
                                          height: 350,
                                          width: double.infinity,
                                          color: Colors.grey.shade200,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          height: 350,
                                          width: double.infinity,
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                  )
                                : Container(
                                    height: 350,
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.nameArticle, //nameArticle
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.prix.toString(), //price
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 199, 199, 199),
                                ),
                              ),
                              Text(
                                data.statut, //statut
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Catégorie",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            textAlign: TextAlign.justify,
                            data.description,
                            style: TextStyle(fontSize: 13),
                          ),

                          const Divider(height: 20, thickness: 3),
                          const SizedBox(height: 4),
                          // --- Section commentaires ---
                          SizedBox(
                            child: Text(
                              "Commentaires",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          comments.when(
                            data: (data) {
                              if (data.isEmpty) {
                                return SizedBox.shrink();
                              } else {
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.length,
                                  separatorBuilder: (context, _) =>
                                      const Divider(thickness: 0.5),
                                  itemBuilder: (context, index) =>
                                      CommentTile(comment: data[index]),
                                );
                              }
                            },
                            error: (Object error, StackTrace stackTrace) {
                              print("data error: $error");
                              return Center(child: Text("Aucune commentaire"));
                            },
                            loading: () {
                              return CircularProgressIndicator();
                            },
                          ),
                        ],
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return Center(
                        child: Text(
                          "Aucune donnée",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                    loading: () {
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),

            // --- Champ pour ajouter un commentaire ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Ajouter un commentaire...",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: addComment,
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
