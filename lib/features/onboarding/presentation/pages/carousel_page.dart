import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/app_strings.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';
import 'package:xpens_flow/features/onboarding/presentation/widgets/onboarding_slide.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  late PageController _pageViewController;
  final List<OnboardingSlide> pages = [
    OnboardingSlide(
      img: AppStrings.onBoardSlide1Img,
      title: AppStrings.onBoardSlide1Title,
      description: AppStrings.onBoardSlide1Des,
    ),
    OnboardingSlide(
      img: AppStrings.onBoardSlide2Img,
      title: AppStrings.onBoardSlide2Title,
      description: AppStrings.onBoardSlide2Des,
    ),
    OnboardingSlide(
      img: AppStrings.onBoardSlide3Img,
      title: AppStrings.onBoardSlide3Title,
      description: AppStrings.onBoardSlide3Des,
    ),
    OnboardingSlide(
      img: AppStrings.onBoardSlide4Img,
      title: AppStrings.onBoardSlide4Title,
      description: AppStrings.onBoardSlide4Des,
    ),
  ];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void navigateToFirstRunSetup() {
    context.push(Routes.onboardingSetup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Skip button
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    navigateToFirstRunSetup();
                  },
                  child: Text(
                    AppStrings.bSkip,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              // Body content
              Expanded(
                child: PageView.builder(
                  controller: _pageViewController,
                  itemCount: pages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                  onPageChanged: (value) => {
                    setState(() {
                      _currentPage = value;
                    }),
                  },
                ),
              ),

              // ................
              SmoothPageIndicator(
                controller: _pageViewController,
                count: 4,
                effect: ExpandingDotsEffect(
                  dotHeight: AppSpacing.sm,
                  dotWidth: AppSpacing.sm,
                ),
                onDotClicked: (index) => _pageViewController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.linear,
                ),
              ),

              SizedBox(height: AppSpacing.xxl),
              // ...................
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: AppSpacing.lg),
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage != 3) {
                      setState(() {
                        _pageViewController.animateToPage(
                          _currentPage += 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear,
                        );
                      });
                    } else {
                      navigateToFirstRunSetup();
                    }
                  },
                  child: Text(
                    _currentPage == 3 ? AppStrings.bContinue : AppStrings.bNext,

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
    );
  }
}
