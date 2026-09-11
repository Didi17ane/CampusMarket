import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> seedArticles() async {
  final collection = FirebaseFirestore.instance.collection('Articles');
  final batch = FirebaseFirestore.instance.batch();

  final data = {
    'Hc2ERMJetxGw8nh5yVcL': {
      'titre': 'Manuel Algorithmique S3',
      'description': 'Livre en bon état, cours complet du semestre 3',
      'prix': 5000,
      'photo': 'https://picsum.photos/seed/livre1/400/300',
    },
    'cH9BJe8utnVrIFkFwf7y': {
      'titre': 'Vélo pliant Décathlon',
      'description': 'Pneus neufs, freins révisés, idéal pour le campus',
      'prix': 45000,
      'photo': 'https://picsum.photos/seed/velo1/400/300',
    },
    'hSkVy2lnAWzEQ9djPZK6': {
      'titre': 'Chaise de bureau',
      'description': 'Chaise ergonomique, très confortable',
      'prix': 12000,
      'photo': 'https://picsum.photos/seed/chaise1/400/300',
    },
    'ruUDyvqL8LUjugL4vyK6': {
      'titre': 'Casque audio Bluetooth',
      'description': 'Casque sans fil, autonomie 20h',
      'prix': 8500,
      'photo': 'https://picsum.photos/seed/casque1/400/300',
    },
  };

  data.forEach((id, valeurs) {
    batch.set(collection.doc(id), valeurs);
  });

  await batch.commit();
  print(' 4 articles insérés dans Firestore !');
}