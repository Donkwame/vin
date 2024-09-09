import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin/auth/login.dart';
import 'package:vin/auth/signup.dart';

class SignupLogin extends StatelessWidget {
  const SignupLogin({super.key});

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
                  'assets/image/car2.png',
                  width: double.infinity,
                  fit: BoxFit.cover,

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
          const SizedBox(height: 15),

          Center(
            child: SizedBox(
              width: 325,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  //Navigate to the SecondPage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 234, 240),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // Adjust the radius as needed
                  ),
                ),
                child: Text(
                  'Sign UP',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 20, 19, 21), // Set text color to white
                  ),
                ),
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
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 238, 245),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // Adjust the radius as needed
                  ),
                ),
                child: Text(
                  'Log In',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 20, 19, 21), // Set text color to white
                  ),
                ),
              ),
            ),
          ),
          
          
    
        ],
      ),
      ));
  }
}