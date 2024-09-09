import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vin/common/firebase_service.dart';
import 'package:vin/insurance/next_page.dart';

class New extends StatefulWidget {
  const New({super.key});

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  final Logger _logger = Logger();
  final FirebaseService _firebaseService = FirebaseService();
  String registrationnumber = ''; // Placeholder for VIN
  List<String> imageUrls = []; // List to hold image URLs
  Map<String, String> vehicleInfo = {}; // Map to hold vehicle information

  Future<void> performSearch() async {
    _logger.i('Search button tapped!');

    try {
      if (registrationnumber.isNotEmpty) {
        // Fetch data using FirebaseService
        final data = await _firebaseService.fetchVehicleData(registrationnumber);

        setState(() {
          imageUrls = List<String>.from(data['images'] ?? []);
          vehicleInfo = {
            'Name': data['name'] ?? 'N/A',
            'VIN': data['vin'] ?? 'N/A',
            'Ghana Card': data['ghanaCard'] ?? 'N/A',
            'Phone Number': data['phonenumber'] ?? 'N/A',
            'Registration Number': data['registrationnumber'] ?? 'N/A',
            'Manufacturer Name': data['manufacturerName'] ?? 'N/A',
            'Vehicle Type': data['vehicleType'] ?? 'N/A',
            'Make': data['make'] ?? 'N/A',
            'Model': data['model'] ?? 'N/A',
            'Doors': data['doors'] ?? 'N/A',
            'Body Class': data['bodyClass'] ?? 'N/A',
            'Model Year': data['modelYear'] ?? 'N/A',
            'Engine Type': data['engineType'] ?? 'N/A',
            'Plant Country': data['plantCountry'] ?? 'N/A',
            'Transmission Style': data['transmissionStyle'] ?? 'N/A',
            'Number of Seat Rows': data['numberOfSeatRows'] ?? 'N/A',
            'Price': data['price'] ?? '0', // Default to '0' if price is missing
          };
        });
      }
    } catch (e) {
      _logger.e('Error fetching data: $e');
      setState(() {
        imageUrls = [];
        vehicleInfo = {
          'Error': 'Error fetching data',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceString = vehicleInfo['Price'] ?? '0';
    final priceValue = double.tryParse(priceString.replaceAll(',', '')) ?? 0.0; // Remove commas for parsing
    const basePremium = 500.0; // Example base premium in GHS
    const coverageFactor = 0.02; // Example coverage factor (2% of vehicle value)
    const riskAdjustment = 0.10; // Example risk adjustment (10% increase)
    
    // Calculate annual premium
    final annualPremium = (basePremium + priceValue * coverageFactor) * (1 + riskAdjustment);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Insurance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    registrationnumber = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter Registration Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: performSearch,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 50),
                  child: const Center(child: Text('Decode Registration Number')),
                ),
              ),
              const SizedBox(height: 20),
              if (imageUrls.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(imageUrls[index]),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: vehicleInfo.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${entry.key}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(entry.value),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPage(//
                        annualPremium: annualPremium, registrationNumber: '',
                      ),
                    ),
                  );
                },
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 50),
                  child: const Center(child: Text('Next')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
