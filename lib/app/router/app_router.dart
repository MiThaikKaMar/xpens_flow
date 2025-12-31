import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/di/init_dependencies.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/data/datasources/hive_category_service.dart';
import 'package:xpens_flow/core/data/datasources/shared_preferences_helper.dart';
import 'package:xpens_flow/features/accounts/presentation/pages/accounts_page.dart';
import 'package:xpens_flow/features/budgets/presentation/pages/budgets_overview_page.dart';
import 'package:xpens_flow/features/home/presentation/pages/home_page.dart';
import 'package:xpens_flow/features/main/presentation/pages/main_page.dart';
import 'package:xpens_flow/features/onboarding/presentation/cubit/category_cubit.dart';
import 'package:xpens_flow/features/onboarding/presentation/pages/carousel_page.dart';
import 'package:xpens_flow/features/onboarding/presentation/pages/categories_suggest_page.dart';
import 'package:xpens_flow/features/onboarding/presentation/pages/first_run_setup_page.dart';
import 'package:xpens_flow/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:xpens_flow/features/settings/presentation/pages/more_page.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction_split.dart';
import 'package:xpens_flow/features/transactions/presentation/pages/transaction_detail_page.dart';
import 'package:xpens_flow/features/transactions/presentation/pages/transaction_editor_page.dart';
import 'package:xpens_flow/features/transactions/presentation/pages/transaction_split_page.dart';
import 'package:xpens_flow/features/transactions/presentation/pages/transactions_feed_page.dart';
import 'package:xpens_flow/features/transactions/presentation/state/editor/transaction_editor_bloc.dart';

import '../../core/common/utils/app_strings.dart';
import '../../features/transactions/presentation/state/feed/transaction_feed_bloc.dart';

final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _accountsNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _transactionsNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _budgetsNavigatorKey =
    GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _moreNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: Routes.welcome,
    //initialLocation: '/test/split',
    redirect: (BuildContext context, GoRouterState state) {
      // Check SharedPreferences directly
      final prefsHelper = serviceLocator<SharedPreferencesHelper>();

      // Check if currency and categories are set
      // Adjust these methods based on your SharedPreferencesHelper implementation
      final hasCurrency =
          prefsHelper.getString(AppStrings.sfCurrentCurrency) != null;

      final hiveService = serviceLocator<HiveCategoryService>();
      final hasCategories = hiveService.getAllCategories().isNotEmpty;

      final isOnWelcome = state.matchedLocation == Routes.welcome;
      final isOnOnboarding = state.matchedLocation.startsWith('/onboarding');
      final hasValidSettings = hasCurrency && hasCategories;

      // If has valid settings and on welcome/onboarding, redirect to home
      if (hasValidSettings && (isOnWelcome || isOnOnboarding)) {
        return Routes.home;
      }

      // If no valid settings and trying to access main app, redirect to welcome
      if (!hasValidSettings && !isOnWelcome && !isOnOnboarding) {
        return Routes.welcome;
      }

      return null; // No redirect
    },
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
      GoRoute(
        path: Routes
            .transactionDetail, // relative to /transactions => /transactions/:id
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id']!;
          final extras = state.extra as Map<String, dynamic>;
          final transaction = extras['transaction'] as Transaction;
          final currencySymbol = extras['symbol'] as String;
          return TransactionDetailPage(
            transactionId: int.parse(id),
            transaction: transaction,
            currencySymbol: currencySymbol,
          );
        },
      ),
      GoRoute(
        path: Routes.transactionEdit,
        builder: (context, state) {
          final idString = state.pathParameters['id']!;
          final transactionId = int.parse(idString);
          final extras = state.extra as Map<String, dynamic>;
          final transaction = extras['transaction'] as Transaction;
          final currencySymbol = extras['symbol'] as String;
          return TransactionEditorPage(
            transactionId: transactionId,
            transaction: transaction,
            currencySymbol: currencySymbol,
            transactionEditorBloc: serviceLocator<TransactionEditorBloc>(),
          );
        },
      ),
      GoRoute(
        path: Routes.transactionSplit,
        builder: (context, state) {
          final idString = state.pathParameters['id']!;
          final transactionId = int.parse(idString);
          final extras = state.extra as Map<String, dynamic>;
          final transaction = extras['transaction'] as Transaction;
          final currencySymbol = extras['symbol'] as String;

          //Use List.from to prevent cast errors if it comes back as List<dynamci>
          final rawSplits = extras['existingSplits'];
          final existingSplits = rawSplits != null
              ? List<TransactionSplit>.from(rawSplits)
              : <TransactionSplit>[];
          return TransactionSplitPage(
            transactionId: transactionId,
            transaction: transaction,
            currencySymbol: currencySymbol,
            existingSplits: existingSplits,
          );
        },
      ),

      // For Ui wareframe preparing
      // GoRoute(
      //   path: '/test/split',
      //   builder: (context, state) {
      //     final dummyTransaction = Transaction(
      //       id: 123,
      //       amount: 5400.0,
      //       date_time: DateTime.now(),
      //       category: "Housing",
      //       type: TransactionType.expense,
      //       description: 'Test Split Transaction',
      //       // add other required fields
      //     );
      //     return TransactionSplitPage(
      //       transactionId: dummyTransaction.id!,
      //       transaction: dummyTransaction,
      //       currencySymbol: '\$',
      //     );
      //   },
      // ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainPage(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountsNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.accounts,
                builder: (context, state) => const AccountsPage(),
              ),
              // GoRoute(
              //   path: Routes.subpage,
              //   builder: (context, state) => const SubPage(),
              // ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _transactionsNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.transactions,
                builder: (context, state) => TransactionsFeedPage(
                  transactionFeedBloc: serviceLocator<TransactionFeedBloc>(),
                ),
                // routes: [
                //   GoRoute(
                //     //name: Routes.transactionDetail,
                //     path:
                //         ":id", // relative to /transactions => /transactions/:id
                //     builder: (BuildContext context, GoRouterState state) {
                //       final id = state.pathParameters['id']!;
                //       return TransactionDetailPage(
                //         transactionId: int.parse(id),
                //       );
                //     },
                //   ),
                // ],
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _budgetsNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.budgets,
                builder: (context, state) => const BudgetsOverviewPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _moreNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.more,
                builder: (context, state) => const MorePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
