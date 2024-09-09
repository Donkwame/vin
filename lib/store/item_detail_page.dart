import 'package:flutter/material.dart';

class ItemDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name'] ?? 'Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item['images'] != null && item['images'].isNotEmpty
                ? Image.network(
                    item['images'].first,
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  )
                : const Icon(Icons.image_not_supported, size: 200.0),
            const SizedBox(height: 16.0),
            Text('Name: ${item['name'] ?? 'N/A'}', style: const TextStyle(fontSize: 20)),
            Text('Brand: ${item['brand'] ?? 'N/A'}'),
            Text('Condition: ${item['condition'] ?? 'N/A'}'),
            Text('Part Number: ${item['partnumber'] ?? 'N/A'}'),
            Text('Price: GHS ${item['price']?.toString() ?? 'N/A'}'),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Buying ${item['name']}')),
                    );
                  },
                  child: const Text('Buy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
