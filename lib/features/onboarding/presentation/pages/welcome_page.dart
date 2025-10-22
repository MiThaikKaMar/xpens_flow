import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/app_strings.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.monetization_on),
                  Text(AppStrings.appName),
                  Text(AppStrings.welcomeDescription),
                  Row(
                    children: [
                      Icon(Icons.security),
                      Text(AppStrings.encryptNotice),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go(Routes.onboardingCarousel);
                    },
                    child: Text(AppStrings.getStarted),
                  ),
                ],
              ),
            ),
            Row(children: [Text('Privacy'), Text('Terms')]),
          ],
        ),
      ),
    );
  }
}
