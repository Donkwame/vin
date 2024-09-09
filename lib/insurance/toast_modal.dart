import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin/insurance/new.dart';

import 'renew.dart';

void showToastModal(BuildContext context, String route, String listViewSource) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose an Option',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the modal

                    // Handle 'Renew' action
                    if (listViewSource == 'first') {
                      // From the first ListView
                      if (route == 'NonRegistered') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const New(),
                          ),
                        );
                      } else if (route == 'Registered') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Renew(),
                          ),
                        );
                      }
                    } else if (listViewSource == 'second') {
                      // From the second ListView
                      if (route == 'NonRegistered') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const New(),
                          ),
                        );
                      } else if (route == 'Renew') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Renew(),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    'Renew',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the modal

                    // Handle 'New' action
                    if (listViewSource == 'first') {
                      // From the first ListView
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const New(),
                        ),
                      );
                    } else if (listViewSource == 'second') {
                      // From the second ListView
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const New(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    'New',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
