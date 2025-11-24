// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/app_strings.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Color similar to the lighter, golden-brown at the top of the screenshot
                Color(
                  0xFF7D6A3A,
                ).withOpacity(0.3), // A warm, slightly transparent golden-brown
                // A deeper, darker brown-grey for the bottom, matching the screenshot
                Color(
                  0xFF1E1E1E,
                ), // This dark grey is still a good base, but we can also try
                // Color(0xFF3A2E1C), // A darker, more earthy brown
              ],
              stops: [0.0, 1.0], // Full spread for these two colors
            ),
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppSpacing.size80),
                    // Main Icon
                    Image.asset(
                      "assets/icons/icon.png",
                      width: AppSpacing.size150,
                    ),

                    // Main Title
                    Text(AppStrings.appName),

                    // Description
                    Text(AppStrings.welcomeDescription),

                    // Encryped notice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.security),
                        Text(AppStrings.encryptNotice),
                      ],
                    ),

                    // Get Started Button
                    ElevatedButton(
                      onPressed: () {
                        context.go(Routes.onboardingCarousel);
                      },
                      child: Text(AppStrings.getStarted),
                    ),
                  ],
                ),
              ),

              // Privacy & Terms
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Privacy'), Text('Terms')],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
