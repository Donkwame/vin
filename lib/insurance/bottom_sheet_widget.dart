import 'package:flutter/material.dart';


class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Set the height of the bottom sheet
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Renew'),
            onTap: () {
              // Handle the "Renew" action
              Navigator.pop(context); // Close the bottom sheet
              // Implement the logic for renewing here
              print('Renew option selected');
            },
          ),
          ListTile(
            title: const Text('New'),
            onTap: () {
              // Handle the "New" action
              Navigator.pop(context); // Close the bottom sheet
              // Implement the logic for creating new content here
              print('New option selected');
            },
          ),
        ],
      ),
    );
  }
}