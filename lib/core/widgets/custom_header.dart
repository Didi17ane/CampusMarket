import 'package:flutter/material.dart';
import 'package:campusmarket/core/constants/theme_contants.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // le titre de la page 'oprionnel'
  final bool
  showLogo; // bool pour afficher le logo à coté du titre 'est à false par defaut'
  final bool
  showMenuButton; // affiche un bouton menu (☰) qui ouvre automatiquement le Drawer de l'écran
  final List<Widget>?
  rightAction; // Pour ajouter des element a droite s'il y en a (esx: menu, profile avatar, ...)
  final Widget? leftWidget; // Pour ajouter des element à gauche
  final Color? backgroundColor; // la couleur d'arrière (à noir par defaut)
  final bool centerTitle; // le titre doit-être centré ?
  const CustomHeader({
    super.key,
    this.title,
    this.showLogo = false,
    this.showMenuButton = false,
    this.centerTitle = false,
    this.rightAction,
    this.leftWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.noir,
      elevation: 0,

      // On gère nous-mêmes tout ce qui apparaît à gauche (leftWidget, ou rien).
      // Flutter n'ajoute donc plus JAMAIS de bouton automatique tout seul,
      // même si le Scaffold a un drawer — ça évite le doublon avec showMenuButton.
      automaticallyImplyLeading: false,
      leading: leftWidget,
      // si aucun leftWidget n'est fourni, on ne réserve aucune place à gauche
      // (au lieu des 56px par défaut) : le logo colle bien au bord, comme sur la maquette.
      leadingWidth: leftWidget != null ? null : 0,
      titleSpacing: 20,

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

      // showMenuButton ajoute le bouton ☰ qui ouvre le Drawer.
      // On garde aussi rightAction pour les autres icônes (favoris, recherche, etc.)
      actions: [
        if (showMenuButton)
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: AppColors.blanc),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        if (rightAction != null) ...rightAction!,
      ],

      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}