import 'package:flutter/material.dart';

/// Brand tokens, converted from the SevaOne web portal's OKLCH palette
/// (frontend/src/styles.css in the seva-one repo).
class Seva {
  static const blue = Color(0xFF5553D2);
  static const blueDark = Color(0xFF4137A6);
  static const navy = Color(0xFF1A1C37);
  static const green = Color(0xFF00AD82);
  static const greenDark = Color(0xFF007A5C);
  static const gold = Color(0xFFEFB146);
  static const saffron = Color(0xFFF67D51);
  static const red = Color(0xFFD73240);
  static const aqua = Color(0xFFCAF5F2);

  static const headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navy, blueDark, blue],
  );
}

const _display = 'NotoSans';

ThemeData buildTheme({required bool dark, required bool highContrast}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: Seva.blue,
    brightness: dark ? Brightness.dark : Brightness.light,
  ).copyWith(
    primary: highContrast
        ? (dark ? const Color(0xFFFFE082) : const Color(0xFF20188C))
        : (dark ? const Color(0xFFB4B3FF) : Seva.blue),
    onPrimary: highContrast
        ? (dark ? Colors.black : Colors.white)
        : (dark ? const Color(0xFF1A1C37) : Colors.white),
    secondary: dark ? const Color(0xFF5FE0BD) : Seva.greenDark,
    error: dark ? const Color(0xFFFF8A92) : Seva.red,
    surface: highContrast
        ? (dark ? Colors.black : Colors.white)
        : (dark ? const Color(0xFF12132A) : const Color(0xFFFDFDFF)),
    onSurface: highContrast
        ? (dark ? Colors.white : Colors.black)
        : (dark ? const Color(0xFFEDEDF7) : const Color(0xFF131524)),
    onSurfaceVariant: highContrast
        ? (dark ? Colors.white : Colors.black)
        : (dark ? const Color(0xFFB2B4C8) : const Color(0xFF5F6275)),
    surfaceContainerHighest:
        dark ? const Color(0xFF23254A) : const Color(0xFFF2F3FC),
    surfaceContainerHigh:
        dark ? const Color(0xFF1D1F3E) : const Color(0xFFF7F7FD),
    surfaceContainerLow: dark ? const Color(0xFF191A36) : Colors.white,
    outlineVariant: highContrast
        ? (dark ? Colors.white : Colors.black)
        : (dark ? const Color(0xFF33365C) : const Color(0xFFE5E6EC)),
  );

  TextStyle d(double size, FontWeight w, {double height = 1.2}) => TextStyle(
        fontFamily: _display,
        fontFamilyFallback: const ['NotoKannada'],
        fontSize: size,
        fontWeight: w,
        height: height,
      );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'NotoSans',
    fontFamilyFallback: const ['NotoKannada'],
  );

  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    textTheme: base.textTheme
        .copyWith(
          headlineMedium: d(26, FontWeight.w700),
          headlineSmall: d(22, FontWeight.w700),
          titleLarge: d(19, FontWeight.w700),
          titleMedium: d(16, FontWeight.w600, height: 1.3),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      titleTextStyle: d(18, FontWeight.w700).copyWith(color: scheme.onSurface),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: scheme.outlineVariant, width: highContrast ? 1.5 : 1),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
            fontFamily: 'NotoSans',
            fontFamilyFallback: ['NotoKannada'],
            fontSize: 15.5,
            fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    chipTheme: base.chipTheme.copyWith(
      side: BorderSide(color: scheme.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      showCheckmark: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primary.withValues(alpha: 0.14),
      labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
            fontFamily: 'NotoSans',
            fontFamilyFallback: const ['NotoKannada'],
            fontSize: 11.5,
            fontWeight: s.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: s.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          )),
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          )),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
