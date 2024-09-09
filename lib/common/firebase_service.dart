// lib/common/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchVehicleData(String registrationnumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('vehicles') // Replace with your collection name
          .where('registrationnumber', isEqualTo: registrationnumber)
          .get();

      print('Query Snapshot: ${querySnapshot.docs.length} document(s) found');
      
      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        print('Document Data: ${document.data()}');
        return document.data();
      } else {
        throw Exception('No information found');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  updateVehicleInsurance(String registrationNumber) {}
}
