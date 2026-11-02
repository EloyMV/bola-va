import 'package:flutter/material.dart';

import 'app_bordes.dart';
import 'app_colores.dart';
import 'app_espaciado.dart';

/// Equivalente a la hoja de estilos global de una web.
/// Los widgets Material heredan este tema sin repetir estilos en cada pantalla.
abstract final class AppTema {
  /// Variante de la paleta común para las pantallas de acceso.
  static ThemeData get acceso {
    final base = claro;
    final formaBoton = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppBordes.medio),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColores.fondoAccesoProfundo,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColores.primario,
        foregroundColor: AppColores.sobrePrimario,
        titleTextStyle: base.textTheme.titleMedium?.copyWith(
          color: AppColores.sobrePrimario,
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 4,
        shadowColor: AppColores.texto.withValues(alpha: 0.16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBordes.grande),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: AppColores.fondo,
        prefixIconColor: AppColores.primario,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColores.acento,
          foregroundColor: AppColores.texto,
          disabledBackgroundColor: AppColores.borde,
          disabledForegroundColor: AppColores.textoSecundario,
          minimumSize: const Size(48, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppEspaciado.lg,
            vertical: AppEspaciado.sm,
          ),
          shape: formaBoton,
          textStyle: base.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColores.fondo,
          foregroundColor: AppColores.texto,
          minimumSize: const Size(48, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppEspaciado.md,
            vertical: AppEspaciado.sm,
          ),
          side: const BorderSide(color: AppColores.borde),
          shape: formaBoton,
          textStyle: base.textTheme.labelLarge,
        ),
      ),
    );
  }

  static ThemeData get claro {
    const esquema = ColorScheme.light(
      primary: AppColores.primario,
      onPrimary: AppColores.sobrePrimario,
      primaryContainer: AppColores.acento,
      onPrimaryContainer: AppColores.texto,
      secondary: AppColores.secundario,
      onSecondary: AppColores.superficie,
      secondaryContainer: AppColores.fondo,
      onSecondaryContainer: AppColores.secundario,
      tertiary: AppColores.primario,
      onTertiary: AppColores.sobrePrimario,
      tertiaryContainer: AppColores.acento,
      onTertiaryContainer: AppColores.texto,
      surface: AppColores.superficie,
      onSurface: AppColores.texto,
      onSurfaceVariant: AppColores.textoSecundario,
      surfaceContainerLowest: AppColores.superficie,
      surfaceContainerLow: AppColores.fondo,
      surfaceContainer: AppColores.fondo,
      surfaceContainerHigh: AppColores.borde,
      surfaceContainerHighest: AppColores.borde,
      outline: AppColores.textoSecundario,
      outlineVariant: AppColores.borde,
      error: AppColores.error,
      onError: AppColores.superficie,
      inverseSurface: AppColores.texto,
      onInverseSurface: AppColores.superficie,
      inversePrimary: AppColores.acento,
      surfaceTint: AppColores.primario,
    );

    final textoBase = ThemeData.light(useMaterial3: true).textTheme;
    final texto = textoBase
        .apply(bodyColor: AppColores.texto, displayColor: AppColores.texto)
        .copyWith(
          headlineLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: AppColores.texto,
          ),
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: AppColores.texto,
          ),
          headlineSmall: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.3,
            color: AppColores.texto,
          ),
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.3,
            color: AppColores.texto,
          ),
          titleMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: AppColores.texto,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: AppColores.texto,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColores.texto,
          ),
          bodySmall: const TextStyle(
            fontSize: 12,
            height: 1.5,
            color: AppColores.textoSecundario,
          ),
          labelLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        )
        // Conserva la fuente de Material también en los estilos redefinidos.
        .apply(fontFamily: textoBase.bodyMedium?.fontFamily);

    final bordeCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppBordes.medio),
      borderSide: const BorderSide(color: AppColores.borde),
    );
    final formaBoton = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppBordes.medio),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: esquema,
      scaffoldBackgroundColor: AppColores.fondo,
      disabledColor: AppColores.ocupado,
      textTheme: texto,
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColores.fondo,
        foregroundColor: AppColores.texto,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: texto.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: AppColores.superficie,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBordes.grande),
          side: const BorderSide(color: AppColores.borde),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColores.superficie,
        contentPadding: const EdgeInsets.all(AppEspaciado.md),
        labelStyle: const TextStyle(color: AppColores.textoSecundario),
        hintStyle: const TextStyle(color: AppColores.textoSecundario),
        floatingLabelStyle: const TextStyle(color: AppColores.primario),
        prefixIconColor: AppColores.textoSecundario,
        suffixIconColor: AppColores.textoSecundario,
        errorStyle: const TextStyle(color: AppColores.error),
        errorMaxLines: 3,
        border: bordeCampo,
        enabledBorder: bordeCampo,
        disabledBorder: bordeCampo,
        focusedBorder: bordeCampo.copyWith(
          borderSide: const BorderSide(color: AppColores.primario, width: 2),
        ),
        errorBorder: bordeCampo.copyWith(
          borderSide: const BorderSide(color: AppColores.error),
        ),
        focusedErrorBorder: bordeCampo.copyWith(
          borderSide: const BorderSide(color: AppColores.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColores.primario,
          foregroundColor: AppColores.sobrePrimario,
          disabledBackgroundColor: AppColores.borde,
          disabledForegroundColor: AppColores.textoSecundario,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppEspaciado.lg,
            vertical: AppEspaciado.sm,
          ),
          shape: formaBoton,
          textStyle: texto.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColores.primario,
          foregroundColor: AppColores.sobrePrimario,
          disabledBackgroundColor: AppColores.borde,
          disabledForegroundColor: AppColores.textoSecundario,
          elevation: 0,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.lg),
          shape: formaBoton,
          textStyle: texto.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColores.primario,
          disabledForegroundColor: AppColores.textoSecundario,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.lg),
          side: const BorderSide(color: AppColores.primario),
          shape: formaBoton,
          textStyle: texto.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColores.primario,
          minimumSize: const Size(48, 48),
          shape: formaBoton,
          textStyle: texto.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColores.superficie,
        selectedColor: AppColores.acento,
        secondarySelectedColor: AppColores.acento,
        disabledColor: AppColores.borde,
        labelStyle: texto.labelLarge?.copyWith(color: AppColores.texto),
        secondaryLabelStyle: texto.labelLarge?.copyWith(
          color: AppColores.texto,
        ),
        checkmarkColor: AppColores.primario,
        side: const BorderSide(color: AppColores.borde),
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspaciado.xs,
          vertical: AppEspaciado.xxs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBordes.redondo),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColores.superficie,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColores.acento,
        labelTextStyle: WidgetStateProperty.resolveWith((estados) {
          return texto.labelMedium?.copyWith(
            color: estados.contains(WidgetState.selected)
                ? AppColores.primario
                : AppColores.textoSecundario,
            fontWeight: FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((estados) {
          return IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? AppColores.primario
                : AppColores.textoSecundario,
          );
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColores.superficie,
        selectedItemColor: AppColores.primario,
        unselectedItemColor: AppColores.textoSecundario,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColores.primario,
        unselectedLabelColor: AppColores.textoSecundario,
        indicatorColor: AppColores.primario,
        dividerColor: AppColores.borde,
        labelStyle: texto.labelLarge,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColores.borde,
        thickness: 1,
        space: AppEspaciado.lg,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColores.texto,
        contentTextStyle: texto.bodyMedium?.copyWith(
          color: AppColores.superficie,
        ),
        actionTextColor: AppColores.acento,
        behavior: SnackBarBehavior.floating,
        shape: formaBoton,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColores.superficie,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBordes.grande),
        ),
        titleTextStyle: texto.titleLarge,
        contentTextStyle: texto.bodyMedium,
      ),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: AppColores.superficie,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: AppColores.primario,
        headerForegroundColor: AppColores.sobrePrimario,
      ),
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: AppColores.superficie,
        dialBackgroundColor: AppColores.fondo,
        dialHandColor: AppColores.primario,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColores.primario,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColores.acento,
        foregroundColor: AppColores.texto,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColores.primario,
        selectionColor: AppColores.acento.withValues(alpha: 0.6),
        selectionHandleColor: AppColores.primario,
      ),
    );
  }
}
