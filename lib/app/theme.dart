import 'package:flutter/material.dart';

/// AppTheme defines the application's visual design using Material 3
/// and design tokens derived from the provided design guide.
///
/// Color tokens:
/// - Primary (Emerald): #059669
/// - Success (Green): #16a34a
/// - Error (Red): #dc2626
/// - Secondary/Neutral: #6b7280
///
/// Typography:
/// - Headers: 18–24, weight w600
/// - Body: 14–16, weight w400
/// - Captions: 12–14, weight w500
/// - Buttons: 14–16, weight w600
///
/// Spacing:
/// - Base unit: 4 (use multiples like 8, 12, 16, 24)
class AppTheme {
  AppTheme._();

  // Brand colors
  static const Color _brandPrimary = Color(0xFF059669);
  static const Color _brandSuccess = Color(0xFF16A34A);
  static const Color _brandError = Color(0xFFDC2626);
  static const Color _brandNeutral = Color(0xFF6B7280);

  // Light color scheme
  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: _brandPrimary,
    brightness: Brightness.light,
    primary: _brandPrimary,
    onPrimary: Colors.white,
    secondary: _brandNeutral,
    onSecondary: Colors.white,
    error: _brandError,
    onError: Colors.white,
  );

  // Dark color scheme
  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: _brandPrimary,
    brightness: Brightness.dark,
    primary: _brandPrimary,
    secondary: _brandNeutral,
    error: _brandError,
  );

  // Typography presets aligned with the guide
  static const TextTheme _textTheme = TextTheme(
    // Headers
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),

    // Titles (section headers / list titles)
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),

    // Body
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

    // Labels (buttons/captions)
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  );

  /// Common component theming shared across light and dark themes.
  static ThemeData _baseTheme(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0F1113) : const Color(0xFFF9FAFB),
      textTheme: _textTheme.apply(
        bodyColor: scheme.onBackground,
        displayColor: scheme.onBackground,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),

      // Navigation Bar (Material 3 bottom bar for 5 tabs)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withOpacity(0.15),
        elevation: 2,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected =
              states.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500;
          return _textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: selected,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurfaceVariant;
          return IconThemeData(color: color, size: 24);
        }),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size.fromHeight(44)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.primary.withOpacity(0.38);
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStateProperty.all(scheme.onPrimary),
          textStyle: WidgetStateProperty.all(_textTheme.labelLarge),
          elevation: WidgetStateProperty.all(0),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size.fromHeight(44)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textStyle: WidgetStateProperty.all(_textTheme.labelLarge),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size.fromHeight(44)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          side: WidgetStateProperty.all(
            BorderSide(color: scheme.outline),
          ),
          textStyle: WidgetStateProperty.all(_textTheme.labelLarge),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          textStyle: WidgetStateProperty.all(_textTheme.labelMedium),
          foregroundColor: WidgetStateProperty.all(scheme.primary),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? scheme.surface : Colors.white,
        hintStyle: _textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        color: isDark ? scheme.surface : Colors.white,
        elevation: 1,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.primary.withOpacity(0.15),
        labelStyle: _textTheme.labelMedium?.copyWith(
          color: scheme.onSurface,
        ),
        secondaryLabelStyle: _textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        spacing: 0.5,
        thickness: 1,
      ),

      // List tiles
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Dialogs/Bottom sheets
      dialogTheme: DialogTheme(
        backgroundColor: isDark ? scheme.surface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
        ),
        contentTextStyle: _textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? scheme.surface : Colors.white,
        modalBackgroundColor: isDark ? scheme.surface : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        showDragHandle: true,
      ),

      // Icons
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
    );
  }

  /// Light theme
  static ThemeData light() => _baseTheme(_lightScheme);

  /// Dark theme
  static ThemeData dark() => _baseTheme(_darkScheme);

  /// Convenience color getters for feature modules
  static Color get success => _brandSuccess;
  static Color get error => _brandError;
  static Color get neutral => _brandNeutral;
  static Color get primary => _brandPrimary;
}
