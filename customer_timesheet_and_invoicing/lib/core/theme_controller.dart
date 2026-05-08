import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:flutter/material.dart';
import 'themes.dart';

class ThemeController {
  final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(darkTheme);
  Map<String, dynamic>? user;

  ThemeController() {
    getThemeData();
  }

  Future<void> getThemeData() async {
    final result = await getUserProfile();
    if (result != null) {
      themeNotifier.value = result["theme"] == "dark" ? darkTheme : lightTheme;
    }
    else {
      themeNotifier.value = darkTheme;
    }
  }  

  Future<void> updateUserProfile(String theme) async {
    await updateUser({
      'theme': theme,
    });
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('user_profile', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      'user_profile',
      values,
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  void toggleTheme() {
    if (themeNotifier.value == darkTheme) {
      themeNotifier.value = lightTheme;
      updateUserProfile('light');
      getThemeData();
    }
    else {
      themeNotifier.value = darkTheme;
      updateUserProfile('dark');
      getThemeData();
    }
  }
}