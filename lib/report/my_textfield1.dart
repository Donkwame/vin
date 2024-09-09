import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField1 extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;

  const MyTextField1({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
  });

  @override
  MyTextField1State createState() => MyTextField1State();
}

class MyTextField1State extends State<MyTextField1> {
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
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9-]')),
          LengthLimitingTextInputFormatter(12),
        ],
        onChanged: (value) {
          final regex = RegExp(r'^[A-Z]{2}-\d{1,4}-[A-Z0-9]{0,2}$');
          if (!regex.hasMatch(value)) {
            // You can show an error message here if needed
          }
        },
      ),
    );
  }
}
