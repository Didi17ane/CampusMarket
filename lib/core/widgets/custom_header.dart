import 'package:flutter/material.dart';
import 'package:campusmarket/core/constants/theme_contants.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // le titre de la page 'oprionnel'
  final bool
  showLogo; // bool pour afficher le logo à coté du titre 'est à false par defaut'
  final List<Widget>?
  rightAction; // Pour ajouter des element a droite s'il y en a (esx: menu, profile avatar, ...)
  final Widget? leftWidget; // Pour ajouter des element à gauche
  final Color? backgroundColor; // la couleur d'arrière (à noir par defaut)
  final bool centerTitle; // le titre doit-être centré ?
  final double
  toolbarHeight; // hauteur du header (par defaut kToolbarHeight, plus grand si titre sur 2 lignes)
  final double
  leadingWidth; // largeur réservée à gauche (56 par defaut, mettre 0 si leftWidget vide pour ne pas laisser d'espace)
  const CustomHeader({
    super.key,
    this.title,
    this.showLogo = false,
    this.centerTitle = true,
    this.rightAction,
    this.leftWidget,
    this.backgroundColor,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth = 56,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.noir,
      elevation: 0,
      toolbarHeight: toolbarHeight,

      iconTheme: const IconThemeData(color: AppColors.blanc),

      iconTheme: const IconThemeData(color: AppColors.blanc),
      
      // Widget a gauche si fournir remplace le bouton retour
      leading: leftWidget,
      leadingWidth: leftWidget == null ? null : leadingWidth,
      automaticallyImplyLeading: leftWidget == null,

      // Titre dynamique OU Logo de l'application
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo) ...[
            Image.asset(
              'assets/images/CampusMarket_logo_icone.png',
              height: 40,
            ),
            SizedBox(width: 8),
          ],

          Text(
            title ?? '',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: AppColors.blanc,
            ),
          ),
        ],
      ),
      actions: rightAction,

      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}