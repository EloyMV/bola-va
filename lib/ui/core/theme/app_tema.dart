import 'package:flutter/material.dart';

import 'app_bordes.dart';
import 'app_colores.dart';
import 'app_espaciado.dart';

/// Equivalente a la hoja de estilos global de una web.
/// Los widgets Material heredan este tema sin repetir estilos en cada pantalla.
abstract final class AppTema {
  /// Variante clara de acceso: superficies tranquilas y acciones en verde tinta.
  static final ThemeData acceso = _crearAcceso(claro);

  /// Mantiene los mismos formularios cuando se elige la apariencia oscura.
  static final ThemeData accesoOscuro = _crearAcceso(oscuro);

  static final ThemeData claro = _crearClaro();
  static final ThemeData oscuro = _crearOscuro();

  // El cambio de tema también actualiza los widgets que consultan sus estados.
  static final ThemeData claroAccesible = claro.copyWith(
    colorScheme: claro.colorScheme.copyWith(
      tertiary: AppColores.disponibleDaltonismo,
    ),
  );
  static final ThemeData oscuroAccesible = oscuro.copyWith(
    colorScheme: oscuro.colorScheme.copyWith(
      tertiary: AppColores.disponibleDaltonismoOscuro,
    ),
  );

  static ThemeData _crearAcceso(ThemeData base) {
    final esOscuro = base.brightness == Brightness.dark;
    final tinta = esOscuro
        ? base.colorScheme.onSurface
        : AppColores.accesoTinta;
    final secundario = esOscuro
        ? base.colorScheme.onSurfaceVariant
        : AppColores.accesoTextoSecundario;
    final suave = esOscuro
        ? base.colorScheme.surfaceContainerLow
        : AppColores.accesoSuave;
    final borde = esOscuro
        ? base.colorScheme.outlineVariant
        : AppColores.accesoBorde;
    final superficie = base.colorScheme.surface;
    final fondo = esOscuro
        ? base.scaffoldBackgroundColor
        : AppColores.accesoFondo;
    final primario = esOscuro ? base.colorScheme.primary : AppColores.primario;
    final sobreBoton = esOscuro
        ? base.colorScheme.surface
        : AppColores.sobrePrimario;
    final texto = base.textTheme
        .apply(bodyColor: tinta, displayColor: tinta)
        .copyWith(
          headlineLarge: base.textTheme.headlineLarge?.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.3,
            height: 1.12,
            color: tinta,
          ),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            height: 1.18,
            color: tinta,
          ),
          headlineSmall: base.textTheme.headlineSmall?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
            height: 1.2,
            color: tinta,
          ),
          bodyLarge: base.textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            height: 1.55,
            color: secundario,
          ),
          bodySmall: base.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            height: 1.5,
            color: secundario,
          ),
          labelLarge: base.textTheme.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: tinta,
          ),
        );
    final formaBoton = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppBordes.medio),
    );
    final bordeCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppBordes.medio),
      borderSide: BorderSide(color: borde),
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: tinta,
        onPrimary: sobreBoton,
        primaryContainer: suave,
        onPrimaryContainer: tinta,
        secondary: primario,
        secondaryContainer: suave,
        onSecondaryContainer: primario,
        surface: superficie,
        onSurface: tinta,
        onSurfaceVariant: secundario,
        outline: borde,
        outlineVariant: borde,
        surfaceContainerLow: suave,
        surfaceTint: tinta,
      ),
      textTheme: texto,
      scaffoldBackgroundColor: fondo,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: fondo,
        foregroundColor: tinta,
        titleTextStyle: texto.titleMedium?.copyWith(color: tinta),
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        shadowColor: tinta.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBordes.grande),
          side: BorderSide(color: borde, width: 0.8),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppEspaciado.md,
          vertical: AppEspaciado.md,
        ),
        prefixIconColor: secundario,
        suffixIconColor: secundario,
        labelStyle: texto.bodyMedium?.copyWith(color: secundario),
        floatingLabelStyle: texto.labelLarge?.copyWith(
          fontSize: 13,
          color: tinta,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: bordeCampo,
        enabledBorder: bordeCampo,
        disabledBorder: bordeCampo,
        focusedBorder: bordeCampo.copyWith(
          borderSide: BorderSide(color: primario, width: 1.5),
        ),
        hoverColor: suave.withValues(alpha: 0.55),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              backgroundColor: tinta,
              foregroundColor: sobreBoton,
              disabledBackgroundColor: borde,
              disabledForegroundColor: secundario,
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
                  return superficie.withValues(alpha: 0.16);
                }
                if (estados.contains(WidgetState.hovered) ||
                    estados.contains(WidgetState.focused)) {
                  return superficie.withValues(alpha: 0.09);
                }
                return Colors.transparent;
              }),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              backgroundColor: superficie,
              foregroundColor: tinta,
              minimumSize: const Size(48, 52),
              padding: const EdgeInsets.symmetric(
                horizontal: AppEspaciado.md,
                vertical: AppEspaciado.sm,
              ),
              side: BorderSide(color: borde),
              shape: formaBoton,
              textStyle: texto.labelLarge,
            ).copyWith(
              animationDuration: const Duration(milliseconds: 180),
              overlayColor: WidgetStateProperty.resolveWith((estados) {
                if (estados.contains(WidgetState.hovered) ||
                    estados.contains(WidgetState.focused) ||
                    estados.contains(WidgetState.pressed)) {
                  return primario.withValues(alpha: 0.055);
                }
                return Colors.transparent;
              }),
              side: WidgetStateProperty.resolveWith((estados) {
                return BorderSide(
                  color:
                      estados.contains(WidgetState.hovered) ||
                          estados.contains(WidgetState.focused)
                      ? primario.withValues(alpha: 0.45)
                      : borde,
                );
              }),
            ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primario,
          minimumSize: const Size(48, 48),
          shape: formaBoton,
          textStyle: texto.labelLarge,
        ),
      ),
      textSelectionTheme: base.textSelectionTheme.copyWith(
        cursorColor: tinta,
        selectionColor: AppColores.acento.withValues(alpha: 0.35),
        selectionHandleColor: tinta,
      ),
    );
  }

  /// La misma identidad del club con superficies oscuras y texto de alto contraste.
  static ThemeData _crearOscuro() {
    final base = claro;
    const fondo = Color(0xFF101A16);
    const superficie = Color(0xFF192720);
    const superficieSuave = Color(0xFF22332A);
    const textoSecundario = Color(0xFFB6C9BC);
    const borde = Color(0xFF3C5144);
    const esquema = ColorScheme.dark(
      primary: AppColores.acento,
      onPrimary: AppColores.accesoTinta,
      primaryContainer: Color(0xFF284B37),
      onPrimaryContainer: Color(0xFFDCF4DD),
      secondary: Color(0xFF99CEF1),
      onSecondary: Color(0xFF10354C),
      secondaryContainer: Color(0xFF25465A),
      onSecondaryContainer: Color(0xFFD4EDFF),
      tertiary: Color(0xFFA4DAB7),
      onTertiary: AppColores.accesoTinta,
      tertiaryContainer: Color(0xFF264D35),
      onTertiaryContainer: Color(0xFFCEF2D7),
      surface: superficie,
      onSurface: Color(0xFFECF3ED),
      onSurfaceVariant: textoSecundario,
      surfaceContainerLowest: fondo,
      surfaceContainerLow: superficieSuave,
      surfaceContainer: Color(0xFF293C30),
      surfaceContainerHigh: Color(0xFF314637),
      surfaceContainerHighest: Color(0xFF39503F),
      outline: Color(0xFF8FA496),
      outlineVariant: borde,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      inverseSurface: Color(0xFFECF3ED),
      onInverseSurface: AppColores.accesoTinta,
      inversePrimary: AppColores.primario,
      surfaceTint: AppColores.acento,
    );
    final texto = base.textTheme.apply(
      bodyColor: esquema.onSurface,
      displayColor: esquema.onSurface,
    );
    final bordeCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppBordes.medio),
      borderSide: const BorderSide(color: borde),
    );

    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: esquema,
      scaffoldBackgroundColor: fondo,
      canvasColor: superficie,
      cardColor: superficie,
      dividerColor: borde,
      disabledColor: textoSecundario.withValues(alpha: 0.5),
      hintColor: textoSecundario,
      hoverColor: esquema.primary.withValues(alpha: 0.06),
      focusColor: esquema.primary.withValues(alpha: 0.12),
      highlightColor: esquema.primary.withValues(alpha: 0.1),
      splashColor: esquema.primary.withValues(alpha: 0.12),
      textTheme: texto,
      primaryTextTheme: texto,
      iconTheme: IconThemeData(color: esquema.onSurfaceVariant),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: fondo,
        foregroundColor: esquema.onSurface,
        titleTextStyle: texto.titleLarge,
      ),
      cardTheme: base.cardTheme.copyWith(
        color: superficie,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBordes.grande),
          side: const BorderSide(color: borde),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: superficie,
        labelStyle: const TextStyle(color: textoSecundario),
        hintStyle: const TextStyle(color: textoSecundario),
        floatingLabelStyle: TextStyle(color: esquema.primary),
        prefixIconColor: textoSecundario,
        suffixIconColor: textoSecundario,
        errorStyle: TextStyle(color: esquema.error),
        border: bordeCampo,
        enabledBorder: bordeCampo,
        disabledBorder: bordeCampo,
        focusedBorder: bordeCampo.copyWith(
          borderSide: BorderSide(color: esquema.primary, width: 2),
        ),
        errorBorder: bordeCampo.copyWith(
          borderSide: BorderSide(color: esquema.error),
        ),
        focusedErrorBorder: bordeCampo.copyWith(
          borderSide: BorderSide(color: esquema.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: esquema.primary,
          foregroundColor: esquema.onPrimary,
          disabledBackgroundColor: borde,
          disabledForegroundColor: textoSecundario,
        ).merge(base.filledButtonTheme.style),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: esquema.primary,
          foregroundColor: esquema.onPrimary,
          disabledBackgroundColor: borde,
          disabledForegroundColor: textoSecundario,
        ).merge(base.elevatedButtonTheme.style),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: esquema.primary,
          disabledForegroundColor: textoSecundario,
          side: const BorderSide(color: borde),
        ).merge(base.outlinedButtonTheme.style),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: esquema.primary)
            .merge(base.textButtonTheme.style),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: superficie,
        selectedColor: esquema.primaryContainer,
        secondarySelectedColor: esquema.primaryContainer,
        disabledColor: borde,
        labelStyle: texto.labelLarge,
        secondaryLabelStyle: texto.labelLarge,
        checkmarkColor: esquema.primary,
        side: const BorderSide(color: borde),
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: superficie,
        indicatorColor: esquema.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((estados) {
          return texto.labelMedium?.copyWith(
            color: estados.contains(WidgetState.selected)
                ? esquema.primary
                : textoSecundario,
            fontWeight: FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((estados) {
          return IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? esquema.primary
                : textoSecundario,
          );
        }),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: superficie,
        selectedItemColor: esquema.primary,
        unselectedItemColor: textoSecundario,
      ),
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: esquema.primary,
        unselectedLabelColor: textoSecundario,
        indicatorColor: esquema.primary,
        dividerColor: borde,
        labelStyle: texto.labelLarge,
      ),
      dividerTheme: base.dividerTheme.copyWith(color: borde),
      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: esquema.inverseSurface,
        contentTextStyle: texto.bodyMedium?.copyWith(
          color: esquema.onInverseSurface,
        ),
        actionTextColor: esquema.inversePrimary,
      ),
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: superficie,
        titleTextStyle: texto.titleLarge,
        contentTextStyle: texto.bodyMedium,
      ),
      datePickerTheme: base.datePickerTheme.copyWith(
        backgroundColor: superficie,
        headerBackgroundColor: esquema.primaryContainer,
        headerForegroundColor: esquema.onPrimaryContainer,
      ),
      timePickerTheme: base.timePickerTheme.copyWith(
        backgroundColor: superficie,
        dialBackgroundColor: superficieSuave,
        dialHandColor: esquema.primary,
        dialTextColor: esquema.onSurface,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: esquema.primary,
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: esquema.primary,
        foregroundColor: esquema.onPrimary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: esquema.primary,
        selectionColor: esquema.primary.withValues(alpha: 0.3),
        selectionHandleColor: esquema.primary,
      ),
    );
  }

  static ThemeData _crearClaro() {
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
