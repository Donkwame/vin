import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vin/parts/firebaseservice1.dart'; // Ensure correct import for FirebaseService1

class NonRegistered extends StatefulWidget {
  const NonRegistered({super.key});

  @override
  _NonRegisteredState createState() => _NonRegisteredState();
}

class _NonRegisteredState extends State<NonRegistered> {
  final Logger _logger = Logger();
  final FirebaseService1 _firebaseService = FirebaseService1(); // Initialize FirebaseService1

  String vin = ''; // VIN input
  List<String> imageUrls = []; // To hold image URLs
  Map<String, String> vehicleInfo = {}; // To hold vehicle information

  Future<void> performSearch() async {
    _logger.i('Search button tapped!');

    try {
      if (vin.isNotEmpty) {
        // Fetch data using FirebaseService1
        final data = await _firebaseService.fetchVehicleData(vin);

        // Log the fetched data
        _logger.i('Fetched data: $data');

        // Check if the car is stolen
        if (data['isStolen'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('This car is reported as stolen! Please contact the nearest police station.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 15),
            ),
          );

          // Clear vehicle info and image URLs
          setState(() {
            imageUrls = [];
            vehicleInfo = {};
          });

          return; // Exit the function
        }

        // If the car is not stolen, display vehicle info
        setState(() {
          imageUrls = List<String>.from(data['images'] ?? []);
          vehicleInfo = {
            'Exporter name': data['exportername'] ?? 'N/A',
            'Importer name': data['inportername'] ?? 'N/A',
            'Importer number': data['inporternumber'] ?? 'N/A',
            'VIN': data['vin'] ?? 'N/A',
            'Plant Country': data['plantCountry']?.trim() ?? 'N/A',
            'Manufacturer Name': data['manufacturerName'] ?? 'N/A',
            'Country of origin': data['countryoforigin'] ?? 'N/A',
            'Make': data['make'] ?? 'N/A',
            'Model': data['model'] ?? 'N/A',
            'Engine Type': data['engineType'] ?? 'N/A',
            'DV Plate Number': data['dvplatenumber'] ?? 'N/A',
            'Model Year': data['modelYear'] ?? 'N/A',
            'Duty': data['duty'] ?? 'N/A',
            'Date': data['date'] ?? 'N/A',
            'Transmission Style': data['transmissionStyle'] ?? 'N/A',
            'Number of Seat Rows': data['numberofSeatRows'] ?? 'N/A',
            'Delivery Place': data['deliveryplace'] ?? 'N/A',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Non-Registered Cars'), // Title
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
                    vin = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter VIN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: performSearch,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 50),
                  child: const Center(child: Text('Decode VIN')),
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
                      final url = imageUrls[index];
                      _logger.i('Loading image from URL: $url'); // Debug log
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          url,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            _logger.e('Error loading image: $error'); // Debug log
                            return const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            );
                          },
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
