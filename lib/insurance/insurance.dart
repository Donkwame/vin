import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../parts/layout_with_nav_bar.dart';
import 'insurance_list_view.dart';
import 'toast_modal.dart';

class Insurance extends StatelessWidget {
  const Insurance({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'image': 'assets/image/a.jpeg',
        'title': 'Enterprise',
        'route': 'Registered',
      },
      {
        'image': 'assets/image/z.jpg',
        'title': 'DoneWell',
        'route': 'NonRegistered',
      },
    ];

    final List<Map<String, String>> newItems = [
      {
        'image': 'assets/image/50.jpg',
        'title': 'Sunu Assurance',
        'route': 'Registered',
      },
      {
        'image': 'assets/image/44.jpg',
        'title': 'Hollard',
        'route': 'NonRegistered',
      },
    ];

    return LayoutWithNavBar(
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            'Buy Insurance',
            style: GoogleFonts.inter(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 80.0,
          backgroundColor: const Color.fromARGB(255, 29, 36, 41),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 245, 245),
        body: Column(
          children: [
            InsuranceListView(
              items: items,
              onItemTap: (route) => showToastModal(context, route, 'first'),
            ),
            const SizedBox(height: 20.0),
            InsuranceListView(
              items: newItems,
              onItemTap: (route) => showToastModal(context, route, 'second'),
            ),
          ],
        ),
      ),
      currentIndex: 1, // Insurance tab selected
    );
  }
}
