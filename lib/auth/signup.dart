import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vin/auth/auth.dart';
import 'package:vin/auth/login.dart';
import 'package:vin/common/my_buttom1.dart';
import 'package:vin/common/my_textfield.dart';
import 'package:vin/common/square_title.dart';

class SignUp extends StatelessWidget {
  final Function()? onTap;

  SignUp({super.key, this.onTap});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  Future<void> signUserUp(BuildContext context) async {
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

    String getErrorMessage(dynamic error) {
        if (error is FirebaseAuthException) {
            return error.message ?? 'Unknown error';
        } else {
            return 'An unexpected error occurred';
        }
    }

    try {
        final scaffoldMessenger = scaffoldMessengerKey.currentState;

        if (scaffoldMessenger != null) {
            scaffoldMessenger.showSnackBar(
                const SnackBar(
                    content: Text("Signing up..."),
                ),
            );
        }

        String password = passwordController.text;

        // Validate password length
        if (passwordController.text.length < 6) {
            throw FirebaseAuthException(
                code: 'weak-password',
                message: 'Password should be at least 6 characters',
            );
        }

        // Check for a mix of letters, numbers, and special characters
        RegExp passwordPattern = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[\W_]).{6,}$');

        if (!passwordPattern.hasMatch(password)) {
            throw FirebaseAuthException(
                code: 'weak-password',
                message: 'Password should contain at least one letter, one number, and one special character.',
            );
        }

        // Continue with user registration
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
        );

        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
            // Save user information to Firestore
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'email': emailController.text,
            });

            emailController.clear();
            passwordController.clear();
            firstNameController.clear();
            lastNameController.clear();
            confirmPasswordController.clear();

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', true);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AuthPage(),
                ),
            );
        }
    } catch (error) {
        final currentState = scaffoldMessengerKey.currentState;
        String errorMessage = getErrorMessage(error);

        if (currentState != null) {
            currentState
                .showSnackBar(
                    SnackBar(
                        content: Text('Sign Up failed: $errorMessage'),
                    ),
                )
                .closed
                .then((reason) {
                    currentState.hideCurrentSnackBar();
                });
        }
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 245, 245),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            Container(
              height: 130,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                child: Image.asset(
                  'assets/image/Start3.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // login text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Hello! Register to get started',
                style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 12, 12, 12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // welcome message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Welcome, we are happy to have you join the family',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 12, 12, 12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // user name
            MyTextField(
              controller: firstNameController,
              hintText: 'First Name',
              obscureText: false,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 25),
            MyTextField(
              controller: lastNameController,
              hintText: 'Last Name',
              obscureText: false,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 25),
            // email
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 25),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
              prefixIcon: Icons.lock,
            ),
            const SizedBox(height: 25),
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
              prefixIcon: Icons.lock,
            ),
            const SizedBox(height: 25),
            MyButton1(
              onTap: () => signUserUp(context),
              label: 'Sign Up',
            ),
            const SizedBox(height: 20),
            // or
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(child: Divider(thickness: 1.5)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:Color.fromARGB(255, 20, 19, 21),
                      ),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // google and facebook buttons
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Squaretile(imagepath: 'assets/image/Start4.png'),
                SizedBox(width: 25),
                Squaretile(imagepath: 'assets/image/Start5.png'),
              ],
            ),
            const SizedBox(height: 25),
            // login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You have an account',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Color.fromARGB(255, 62, 7, 150),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}