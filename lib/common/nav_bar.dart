import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey,
            gap:8,
            //onTabChange: (index) {
             // print(index);
           // } ,
            padding: EdgeInsets.all(16),
            tabs: [
            GButton(icon: Icons.home,
            text: 'Home',),
            GButton(icon: Icons.report,
            text: 'Report',),
            GButton(icon: Icons.shield,
            text: 'Insurance',),
            GButton(icon: Icons.shop,
            text: 'Parts',),
            GButton(icon: Icons.person,
            text: 'User',),
          ],),
        ),
      ),
    );
  } 
}