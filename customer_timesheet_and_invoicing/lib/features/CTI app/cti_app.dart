import 'package:customer_timesheet_and_invoicing/core/theme_controller.dart';
import 'package:customer_timesheet_and_invoicing/features/auth/login_page.dart';
import 'package:customer_timesheet_and_invoicing/features/setup/setup_page.dart';
import 'package:flutter/material.dart';

class CTIApp extends StatelessWidget {
  final bool isSetupComplete;
  final ThemeController themeController;

  const CTIApp({super.key, required this.isSetupComplete, required this.themeController});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeController.themeNotifier,
      builder: (context, theme, child,) {
        return MaterialApp(
          title: 'CTI App',
          theme: theme,
          home: isSetupComplete ? LoginPage(themeController: themeController) : SetupPage(themeController: themeController),
        );
      }
    );
  }
}

