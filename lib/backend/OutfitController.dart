import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Outfit.dart';

Future<void> createOutfit(String name, List<String> itemIds) async {
  CollectionReference outfits = FirebaseFirestore.instance.collection('outfits');
  await outfits.add({
    'name': name,
    'itemIds': itemIds,
  });
}

Future<Outfit?> readOutfit(String outfitId) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('outfits').doc(outfitId).get();
  if (snapshot.exists) {
    return Outfit.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }
  return null;
}

Future<void> updateOutfit(String outfitId, String name, List<String> itemIds) async {
  DocumentReference docRef = FirebaseFirestore.instance.collection('outfits').doc(outfitId);
  await docRef.update({
    'name': name,
    'itemIds': itemIds,
  });
}

Future<void> deleteOutfit(String outfitId) async {
  DocumentReference docRef = FirebaseFirestore.instance.collection('outfits').doc(outfitId);
  await docRef.delete();
}

