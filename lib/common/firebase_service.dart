import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchVehicleData(String registrationnumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('vehicles')
          .where('registrationnumber', isEqualTo: registrationnumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        final data = document.data();

        // Check if the status indicates the vehicle is stolen
        String status = data['status'] ?? 'unknown'; // Default to 'unknown' if status is missing
        bool isStolen = status.toLowerCase() == 'stolen'; // Compare status as a string

        return {
          ...data,
          'isStolen': isStolen,
        };
      } else {
        throw Exception('No information found');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
