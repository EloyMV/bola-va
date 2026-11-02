import 'package:flutter/material.dart';

/// Separaciones y anchos comunes para móvil, tableta y escritorio.
abstract final class AppEspaciado {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double anchoFormulario = 440;
  static const double anchoContenido = 1100;

  static const EdgeInsets pagina = EdgeInsets.all(lg);
}
