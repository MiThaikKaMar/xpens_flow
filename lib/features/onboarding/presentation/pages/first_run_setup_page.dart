// ignore_for_file: deprecated_member_use

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/app_strings.dart';
import 'package:xpens_flow/core/common/init_variables.dart';
import 'package:xpens_flow/core/data/datasources/haptic_feedback_helper.dart';
import 'package:xpens_flow/core/data/datasources/shared_preferences_helper.dart';
import 'package:xpens_flow/core/ui/theme/app_theme.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';
import 'package:xpens_flow/features/onboarding/presentation/widgets/theme_list_item.dart';

class FirstRunSetupPage extends StatefulWidget {
  final SharedPreferencesHelper prefsHelper;

  const FirstRunSetupPage({super.key, required this.prefsHelper});

  @override
  State<FirstRunSetupPage> createState() => _FirstRunSetupPageState();
}

class _FirstRunSetupPageState extends State<FirstRunSetupPage> {
  late bool _isSwitchOn;
  Currency _selectedCurrency = InitVariables.initCurrency;
  TimezoneInfo? _currentTimeZone;
  String? _gmtOffsetFormatted;
  List<Map<String, dynamic>> themes = [
    {"label": "Light", "color": Colors.white},
    {"label": "Dark", "color": Colors.black26},
    {"label": "System", "color": Colors.grey},
  ];
  Map<String, dynamic>? _selectedTheme;
  bool _canVibrate = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _currentTimeZone = await FlutterTimezone.getLocalTimezone();

    final DateTime now = DateTime.now();
    final Duration offset = now.timeZoneOffset;

    _gmtOffsetFormatted =
        "GMT${offset.isNegative ? '' : '+'}"
        "${offset.inHours.toString().padLeft(2, '0')}:"
        "${(offset.inMinutes % 60).toString().padLeft(2, '0')}";

    _selectedTheme = themes[2];

    if (await Vibration.hasVibrator()) {
      _canVibrate = true;
      _isSwitchOn = true;
    } else {
      _isSwitchOn = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.setupAppBarTitle)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Main title
            SizedBox(
              width: double.infinity,
              child: Text(
                AppStrings.setupTitle,
                style: AppTypography.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.sm),

            /// Description
            SizedBox(
              width: double.infinity,
              child: Text(AppStrings.setupDes, textAlign: TextAlign.center),
            ),

            SizedBox(height: AppSpacing.md),

            /// Currency
            Text(
              AppStrings.suCurrency,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacing.sm),

            GestureDetector(
              onTap: () {
                showCurrencyPicker(
                  favorite: ["USD", "EUR", "HKD", "MMK"],
                  context: context,
                  onSelect: (e) {
                    setState(() {
                      _selectedCurrency = e;
                    });
                  },
                );
              },
              child: ListTile(
                shape: AppTheme.roundedRectangleBorder,
                title: Text(
                  "${_selectedCurrency.code} - ${_selectedCurrency.name}",
                ),
                trailing: Icon(Icons.search),
              ),
            ),

            SizedBox(height: AppSpacing.md),

            /// Time Zone
            Text(
              AppStrings.suTimezone,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacing.sm),
            ListTile(
              shape: AppTheme.roundedRectangleBorder,
              title: Text(
                '${_currentTimeZone?.identifier ?? AppStrings.unknown} - ${_gmtOffsetFormatted ?? AppStrings.unknown}',
              ),
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.auto_awesome_rounded,
                size: AppSpacing.md,
                color: Colors.grey,
              ),
              minVerticalPadding: 0,

              title: Text(
                AppStrings.suAutoDetected,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: AppSpacing.md),

            /// Theme
            Text(
              AppStrings.suThemeTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacing.sm),

            Row(
              children: themes.map((item) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedTheme = item;
                  }),
                  child: ThemeListItem(
                    itemBorderColor: _selectedTheme == item
                        ? Colors.blue
                        : Colors.grey,
                    typeLabel: item["label"],
                    containerColor: item["color"],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppSpacing.md),

            // Haptic
            _canVibrate
                ? ListTile(
                    shape: AppTheme.roundedRectangleBorder,
                    leading: Icon(Icons.mobile_friendly, size: AppSpacing.md),
                    title: Text(AppStrings.suEnableHapticFB),
                    trailing: Switch(
                      value: _isSwitchOn,
                      onChanged: (value) {
                        setState(() {
                          _isSwitchOn = value;
                        });
                      },
                    ),
                  )
                : ListTile(
                    tileColor: Colors.blueGrey.withOpacity(0.1),
                    leading: Icon(
                      Icons.mobile_friendly,
                      color: Colors.grey,
                      size: AppSpacing.md,
                    ),
                    title: Text(
                      AppStrings.suNoHapticFeedback,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    shape: AppTheme.roundedRectangleBorder.copyWith(
                      side: BorderSide(color: Colors.transparent),
                    ),
                  ),

            SizedBox(height: AppSpacing.sm),

            /// Encryption Enabled
            ListTile(
              tileColor: Colors.lightGreen.withOpacity(0.1),
              shape: AppTheme.roundedRectangleBorder.copyWith(
                side: BorderSide(color: Colors.transparent),
              ),
              leading: Icon(
                Icons.security,
                color: const Color.fromARGB(255, 10, 118, 66),
              ),
              title: Text(AppStrings.suEncryptionEnabled),
              subtitle: Text(
                AppStrings.suKeysStoredSecurely,
                style: AppTypography.bodySmall.copyWith(
                  color: Color.fromARGB(255, 10, 118, 66),
                ),
              ),
            ),

            ////......................
            Container(
              margin: EdgeInsets.only(top: AppSpacing.lg),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  addThePersonalizeToPrefs(
                    _selectedCurrency.symbol,
                    _selectedTheme?['label'],
                    _isSwitchOn,
                  );
                  if (_isSwitchOn == true) {
                    HapticFeedbackHelper.light();
                  }

                  debugPrint(
                    "${widget.prefsHelper.getString(AppStrings.sfCurrentCurrency)} + ${widget.prefsHelper.getString(AppStrings.sfSelectedTheme)} + ${widget.prefsHelper.getBool(AppStrings.sfIsHapticOn)}",
                  );
                  context.push(Routes.onboardingCatSuggest);
                },
                child: Text(
                  AppStrings.bContinue,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addThePersonalizeToPrefs(
    String currencySymbol,
    String selectedTheme,
    bool isHapticOn,
  ) {
    widget.prefsHelper
      ..setString(AppStrings.sfCurrentCurrency, currencySymbol)
      ..setString(AppStrings.sfSelectedTheme, selectedTheme)
      ..setBool(AppStrings.sfIsHapticOn, isHapticOn);
  }
}
