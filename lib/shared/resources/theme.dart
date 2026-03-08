import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2B5219);
  static const Color primaryLight = Color(0xFF4A7C35);
  static const Color primaryAccent = Color(0xFF3D7A28);

  static const Color background = Color(0xFFEDE8D5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F2E8);

  static const Color textDark = Color(0xFF1B1B1B);
  static const Color textMuted = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color gradeA = Color(0xFF4CAF50);
  static const Color gradeB = Color(0xFFFF9800);
  static const Color gradeC = Color(0xFFF44336);

  static const Color cropPechay = Color(0xFF81C784);
  static const Color cropTomato = Color(0xFFEF5350);
  static const Color cropEggplant = Color(0xFF7E57C2);
  static const Color cropRice = Color(0xFFFFD54F);
  static const Color cropMais = Color(0xFFFFA726);
  static const Color cropBanana = Color(0xFFFFCA28);
  static const Color cropCoffee = Color(0xFF8D6E63);
  static const Color cropCucumber = Color(0xFF66BB6A);
  static const Color cropOther = Color(0xFF90A4AE);

  static const Color error = Color(0xFFB00020);
  static const Color divider = Color(0xFFE0D9C8);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: AppColors.textDark),
          titleTextStyle: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textLight,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      );
}
