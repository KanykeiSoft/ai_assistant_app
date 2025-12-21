import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Основная зелёная кнопка (заливка)
ButtonStyle primaryGreenButtonStyle() {
  return ButtonStyle(
    minimumSize: MaterialStateProperty.all(const Size.fromHeight(56)),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),

    // фон: зелёный, темнее при нажатии
    backgroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return AppColors.primary.withOpacity(0.85);
      }
      return AppColors.primary;
    }),

    // текст белый
    foregroundColor: MaterialStateProperty.all(Colors.white),

    // подсветка только при нажатии
    overlayColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.white.withOpacity(0.12);
      }
      return Colors.transparent;
    }),
  );
}

/// Вторичная кнопка (обводка зелёная)
ButtonStyle outlinedGreenButtonStyle() {
  return ButtonStyle(
    minimumSize: MaterialStateProperty.all(const Size.fromHeight(56)),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),

    side: MaterialStateProperty.all(
      BorderSide(color: AppColors.primary.withOpacity(0.65), width: 1.5),
    ),

    foregroundColor: MaterialStateProperty.all(AppColors.primary),

    overlayColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return AppColors.primary.withOpacity(0.12);
      }
      return Colors.transparent;
    }),
  );
}
