import 'package:url_launcher/url_launcher.dart';

Future<void> ouvrirWhatsApp(String numeroTelephone, {String? message}) async {
  // Nettoie le numéro (retire espaces, tirets, parenthèses)
  final numeroNettoye = numeroTelephone.replaceAll(RegExp(r'[^\d+]'), '');

  //Encode le texte du message pour qu'il soit valide dans une URL
  final texteEncode = message != null ? Uri.encodeComponent(message) : '';
  //Construit l'URL finale, au format attendu par WhatsApp
  final url = Uri.parse(
    'https://wa.me/$numeroNettoye${message != null ? '?text=$texteEncode' : ''}',
  );
  //Vérifie si l'appareil est capable d'ouvrir ce type d'URL (WhatsApp installé, ou navigateur disponible en fallback).
  if (await canLaunchUrl(url)) {
    //Ouvre réellement l'URL, en forçant l'ouverture dans une app externe (WhatsApp ou navigateur)
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw Exception('Impossible d\'ouvrir WhatsApp');
  }
}
