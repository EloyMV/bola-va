import 'package:flutter/material.dart';

/// Ajustes compartidos durante la ejecución de la aplicación.
/// ValueNotifier avisa a las pantallas cuando cambia uno de estos valores.
abstract final class AppPreferencias {
  static final tema = ValueNotifier<ThemeMode>(ThemeMode.light);
  static final avisosReservas = ValueNotifier<bool>(false);
  static final horarioFavorito = ValueNotifier<String>('Tarde');
  static final escalaTexto = ValueNotifier<double>(1);
  static final apoyoDaltonismo = ValueNotifier<bool>(false);
  static final reducirEfectos = ValueNotifier<bool>(false);

  // El tema solo necesita reconstruirse al cambiar estas preferencias visuales.
  static final apariencia = Listenable.merge([
    tema,
    apoyoDaltonismo,
    reducirEfectos,
  ]);
  static final accesibilidad = Listenable.merge([escalaTexto, reducirEfectos]);

  static const horariosFavoritos = ['Mañana', 'Tarde', 'Noche'];
}
