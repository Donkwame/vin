import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vin/auth/auth.dart';
import 'package:vin/auth/signup.dart';
import 'package:vin/common/my%20buttom.dart';
import 'package:vin/common/my_textfield.dart';
import 'package:vin/common/square_title.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check login status when the widget initializes
  }
  
Future<void> logUserIn() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

    // Check if email and password are not empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      // Display a Snackbar to inform the user
      _showSnackBar('Please enter your email and password');
      return; // Exit the function without attempting to log in
    }

    // Perform sign in
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    // Clear text controllers after successful login
    emailController.clear();
    passwordController.clear();

    // Save login status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);

      // Pop the loading indicator
      Navigator.pop(context);

      // Navigate to the next page (Replace with your actual next page)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    } catch (error) {
      // Handle login errors, e.g., show a SnackBar
      _showSnackBar('Login failed: ${error.toString()}');

      // Pop the loading indicator
      Navigator.pop(context);
    }
  }

  // Function to show a SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
                  'assets/image/Start3.png', // Replace with the actual image path
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // login text
            Padding(
              padding: const EdgeInsets.symmetric( horizontal: 15.0),
              child: Text(
                'Welcome back! Glad to see you, Again    ',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 12, 12, 12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // welcome message
             Padding(
              padding: const EdgeInsets.symmetric( horizontal: 15.0),
              child: Text(
                'Sign into your car checker account   ',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 12, 12, 12),
                ),
              ),
            ),
            const SizedBox(height: 36),
            // username
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 25),
            // Password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
              prefixIcon: Icons.lock,
            ),
            const SizedBox(height: 10),
            // forgot password
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color.fromARGB(255, 62, 7, 150)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // login button
            MyButton(
              onTap: () async {
              logUserIn();
              }, text: '',
            ),
            const SizedBox(height: 20),
            // or
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
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
                  Expanded(
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // google button
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Squaretile(
                  imagepath: 'assets/image/Start4.png',
                ), // Fixed image path
                SizedBox(
                  width: 25,
                ),
                // facebook button
                Squaretile(imagepath: 'assets/image/Start5.png'), // Fixed image path
              ],
            ),
            const SizedBox(height: 25),
            // not a user
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  width: 4,
                ),
              GestureDetector(
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                  );
                  },
                    child: const Text(
                    'Register',
                    style: TextStyle(
                      color:Color.fromARGB(255, 20, 19, 21),
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
