import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> fetchAllItems() async {
    QuerySnapshot snapshot = await _firestore.collection('store').get();
    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> searchItems(String searchText) async {
    String lowerSearchText = searchText.toLowerCase();

    // Query for items matching name or partnumber
    QuerySnapshot nameQuery = await _firestore
        .collection('store')
        .where('name', isGreaterThanOrEqualTo: lowerSearchText)
        .where('name', isLessThanOrEqualTo: '$lowerSearchText\uf8ff')
        .get();

    QuerySnapshot partNumberQuery = await _firestore
        .collection('store')
        .where('partnumber', isGreaterThanOrEqualTo: lowerSearchText)
        .where('partnumber', isLessThanOrEqualTo: '$lowerSearchText\uf8ff')
        .get();

    // Combine results and remove duplicates 0063 038
    List<DocumentSnapshot> results = [
      ...nameQuery.docs,
      ...partNumberQuery.docs,
    ].toSet().toList();

    return results;
  }
}
