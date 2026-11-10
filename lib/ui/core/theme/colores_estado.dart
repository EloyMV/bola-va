import 'package:flutter/material.dart';

import 'app_colores.dart';
import 'app_preferencias.dart';

/// Colores comunes de disponibilidad y reservas; siempre se acompañan de texto.
abstract final class ColoresEstado {
  static Color disponible(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    if (AppPreferencias.apoyoDaltonismo.value) {
      return oscuro
          ? AppColores.disponibleDaltonismoOscuro
          : AppColores.disponibleDaltonismo;
    }
    return oscuro ? AppColores.exitoOscuro : AppColores.exito;
  }

  static Color pendiente(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    if (AppPreferencias.apoyoDaltonismo.value) {
      return oscuro
          ? AppColores.pendienteDaltonismoOscuro
          : AppColores.pendienteDaltonismo;
    }
    return oscuro ? AppColores.avisoOscuro : AppColores.aviso;
  }

  static Color cancelada(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    if (AppPreferencias.apoyoDaltonismo.value) {
      return esquema.brightness == Brightness.dark
          ? AppColores.canceladaDaltonismoOscuro
          : AppColores.canceladaDaltonismo;
    }
    return esquema.error;
  }

  static Color ocupado(BuildContext context) {
    final tema = Theme.of(context);
    return tema.brightness == Brightness.dark
        ? tema.colorScheme.onSurfaceVariant
        : AppColores.ocupado;
  }
}
