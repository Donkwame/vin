import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin/common/slide_show.dart';
//import 'package:vin/parts/nav_bar.dart';   Registered
import 'package:vin/parts/non_registered.dart';
import 'package:vin/parts/registered.dart';

import 'layout_with_nav_bar.dart';

class Dash extends StatelessWidget {
  const Dash({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'image': 'assets/image/r.jpg',
        'title': 'Registered',
        'route': 'Registered',
      },
      {
        'image': 'assets/image/car.jpg',
        'title': 'New Cars',
        'route': 'NonRegistered',
      },
    ];

    return LayoutWithNavBar(
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            'Car Checker',
            style: GoogleFonts.inter(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 80.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.camera,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
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
            SizedBox(
              height: 300.0, // Height for ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () {
                      if (item['route'] == 'NonRegistered') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NonRegistered()),
                        );
                      } else if (item['route'] == 'Registered') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Registered()),
                        );
                      }
                    },
                    child: Container(
                      width: 200.0,
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Image.asset(
                                item['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.car_crash,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      item['title']!,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0), // Space between ListView and SlideShow
            Container(
              height: 300.0, // Fixed height for SlideShow
              padding: const EdgeInsets.all(10.0), // Optional padding
              child: const SlideShow(),
            ),
          ],
        ),
      ),
      currentIndex: 0, // Home tab selected
    );
  }
}
