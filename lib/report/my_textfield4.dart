import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField4 extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;

  const MyTextField4({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
  });

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField4> {
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: widget.controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true, // Enable filled property
          fillColor: Colors.grey[200], // Set the background color
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 24.0,
            color: Colors.black,
          ),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  child: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only uppercase letters and digits
          LengthLimitingTextInputFormatter(17), // Limit to 17 characters
        ],
      ),
    );
  }
}
