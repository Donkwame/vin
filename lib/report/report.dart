import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin/parts/layout_with_nav_bar.dart';  // Import the LayoutWithNavBar widget
import 'package:vin/report/my_textfield1.dart';
import 'package:vin/report/my_textfield2.dart';
import 'package:vin/report/my_textfield3.dart';
import 'package:vin/report/my_textfield4.dart';       // Import your custom text field widgets

class ReportPage extends StatelessWidget {
  // Constructor
  ReportPage({super.key});

  // Define controllers and images here
  final registrationnumberController = TextEditingController();
  final nameController = TextEditingController();
  final vinController = TextEditingController();
  final phonenumberController = TextEditingController();
  final List<File> _images = []; // List of File objects

  @override
  Widget build(BuildContext context) {
    return LayoutWithNavBar(
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report',
            style: GoogleFonts.inter(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 29, 36, 41),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Centered text
                Text(
                  'Report Your Stolen Car',
                  style: GoogleFonts.inter(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Image picker
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _images.isEmpty
                            ? Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                                size: 50,
                              )
                            : Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _images
                                    .map(
                                      (image) => ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                        const SizedBox(height: 10),
                        Text(
                          _images.isEmpty
                              ? 'Tap to pick images'
                              : 'Tap to add more images',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Form Fields
                MyTextField1(
                  controller: registrationnumberController,
                  hintText: 'Registration Number',
                  obscureText: false,
                  prefixIcon: Icons.confirmation_number,
                ),
                const SizedBox(height: 10),

                MyTextField2(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 10),

                MyTextField4(
                  controller: vinController,
                  hintText: 'VIN',
                  obscureText: false,
                  prefixIcon: Icons.car_rental,
                ),
                const SizedBox(height: 10),

                MyTextField3(
                  controller: phonenumberController,
                  hintText: 'Phone number',
                  obscureText: false,
                  prefixIcon: Icons.phone,
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _uploadData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Customize button color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.inter(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      currentIndex: 3,
    );
  }

  void _pickImages() {
    // Your image picking logic here
  }

  void _uploadData() {
    // Your data upload logic here
  }
}
