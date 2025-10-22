import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/di/init_dependencies.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/helpers/shared_preferences_helper.dart';
import 'package:xpens_flow/features/home/presentation/pages/home_page.dart';
import 'package:xpens_flow/features/onboarding/presentation/cubit/category_cubit.dart';
import 'package:xpens_flow/features/onboarding/presentation/pages/carousel_page.dart';
import 'package:xpens_flow/features/onboarding/presentation/pages/categories_suggest_page.dart';
import 'package:xpens_flow/features/onboarding/presentation/pages/first_run_setup_page.dart';
import 'package:xpens_flow/features/onboarding/presentation/pages/welcome_page.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: Routes.welcome,
    routes: [
      GoRoute(path: Routes.welcome, builder: (context, state) => WelcomePage()),
      GoRoute(
        path: Routes.onboardingCarousel,
        builder: (context, state) => CarouselPage(),
      ),
      GoRoute(
        path: Routes.onboardingSetup,
        builder: (context, state) => FirstRunSetupPage(
          prefsHelper: serviceLocator<SharedPreferencesHelper>(),
        ),
      ),
      GoRoute(
        path: Routes.onboardingCatSuggest,
        builder: (context, state) => CategoriesSuggestPage(
          categoryCubit: serviceLocator<CategoryCubit>(),
        ),
      ),
      GoRoute(path: Routes.home, builder: (context, state) => HomePage()),
    ],
  );
}
