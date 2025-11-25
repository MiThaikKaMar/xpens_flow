// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/app_strings.dart';
import 'package:xpens_flow/core/ui/theme/colors.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';

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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: AppSpacing.size80),
                      // Main Icon
                      Image.asset(
                        "assets/icons/icon.png",
                        width: AppSpacing.size150,
                      ),

                      SizedBox(height: AppSpacing.md),
                      // Main Title
                      Text(
                        AppStrings.appName,
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: AppSpacing.md),
                      // Description
                      Text(
                        AppStrings.welcomeDescription,
                        style: AppTypography.bodyLarge,
                      ),
                      SizedBox(height: AppSpacing.size100),
                      // Encryped notice
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackgroundDark.withOpacity(
                            0.2,
                          ),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        padding: EdgeInsets.all(AppSpacing.md),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.security,
                              color: AppColors.primary,
                              size: AppSpacing.md,
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              AppStrings.encryptNotice,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      // Get Started Button
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            context.go(Routes.onboardingCarousel);
                          },
                          child: Text(
                            AppStrings.getStarted,
                            style: AppTypography.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Privacy & Terms
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      'Privacy',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xxl),
                    Text(
                      'Terms',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
