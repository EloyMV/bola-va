import 'package:flutter/material.dart';

/// Ajustes compartidos durante la ejecución de la aplicación.
/// ValueNotifier avisa a las pantallas cuando cambia uno de estos valores.
abstract final class AppPreferencias {
  static final tema = ValueNotifier<ThemeMode>(ThemeMode.light);
  static final avisosReservas = ValueNotifier<bool>(false);
  static final horarioFavorito = ValueNotifier<String>('Tarde');

  static const horariosFavoritos = ['Mañana', 'Tarde', 'Noche'];
}
