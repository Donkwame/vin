import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin/common/firebase_service.dart';

import 'insurance.dart'; // Import the Firebase service class

class NextPage extends StatelessWidget {
  final double annualPremium;

  const NextPage({
    super.key,
    required this.annualPremium, required String registrationNumber,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _phoneController = TextEditingController();
    final FirebaseService _firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'GHS ${annualPremium.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            Text(
              'Make Payment',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.normal,
                color: const Color.fromARGB(255, 20, 19, 21),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Makes the TextField take up all available width
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'MTN', child: Text('MTN')),
                DropdownMenuItem(value: 'Telecel', child: Text('Telecel')),
                DropdownMenuItem(value: 'AT', child: Text('AT')),
              ],
              onChanged: (value) {
                // Handle dropdown value change
              },
              decoration: const InputDecoration(
                labelText: 'Select Payment Method',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Assuming you have a way to get the registration number
                  String registrationNumber = ''; // Retrieve this as needed
                  await _firebaseService.updateVehicleInsurance(registrationNumber);

                  // Show a pop-up message
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thank you for your payment'),
                        content: const Text(
                          'We are processing your insurance documents. It will be sent to your email within 24 hours. Contact us at 0203672418 for inquiries.',
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                            Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Insurance(),
                          ),
                        );
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      );
                    },
                  );
                } catch (e) {
                  // Handle errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: Container(
                constraints: const BoxConstraints(maxHeight: 50),
                child: const Center(child: Text('Submit Payment')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
