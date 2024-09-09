import 'package:flutter/material.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import '../insurance/insurance.dart';
import '../report/report.dart';
import '../store/store.dart';
import 'dash.dart';


class Nav_Bar extends StatefulWidget {
  final int selectedIndex; // Add this

  const Nav_Bar({super.key, required this.selectedIndex});

  @override
  _Nav_BarState createState() => _Nav_BarState();
}

class _Nav_BarState extends State<Nav_Bar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex; // Initialize with passed index
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: WaterDropNavBar(
        backgroundColor: Colors.white,
        onItemSelected: (int index) {
          if (index != selectedIndex) {
            _navigateToPage(index, context);
          }
        },
        selectedIndex: selectedIndex,
        barItems:  <BarItem>[
          BarItem(
            filledIcon: Icons.home_rounded,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.security_rounded,
            outlinedIcon: Icons.security_outlined,
          ),
          BarItem(
            filledIcon: Icons.shopping_cart_rounded,
            outlinedIcon: Icons.shopping_cart_outlined,
          ),
          BarItem(
            filledIcon: Icons.report_rounded,
            outlinedIcon: Icons.report_outlined,
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dash()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Insurance()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Store()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  ReportPage()),
        );
        break;
    }
  }
}
