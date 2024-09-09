import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InsuranceListView extends StatelessWidget {
  final List<Map<String, String>> items;
  final Function(String route) onItemTap;

  const InsuranceListView({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return InkWell(
            onTap: () => onItemTap(item['route']!),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
    );
  }
}
