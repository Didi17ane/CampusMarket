import 'package:campusmarket/core/constants/theme_contants.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:campusmarket/features/articles_details/presentation/providers/user_detail_provider.dart';
import 'package:campusmarket/features/auth/data/models/users_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetTile extends StatelessWidget {
  final Users user;
  final bool userSeller;
  final CommentairesModels? comment;
  final double? noteMoyenne;

  const WidgetTile({
    super.key,
    this.comment,
    required this.user,
    this.userSeller = false,
    this.noteMoyenne,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !userSeller
                  ? CircleAvatar(
                      radius: 18,
                      // backgroundImage: NetworkImage(comment.avatarUrl),
                      child: Text(user.name[0]),
                    )
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: AppColors.orangePrincipal,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.orangePrincipal.withValues(alpha: 0.3),
                      ),
                      child: Center(
                        child: Text(
                          user.name[0],
                          style: TextStyle(
                            color: AppColors.orangePrincipal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),

                    if (userSeller) ...[
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            final isFilled =
                                noteMoyenne != null &&
                                index < noteMoyenne!.round();
                            return Icon(
                              isFilled ? Icons.star : Icons.star_border,
                              size: 15,
                              color: isFilled
                                  ? AppColors.orangePrincipal
                                  : Colors.grey,
                            );
                          }),
                          if (noteMoyenne != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              noteMoyenne!.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.orangePrincipal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: List.generate(5, (index) {
                          final starCount = comment?.note ?? 0;
                          return Icon(
                            index < starCount ? Icons.star : Icons.star_border,
                            size: 15,
                            color: index < starCount
                                ? AppColors.orangePrincipal
                                : Colors.grey,
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          (comment != null)
              ? Text(comment!.contenu, style: const TextStyle(fontSize: 14))
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class CommentItem extends ConsumerWidget {
  final CommentairesModels comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorAsync = ref.watch(userDetailProvider(comment.auteurId.trim()));

    return authorAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return WidgetTile(user: user, comment: comment);
      },
      loading: () => const SizedBox(
        height: 40,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => Text(comment.contenu),
    );
  }
}
