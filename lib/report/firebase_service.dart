import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload images to Firebase Storage and return their URLs
  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = _storage.ref().child('reports/images/$fileName');
        UploadTask uploadTask = ref.putFile(image);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
        throw Exception('Image upload failed');
      }
    }

    return imageUrls;
  }

  // Upload report data to Firestore and mark the vehicle as stolen
  Future<void> uploadReport({
    required String registrationNumber,
    required String name,
    required String vin,
    required String phoneNumber,
    required List<String> imageUrls,
  }) async {
    try {
      // Step 1: Upload report data to the 'reports' collection
      await _firestore.collection('reports').add({
        'registration_number': registrationNumber,
        'name': name,
        'vin': vin,
        'phone_number': phoneNumber,
        'image_urls': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Step 2: Mark the vehicle as stolen in the 'vehicles' collection
      QuerySnapshot vehicleSnapshot = await _firestore
          .collection('vehicles')
          .where('registrationnumber', isEqualTo: registrationNumber)
          .get();

      if (vehicleSnapshot.docs.isNotEmpty) {
        // If the vehicle exists, update its status
        DocumentReference vehicleDoc = vehicleSnapshot.docs.first.reference;
        await vehicleDoc.update({'status': 'stolen'});

        print('Vehicle marked as stolen');
      } else {
        print('Vehicle not found in the database');
        throw Exception('Vehicle not found');
      }
    } catch (e) {
      print('Error uploading report or updating vehicle status: $e');
      throw Exception('Report upload or vehicle status update failed');
    }
  }
}
