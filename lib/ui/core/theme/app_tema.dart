import 'package:flutter/material.dart';

import 'app_bordes.dart';
import 'app_colores.dart';
import 'app_espaciado.dart';

/// Equivalente a la hoja de estilos global de una web.
/// Los widgets Material heredan este tema sin repetir estilos en cada pantalla.
abstract final class AppTema {
  /// Variante clara de acceso: superficies tranquilas y acciones en verde tinta.
  static ThemeData get acceso {
    final base = claro;
    final texto = base.textTheme
        .apply(
          bodyColor: AppColores.accesoTinta,
          displayColor: AppColores.accesoTinta,
        )
        .copyWith(
          headlineLarge: base.textTheme.headlineLarge?.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.3,
            height: 1.12,
            color: AppColores.accesoTinta,
          ),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            height: 1.18,
            color: AppColores.accesoTinta,
          ),
          headlineSmall: base.textTheme.headlineSmall?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
            height: 1.2,
            color: AppColores.accesoTinta,
          ),
          bodyLarge: base.textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            height: 1.55,
            color: AppColores.accesoTextoSecundario,
          ),
          bodySmall: base.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            height: 1.5,
            color: AppColores.accesoTextoSecundario,
          ),
          labelLarge: base.textTheme.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: AppColores.accesoTinta,
          ),
        );
    final formaBoton = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppBordes.medio),
    );
    final bordeCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppBordes.medio),
      borderSide: const BorderSide(color: AppColores.accesoBorde),
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColores.accesoTinta,
        onPrimary: AppColores.sobrePrimario,
        primaryContainer: AppColores.accesoSuave,
        onPrimaryContainer: AppColores.accesoTinta,
        secondary: AppColores.primario,
        secondaryContainer: AppColores.accesoSuave,
        onSecondaryContainer: AppColores.primario,
        surface: AppColores.superficie,
        onSurface: AppColores.accesoTinta,
        onSurfaceVariant: AppColores.accesoTextoSecundario,
        outline: AppColores.accesoBorde,
        outlineVariant: AppColores.accesoBorde,
        surfaceContainerLow: AppColores.accesoSuave,
        surfaceTint: AppColores.accesoTinta,
      ),
      textTheme: texto,
      scaffoldBackgroundColor: AppColores.accesoFondo,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColores.accesoFondo,
        foregroundColor: AppColores.accesoTinta,
        titleTextStyle: texto.titleMedium?.copyWith(
          color: AppColores.accesoTinta,
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        shadowColor: AppColores.accesoTinta.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBordes.grande),
          side: const BorderSide(color: AppColores.accesoBorde, width: 0.8),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: AppColores.superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppEspaciado.md,
          vertical: AppEspaciado.md,
        ),
        prefixIconColor: AppColores.accesoTextoSecundario,
        suffixIconColor: AppColores.accesoTextoSecundario,
        labelStyle: texto.bodyMedium?.copyWith(
          color: AppColores.accesoTextoSecundario,
        ),
        floatingLabelStyle: texto.labelLarge?.copyWith(
          fontSize: 13,
          color: AppColores.accesoTinta,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: bordeCampo,
        enabledBorder: bordeCampo,
        disabledBorder: bordeCampo,
        focusedBorder: bordeCampo.copyWith(
          borderSide: const BorderSide(color: AppColores.primario, width: 1.5),
        ),
        hoverColor: AppColores.accesoSuave.withValues(alpha: 0.55),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              backgroundColor: AppColores.accesoTinta,
              foregroundColor: AppColores.sobrePrimario,
              disabledBackgroundColor: AppColores.accesoBorde,
              disabledForegroundColor: AppColores.accesoTextoSecundario,
              minimumSize: const Size(48, 54),
              padding: const EdgeInsets.symmetric(
                horizontal: AppEspaciado.lg,
                vertical: AppEspaciado.sm,
              ),
              shape: formaBoton,
              textStyle: texto.labelLarge?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ).copyWith(
              animationDuration: const Duration(milliseconds: 180),
              overlayColor: WidgetStateProperty.resolveWith((estados) {
                if (estados.contains(WidgetState.pressed)) {
                  return AppColores.superficie.withValues(alpha: 0.16);
                }
                if (estados.contains(WidgetState.hovered) ||
                    estados.contains(WidgetState.focused)) {
                  return AppColores.superficie.withValues(alpha: 0.09);
                }
                return Colors.transparent;
              }),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              backgroundColor: AppColores.superficie,
              foregroundColor: AppColores.accesoTinta,
              minimumSize: const Size(48, 52),
              padding: const EdgeInsets.symmetric(
                horizontal: AppEspaciado.md,
                vertical: AppEspaciado.sm,
              ),
              side: const BorderSide(color: AppColores.accesoBorde),
              shape: formaBoton,
              textStyle: texto.labelLarge,
            ).copyWith(
              animationDuration: const Duration(milliseconds: 180),
              overlayColor: WidgetStateProperty.resolveWith((estados) {
                if (estados.contains(WidgetState.hovered) ||
                    estados.contains(WidgetState.focused) ||
                    estados.contains(WidgetState.pressed)) {
                  return AppColores.primario.withValues(alpha: 0.055);
                }
                return Colors.transparent;
              }),
              side: WidgetStateProperty.resolveWith((estados) {
                return BorderSide(
                  color:
                      estados.contains(WidgetState.hovered) ||
                          estados.contains(WidgetState.focused)
                      ? AppColores.primario.withValues(alpha: 0.45)
                      : AppColores.accesoBorde,
                );
              }),
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
      textSelectionTheme: base.textSelectionTheme.copyWith(
        cursorColor: AppColores.accesoTinta,
        selectionColor: AppColores.acento.withValues(alpha: 0.35),
        selectionHandleColor: AppColores.accesoTinta,
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
