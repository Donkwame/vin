import 'package:flutter/material.dart';

import 'nav_bar.dart';

class LayoutWithNavBar extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const LayoutWithNavBar({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: Nav_Bar(selectedIndex: currentIndex),
    );
  }
}
