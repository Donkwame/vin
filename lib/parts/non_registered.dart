import 'package:flutter/material.dart';
import 'package:vin/vin_decoder_widget1.dart';

class NonRegistered extends StatelessWidget {
  const NonRegistered({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Car'),
      ),
      body: const VinDecoderWidget1(), // Assuming this widget is defined in side.dart
    );
  }
}
