import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SPSettings {
  final String fontSizeKey = 'font_size';
  final String colorKey = 'color';
  static late SharedPreferences _sp;
  static SPSettings? _instance;

  SPSettings._internal();

  factory SPSettings() {
    _instance ??= SPSettings._internal();
    return _instance as SPSettings;
  }

  Future init() async {
    _sp = await SharedPreferences.getInstance();
  }

  Future setColor(int color) {
    return _sp.setInt(colorKey, color);
  }

  int getColor() {
    return _sp.getInt(colorKey) ?? 0xff1976d2;
  }

  Future setFontSize(double size) async {
    return _sp.setDouble(fontSizeKey, size);
  }

  double getFontSize() {
    return _sp.getDouble(fontSizeKey) ?? 14;
  }
}
// The settings will be used in all the screen of our app
// it would be a waste of resources creating a new instance of _sp setting.
// each time a screen needs to check the color or font size and read
// again from SharePreferences.There are several patterns we could use
// to solve this issue. Here, we use the factory pattern.
// Use this pattern in class when you want to create a constructor that
// does not always return a new instance of the class. You may return an instance
// that's already loaded in a cache or you want return an instance of a subtype.
