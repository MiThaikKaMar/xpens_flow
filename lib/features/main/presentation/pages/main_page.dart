// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/core/ui/theme/colors.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';
import 'package:xpens_flow/features/transactions/presentation/sheets/quick_add_sheet.dart';

class MainPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: AppColors.primary.withOpacity(0.2),

            // indicatorShape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(AppSpacing.md),
            // ),
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.selected)) {
                return AppTypography.bodySemiSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                );
              }

              return AppTypography.bodySmall;
            }),

            height: 70.0,
            backgroundColor: Theme.of(
              context,
            ).bottomNavigationBarTheme.backgroundColor,
            iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.selected)) {
                return IconThemeData(color: AppColors.primary);
              }
              return IconThemeData(color: Colors.grey, size: 24.0);
            }),
          ),
        ),

        child: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_outlined),
              selectedIcon: Icon(Icons.account_balance),
              label: 'Accounts',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Txns',
            ),
            NavigationDestination(
              icon: Icon(Icons.pie_chart_outline),
              selectedIcon: Icon(Icons.pie_chart),
              label: 'Budgets',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz),
              selectedIcon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        mini: true,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SizedBox(
                height: double.infinity,
                child: Center(child: QuickAddSheet()),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
