import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    prefs.setBool('isDarkMode', !isDarkMode);
    emit(!isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
