import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Prefs instance = Prefs._internal();
  late SharedPreferences _prefs;

  Prefs._internal();

  static Future<void> init() async {
    instance._prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs => _prefs;
}