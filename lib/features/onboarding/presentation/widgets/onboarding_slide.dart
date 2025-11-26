import 'package:flutter/material.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';

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
        //Image
        Container(
          width: double.infinity,
          height: AppSpacing.size300,
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppSpacing.lg)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(img, fit: BoxFit.cover),
        ),
        SizedBox(height: AppSpacing.xl),
        //............
        Text(title, style: AppTypography.headlineLarge),

        SizedBox(height: AppSpacing.md),
        //..............
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
