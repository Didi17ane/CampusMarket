import 'package:campusmarket/core/constants/colors.dart';
import 'package:campusmarket/core/constants/theme_contants.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:campusmarket/features/articles_details/presentation/providers/article_provider.dart';
import 'package:campusmarket/features/articles_details/presentation/providers/comment_provider.dart';
import 'package:campusmarket/features/articles_details/presentation/providers/user_detail_provider.dart';
import 'package:campusmarket/features/articles_details/presentation/utils/launcher_whatsapp.dart';
import 'package:campusmarket/features/articles_details/presentation/widgets/image_carousel.dart';
import 'package:campusmarket/features/articles_details/presentation/widgets/widget_tile.dart';
import 'package:campusmarket/features/auth/data/models/users_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ArticleDetailScreen extends ConsumerStatefulWidget {
  final String articleId;
  final String vendeurId;

  const ArticleDetailScreen({
    super.key,
    required this.articleId,
    required this.vendeurId,
  });

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  final TextEditingController commentController = TextEditingController();
  int ratingValue = 0;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = ref.watch(articleDetailProvider(widget.articleId));
    final comments = ref.watch(commentNotifierProvider(widget.articleId));
    final seller = ref.watch(userDetailProvider(widget.vendeurId));

    // Calcul de la note moyenne (mis à jour à chaque rebuild)
    final commentsData = comments.asData?.value ?? [];
    final notesWithValues = commentsData
        .where((c) => c.note != null && c.note! > 0)
        .toList();
    final double? noteMoyenne = notesWithValues.isEmpty
        ? null
        : notesWithValues.map((c) => c.note!).reduce((a, b) => a + b) /
              notesWithValues.length;

    void addComment() {
      final text = commentController.text.trim();
      if (text.isEmpty) return;
      ref
          .read(commentNotifierProvider(widget.articleId).notifier)
          .addComment(
            CommentairesModels(
              contenu: text,
              datePublication: DateTime.now(),
              produitId: widget.articleId,
              note: ratingValue,
              auteurId: ' test-user-001 ', //user_courant
            ),
          );
      commentController.clear();
    }

    void buttonSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Donner votre avis",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setModalState(() {
                              ratingValue = index + 1;
                            });
                          },
                          icon: Icon(
                            index < ratingValue
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Row(
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
                          onPressed: () {
                            addComment();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: true,
        child: Stack(
          children: [
            Container(color: Colors.black),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: article.when(
                            data: (data) {
                              final allImages = [
                                data.photo,
                                ...data.imagesDetails,
                              ];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        data.photo.isNotEmpty
                                            ? ArticleImageCarousel(
                                                images: allImages,
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
                                        Positioned(
                                          top: 12,
                                          left: 12,
                                          right: 12,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.6),
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () =>
                                                      context.pop(),
                                                  icon: const Icon(
                                                    size: 16,
                                                    color: Colors.white,
                                                    Icons.arrow_back_ios_new,
                                                  ),
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/icon/icon.png",
                                                height: 40,
                                                width: 40,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    data.nameArticle, //nameArticle
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.prix.toString(), //price
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.orangeFonce,
                                        ),
                                      ),
                                      Text(
                                        data.statut, //statut
                                        style: TextStyle(
                                          fontFamily: "Inter",
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
                                      color: AppColors.orangeFonce,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "Catégorie",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  const Text(
                                    "Description",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    textAlign: TextAlign.justify,
                                    data.description,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const Divider(height: 20, thickness: 1),
                                  const SizedBox(height: 4),
                                  // --- Section commentaires ---
                                  seller.when(
                                    data: (Users? sellerData) {
                                      return SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            WidgetTile(
                                              user: sellerData!,
                                              userSeller: true,
                                              noteMoyenne: noteMoyenne,
                                            ),
                                            Center(
                                              child: SizedBox(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF25D366),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      await ouvrirWhatsApp(
                                                        sellerData
                                                            .phoneNumber, // ⭐ le numéro du vendeur récupéré via le provider
                                                        message:
                                                            'Bonjour, je suis intéressé par ${data.nameArticle}!',
                                                      );
                                                    } catch (e) {
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Impossible d\'ouvrir WhatsApp',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                    "Contacter le vendeur(WhatsApp)",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    error:
                                        (Object error, StackTrace stackTrace) {
                                          return Center(
                                            child: Text("Aucune données"),
                                          );
                                        },
                                    loading: () {
                                      return CircularProgressIndicator();
                                    },
                                  ),
                                  const Divider(height: 20, thickness: 1),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        buttonSheet();
                                      },
                                      child: Text("Donner votre avis"),
                                    ),
                                  ),

                                  comments.when(
                                    data: (commentsData) {
                                      if (commentsData.isEmpty) {
                                        return SizedBox.shrink();
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                "Avis(${commentsData.length})",
                                                style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: commentsData.length,
                                              separatorBuilder: (context, _) =>
                                                  const Divider(thickness: 0.5),
                                              itemBuilder: (context, index) =>
                                                  CommentItem(
                                                    comment:
                                                        commentsData[index],
                                                  ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                    error:
                                        (Object error, StackTrace stackTrace) {
                                          print("data error: $error");
                                          return Center(
                                            child: Text("Aucune commentaire"),
                                          );
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
