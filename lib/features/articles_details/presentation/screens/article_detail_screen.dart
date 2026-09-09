import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:campusmarket/features/articles_details/data/data_sources/mock_data.dart';
import 'package:campusmarket/features/articles_details/presentation/widgets/comment_tile.dart';
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String imageUrl;

  const ArticleDetailScreen({
    super.key,
    this.imageUrl =
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop',
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final TextEditingController commentController = TextEditingController();

  void addComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      mockCommentaires.insert(
        0,
        CommentairesModels(
          id: 'com_3',
          contenu: text,
          datePublication: DateTime.now().subtract(const Duration(minutes: 30)),
          produitId: 'art_1',
          auteurId: 'user_misa',
        ),
      );
    });
    commentController.clear();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          height: 400,
                          width: MediaQuery.sizeOf(context).width,
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 64,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      const Text(
                        "Veste noire",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "20000 Ar",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 199, 199, 199),
                            ),
                          ),
                          const Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20, thickness: 3),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      const Text(
                        textAlign: TextAlign.justify,
                        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod.",
                        style: TextStyle(fontSize: 13),
                      ),

                      const Divider(height: 20, thickness: 3),
                      const SizedBox(height: 4),
                      // --- Section commentaires ---
                      Text(
                        "Commentaires (${mockCommentaires.length})",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: mockCommentaires.length,
                        separatorBuilder: (context, _) =>
                            const Divider(thickness: 0.5),
                        itemBuilder: (context, index) =>
                            CommentTile(comment: mockCommentaires[index]),
                      ),
                    ],
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
