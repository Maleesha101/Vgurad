import 'package:flutter/material.dart';

// Colors
class AppColors {
  static Color primaryGreen = Color(0xFF4CAF50);
  static Color darkGreen = Color(0xFF2E7D32);
  static Color lightGreen = Color(0x00358c24);
  static Color lightGreenBackground = Color(0xFFF0FDF4);
  static Color lightGreenAccent = Color(0xFFE8F5E9);
  static Color yellowBackground = Color(0xFFFFFBE6);
  static Color lWhite = Color(0x00f9fbf9);
  static Color amber200 = Colors.amber.shade200;
  static Color amber700 = Colors.amber.shade700;

  static Color grey50 = Colors.grey.shade50;
  static Color grey100 = Colors.grey.shade100;
  static Color grey200 = Colors.grey.shade200;
  static Color grey300 = Colors.grey.shade300;
  static Color grey400 = Colors.grey.shade400;
  static Color grey600 = Colors.grey.shade600;
  static Color grey700 = Colors.grey.shade700;

  static const Color black87 = Colors.black87;
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color transparent = Colors.transparent;

  static const Color red = Colors.red;
  static const Color orange = Colors.orange;
  static const Color green = Colors.green;
  static const Color deepOrange = Colors.deepOrange;
  static const Color amber = Colors.amber;
  static const Color blueGrey = Colors.blueGrey;
  static const Color teal = Colors.teal;
  static const Color pink = Colors.pink;
  static const Color purple = Colors.purple;
}

// Paddings & Sizes
class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double paddingXLarge = 24.0;
  static const double paddingXXLarge = 30.0;
  static const double paddingHeroVertical = 40.0;

  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 20.0;

  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 28.0;
  static const double iconSizeXLarge = 30.0;
  static const double iconSizeXXLarge = 40.0;
  static const double iconSizeHero = 50.0;

  static const double buttonHeight = 50.0;
  static const double cardElevation = 1.0;
  static const double dividerThickness = 1.0;
  static const double horizontalSpacing = 20.0;
  static const double verticalSpacing = 20.0;
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bodyLarge = TextStyle(fontSize: 16);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14);
  static const TextStyle bodySmall = TextStyle(fontSize: 12);

  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static const TextStyle heroTitle = TextStyle(
    color: AppColors.white,
    fontSize: 42,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle heroDescription = TextStyle(
    color: AppColors.white70,
    fontSize: 18,
    height: 1.5,
  );

  static TextStyle featureCardTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black87.withOpacity(0.75),
  );

  static const TextStyle pageHeaderTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black87,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black87,
  );
}
