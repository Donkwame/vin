import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class SlideShow extends StatelessWidget {
  const SlideShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Adjust padding as needed
      child: Center(
        child: Container(
          width: 2000, // Use full width
          height: 400.0, // Set a fixed height
          padding: const EdgeInsets.all(10.0), // Padding inside the container
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2.0), // Border color and width
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Match the border radius
            child: ImageSlideshow(
              indicatorColor: Colors.blue,
              onPageChanged: (value) {
                debugPrint('Page changed: $value');
              },
              autoPlayInterval: 3000,
              isLoop: true,
              children: [
                Image.asset(
                  'assets/image/b.jpg',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
                Image.asset(
                  'assets/image/c.png',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
                Image.asset(
                  'assets/image/d.png',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
                Image.asset(
                  'assets/image/e.png',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
                Image.asset(
                  'assets/image/f.png',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
                Image.asset(
                  'assets/image/g.png',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
                Image.asset(
                  'assets/image/h.png',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
                Image.asset(
                  'assets/image/i.png',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
                Image.asset(
                  'assets/image/j.png',
                  fit: BoxFit.cover, // Scale to cover the entire container
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
