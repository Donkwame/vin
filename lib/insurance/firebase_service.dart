import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateVehicleInsurance(String registrationNumber) async {
    try {
      await _firestore.collection('vehicles').doc(registrationNumber).update({
        'hasInsurance': true,
      });
    } catch (e) {
      throw Exception('Error updating vehicle insurance: $e');
    }
  }
}
