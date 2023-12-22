import 'package:flutter/material.dart';
import 'vin_decoder_widget.dart'; // Replace with the correct import path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vin Decoder'),
        ),
        body: const VinDecoderWidget(),
      ),
    );
  }
}

