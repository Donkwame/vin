import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vin/parts/layout_with_nav_bar.dart';
import 'package:vin/store/item_detail_page.dart';
import 'package:vin/store/store_service.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final TextEditingController _searchController = TextEditingController();
  final StoreService _storeService = StoreService();
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchAllItems();
  }

  void _fetchAllItems() async {
    try {
      List<DocumentSnapshot> items = await _storeService.fetchAllItems();
      setState(() {
        _searchResults = items;
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  void _performSearch() async {
    String searchText = _searchController.text.trim();

    if (searchText.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });

      try {
        List<DocumentSnapshot> items = await _storeService.searchItems(searchText);
        setState(() {
          _searchResults = items;
        });
      } catch (e) {
        print('Error performing search: $e');
      } finally {
        setState(() {
          _isSearching = false;
        });
      }
    } else {
      _fetchAllItems(); // Fetch all items if search text is empty
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithNavBar(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Store Page'),
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _performSearch,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty
                  ? const Center(child: Text('No results found'))
                  : SizedBox(
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          var item = _searchResults[index].data() as Map<String, dynamic>;

                          return ListTile(
                            leading: _buildImage(item['images']?.first),
                            title: Text(item['name'] ?? 'No Name'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Condition: ${item['condition'] ?? 'Unknown'}'),
                                Text('Brand: ${item['brand'] ?? 'Unknown'}'),
                                Text('Part Number: ${item['partnumber'] ?? 'N/A'}'),
                                Text('Price: GHS:${item['price']?.toString() ?? 'N/A'}'),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailPage(item: item),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
        ),
      ),
      currentIndex: 2,
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.image_not_supported);
    } else {
      return Image.network(
        imageUrl,
        width: 80.0,
        height: 80.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return const Icon(Icons.broken_image);
        },
      );
    }
  }
}
