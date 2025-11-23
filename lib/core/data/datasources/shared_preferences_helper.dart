import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesHelper {
  Future<bool> setBool(String key, bool value);
  Future<bool> setString(String key, String value);
  Future<bool> setInt(String key, int value);

  bool? getBool(String key);
  String? getString(String key);
  int? getInt(String key);

  Future<bool> remove(String key);
  Future<bool> clear();
}

class SharedPreferencesHelperImpl implements SharedPreferencesHelper {
  final SharedPreferences _prefs;

  SharedPreferencesHelperImpl(this._prefs);

  @override
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  @override
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    return await _prefs.clear();
  }
}
