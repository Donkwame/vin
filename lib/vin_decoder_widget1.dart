import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class VinDecoderWidget1 extends StatefulWidget {
  const VinDecoderWidget1({super.key});

  @override
  VinDecoderWidget1State createState() => VinDecoderWidget1State();
}

class VinDecoderWidget1State extends State<VinDecoderWidget1> {
  String vin = '';
  String decodingResult = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              onPressed: () {
                validateAndDecodeVin(context);
              },
              child: Container(
                // Wrap with Container to set max height
                constraints: const BoxConstraints(
                    maxHeight: 50), // Set the maximum height
                child: const Center(child: Text('Decode VIN')),
              ),
            ),
            const SizedBox(height: 20),
            Text(decodingResult),
          ],
        ),
      ),
    );
  }

  void validateAndDecodeVin(BuildContext context) async {
    if (vin.length != 17) {
      showValidationMessage(context, 'The VIN number is not 17 characters.');
      return;
    }

    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(vin)) {
      showValidationMessage(context,
          'Invalid VIN number. Must be a mixture of uppercase letters and numbers.');
      return;
    }

    await decodeVin();
  }

  void showValidationMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('VIN Validation'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> decodeVin() async {
    try {
      final decoder = VinDecoder();
      var decodedData = await decoder.decodeVehicleDetails(vin);

      setState(() {
        decodingResult = 'Decoding Result:\n$decodedData';
      });
    } catch (e) {
      setState(() {
        decodingResult = 'Error decoding VIN: $e';
        logger.e('Error decoding VIN: $e');
      });
    }
  }
}

final logger = Logger();

class VinDecoder { 
  String country = '';
  String make = '';
  String continent = '';
  String modelYear = '';
  String engineSize = '';
  String model = '';
  String name = '';
  String engineType = '';
  String manufacturername = '';
  String enginenumberofcylinders = '';
  String drivetype = '';
  String transmissionstyle = '';
  String numberofseatrows = '';
  String modelyear = '';
  String doors = '';
  String plantcountry = '';
  String vehicletype = '';
  String bodyclass = '';

  // ... Rest of the code remains the same

  Future<void> decodeVin(String vin) async {
    if (vin.length != 17) {
      throw ArgumentError("Invalid VIN code");
    }

    await decodeVehicleDetails(vin);
    decodeCountry(vin[0]);
    decodeContinent(vin[3]);
    decodeModelYear(vin[9]);
    decodeEngineSize(vin[10]);
  }

  Future<void> decodeCountry(String v) async {
    var vmiDetails = {
      '1': 'North America',
      '4': 'North America',
      '5': 'North America',
      '2': 'South America',
      '3': 'Asia',
      '6': 'Oceania',
      '9': 'Africa',
      'J': 'Asia',
      'K': 'Asia',
      'L': 'Asia',
      'M': 'Asia',
      'N': 'Asia',
      'P': 'Asia',
      'R': 'Asia',
      'S': 'Europe',
      'T': 'Europe',
      'U': 'Europe',
      'V': 'Europe',
      'W': 'Europe',
      'X': 'Europe',
      'Y': 'Europe',
      'Z': 'Europe',
    };

    if (vmiDetails.containsKey(v)) {
      country = vmiDetails[v]!;
      make = vmiDetails[v]!;
    } else {
      throw ArgumentError("Invalid VMI code");
    }
  }

  void decodeContinent(String c) {
    switch (c) {
      case '1':
      case '4':
      case '5':
        continent = 'North America';
        break;
      case '2':
        continent = 'South America';
        break;
      case '3':
        continent = 'Asia';
        break;
      case '6':
        continent = 'Oceania';
        break;
      case '9':
        continent = 'Africa';
        break;
      case 'J':
      case 'K':
      case 'L':
      case 'M':
      case 'N':
      case 'P':
      case 'R':
        continent = 'Asia';
        break;
      case 'S':
      case 'T':
      case 'U':
      case 'V':
      case 'W':
      case 'X':
      case 'Y':
      case 'Z':
        continent = 'Europe';
        break;
      default:
        throw ArgumentError("Invalid continent code");
    }
  }

  void decodeModelYear(String c) {
    var modelYearMap = {
      '0': "2000",
      '1': "2001",
      '2': "2002",
      '3': "2003",
      '4': "2004",
      '5': "2005",
      '6': "2006",
      '7': "2007",
      '8': "2008",
      '9': "2009",
      'A': "2010",
      'B': "2011",
      'C': "2012",
      'D': "2013",
      'E': "2014",
      'F': "2015",
      'G': "2016",
      'H': "2017",
      'J': "2018",
      'K': "2019",
      'L': "2020",
      'M': "2021",
      'N': "2022",
      'P': "2023",
      'R': "2024",
      'S': "2025",
      'T': "2026",
      'V': "2027",
      'W': "2028",
      'X': "2029",
      'Y': "2030",
    };

    if (modelYearMap.containsKey(c)) {
      modelyear = modelYearMap[c]!;
    } else {
      throw ArgumentError("Invalid model year code");
    }
  }

  void decodeEngineSize(String c) {
    var engineSizeMap = {
      'A': "Gasoline, 3 or 4 cylinders",
      'B': "Gasoline, 3 or 4 cylinders",
      'C': "Gasoline, 4 or 6 cylinders",
      'D': "Gasoline, 4 or 6 cylinders",
      'E': "Gasoline, 4 or 6 cylinders",
      'F': "Gasoline, 4 or 6 cylinders",
      'G': "Gasoline, 6 or 8 cylinders",
      'H': "Gasoline, 6 or 8 cylinders",
      'J': "Gasoline, 6 or 8 cylinders",
      'K': "Gasoline, 6 or 8 cylinders",
      'L': "Gasoline, 6 or 8 cylinders",
      'M': "Gasoline, 8 cylinders",
      'N': "Gasoline, 8 cylinders",
      'P': "Gasoline, 8 cylinders",
      'R': "Gasoline, 8 cylinders",
      'S': "Diesel, 4 or 6 cylinders",
      'T': "Diesel, 4 or 6 cylinders",
      'U': "Diesel, 4 or 6 cylinders",
      'V': "Diesel, 4 or 6 cylinders",
      'W': "Diesel, 4 or 6 cylinders",
      'X': "Diesel, 6 or 8 cylinders",
      'Y': "Diesel, 6 or 8 cylinders",
      'Z': "Diesel, 6 or 8 cylinders",
      '1': "Electric",
      '2': "Hybrid",
      '3': "Hybrid",
      '4': "Hybrid",
      '5': "Hybrid",
      '6': "Hybrid",
      '7': "Hybrid",
      '8': "Hybrid",
      '9': "Hybrid",
    };

    if (engineSizeMap.containsKey(c)) {
      enginenumberofcylinders = engineSizeMap[c]!;
    } else {
      throw ArgumentError("Invalid engine size code");
    }
  }

  Future<String> decodeVehicleDetails(String vin) async {
    var url = "https://vpic.nhtsa.dot.gov/api/vehicles/decodevin";
    try {
      var response = await http.get(Uri.parse('$url/$vin?format=json'));

      logger.d('API Response: ${response.body}');

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json.containsKey('Results')) {
          var results = json['Results'];

          if (results is List && results.isNotEmpty) {
            for (var result in results) {
              var name = result['Variable'];
              var value = result['Value'];

              logger.d('Name: $name, Value: $value');

              switch (name) {
                case "Make":
                  make = value ?? '';
                  break;
                case "Model":
                  model = value ?? '';
                  break;
                case "Model Year":
                  modelyear = value ?? '';
                  break;
                case "Engine Model":
                  engineType = value ?? '';
                  break;
                case "Drive Type":
                  drivetype = value ?? '';
                  break;
                case "Manufacturer Name":
                  manufacturername = value ?? '';
                  break;
                case "Engine Number of Cylinders":
                  enginenumberofcylinders = value ?? '';
                  break;
                case "Transmission Style":
                  transmissionstyle = value ?? '';
                  break;
                case "Number of Seat Rows":
                  numberofseatrows = value ?? '';
                  break;
                case "Doors":
                  doors = value ?? '';
                  break;
                case "Plant Country":
                  plantcountry = value ?? '';
                  break;
                case "Vehicle Type":
                  vehicletype = value ?? '';
                  break;
                case "Body Class":
                  bodyclass = value ?? '';
                  break;
                case "Error Code":
                  if (value != "0") {
                    return 'Error decoding VIN: Error Code $value';
                  }
                  break;

                default:
                  break;
              }
            }

            return '''
Make: $make
Model: $model
Doors: $doors
Body Class: $bodyclass
Vehicle Type: $vehicletype
Model Year: $modelyear
Engine Type: $engineType
Drive Type: $drivetype
Engine Number of Cylinders : $enginenumberofcylinders
Plant Country: $plantcountry
Manufacturer Name: $manufacturername
Transmission Style: $transmissionstyle
Number of Seat Rows: $numberofseatrows

''';
          } else {
            logger.e(
                "VIN decoder service error: No results or empty results list");
            throw Exception(
                "VIN decoder service error: No results or empty results list");
          }
        } else {
          logger.e(
              "VIN decoder service error: 'Results' key not found in response");
          throw Exception(
              "VIN decoder service error: 'Results' key not found in response");
        }
      } else {
        logger.e(
            "Failed to fetch data from VIN decoder API. Status code: ${response.statusCode}");
        throw Exception(
            "Failed to fetch data from VIN decoder API. Status code: ${response.statusCode}");
      }
    } on FormatException catch (e) {
      logger.e("Error parsing data from VIN decoder API response: $e");
      throw Exception("Error parsing data from VIN decoder API response: $e");
    } on http.ClientException catch (e) {
      logger.e("HTTP error: $e");
      throw Exception("HTTP error: $e");
    } on Exception catch (e) {
      logger.e("Unknown error during VIN decoding: $e");
      throw Exception("Unknown error during VIN decoding: $e");
    }
  }
}
