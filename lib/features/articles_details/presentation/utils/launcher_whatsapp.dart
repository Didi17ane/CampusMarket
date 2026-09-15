import 'package:url_launcher/url_launcher.dart';

/// Ouvre une conversation WhatsApp avec le numéro donné.
///
/// [numeroTelephone] doit inclure l'indicatif du pays (ex: "+261 34 12 345 67").
/// [message] est optionnel : si fourni, il sera pré-rempli dans la conversation.
Future<void> ouvrirWhatsApp(String numeroTelephone, {String? message}) async {
  // Nettoie le numéro : ne garde que les chiffres (retire le +, espaces,
  // tirets, parenthèses), car wa.me attend uniquement des chiffres.
  final numeroNettoye = numeroTelephone.replaceAll(RegExp(r'[^\d]'), '');

  if (numeroNettoye.isEmpty || numeroNettoye.length < 8) {
    throw Exception('Numéro de téléphone invalide : $numeroTelephone');
  }

  final texteEncode = message != null ? Uri.encodeComponent(message) : null;

  final url = Uri.https(
    'wa.me',
    '/$numeroNettoye',
    texteEncode != null ? {'text': texteEncode} : null,
  );

  if (!await canLaunchUrl(url)) {
    throw Exception(
      'Impossible d\'ouvrir WhatsApp pour le numéro $numeroTelephone',
    );
  }

  await launchUrl(url, mode: LaunchMode.externalApplication);
}
