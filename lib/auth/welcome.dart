import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin/auth/signup_login.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 36, 41),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 500,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(1),
                  bottomRight: Radius.circular(1),
                ),
                child: Image.asset(
                  'assets/image/car1.png',
                  width: double.infinity,
                  fit: BoxFit.cover,

              ),
            ),
          ),
          const SizedBox(height: 2),
          Center(
            child: Text(
              'Car Checker',
              style: GoogleFonts.montserrat(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Center(
            child: Text(
              'Generating car info made Easier ',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 325,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  //Navigate to the SecondPage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupLogin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 228, 226, 231),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // Adjust the radius as needed
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 12, 11, 13), // Set text color to white
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Welcome on Board!',
              style: GoogleFonts.montserratAlternates(
                fontSize: 25,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: Text(
                'Welcome to the most comprehensive Car Info Generator, where generating inforamtion about any car is made easier',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      ));
  }
}


