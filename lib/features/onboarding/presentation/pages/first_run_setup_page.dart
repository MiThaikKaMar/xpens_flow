import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/app_strings.dart';
import 'package:xpens_flow/core/common/init_variables.dart';
import 'package:xpens_flow/core/helpers/haptic_feedback_helper.dart';
import 'package:xpens_flow/core/helpers/shared_preferences_helper.dart';
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
      body: Column(
        children: [
          Text(AppStrings.setupTitle),
          Text(AppStrings.setupDes),

          Text(AppStrings.suCurrency),

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
              shape: Border.all(color: Colors.grey),
              title: Text(
                "${_selectedCurrency.code} - ${_selectedCurrency.name}",
              ),
              trailing: Icon(Icons.search),
            ),
          ),
          Text(AppStrings.suTimezone),

          ListTile(
            shape: Border.all(color: Colors.grey),
            title: Text(
              '${_currentTimeZone?.identifier ?? AppStrings.unknown} - ${_gmtOffsetFormatted ?? AppStrings.unknown}',
            ),
          ),
          ListTile(
            leading: Icon(Icons.auto_awesome_rounded),
            title: Text(AppStrings.suAutoDetected),
          ),
          Text(AppStrings.suThemeTitle),

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
                  typeLable: item["label"],
                  containerColor: item["color"],
                ),
              );
            }).toList(),
          ),
          _canVibrate
              ? ListTile(
                  leading: Icon(Icons.mobile_friendly),
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
              : Text(AppStrings.suNoHapticFeedback),

          ListTile(
            leading: Icon(Icons.security),
            title: Text(AppStrings.suEncryptionEnabled),
            subtitle: Text(AppStrings.suKeysStoredSecurely),
          ),
          ElevatedButton(
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
                "${widget.prefsHelper.getString(AppStrings.prefCurrentCurrency)} + ${widget.prefsHelper.getString(AppStrings.prefSelectedTheme)} + ${widget.prefsHelper.getBool(AppStrings.prefIsHapticOn)}",
              );
              context.push(Routes.onboardingCatSuggest);
            },
            child: Text(AppStrings.bContinue),
          ),
        ],
      ),
    );
  }

  void addThePersonalizeToPrefs(
    String currencySymbol,
    String selectedTheme,
    bool isHapticOn,
  ) {
    widget.prefsHelper
      ..setString(AppStrings.prefCurrentCurrency, currencySymbol)
      ..setString(AppStrings.prefSelectedTheme, selectedTheme)
      ..setBool(AppStrings.prefIsHapticOn, isHapticOn);
  }
}
