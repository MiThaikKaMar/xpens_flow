import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  final String img;
  final String title;
  final String description;

  const OnboardingSlide({
    super.key,
    required this.img,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(img, width: 20, height: 30),
        Text(title),
        Text(description),
      ],
    );
  }
}
