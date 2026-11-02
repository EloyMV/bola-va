import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/theme/app_colores.dart';

/// Degradado compartido con símbolos suaves detrás del contenido de acceso.
class FondoAcceso extends StatelessWidget {
  const FondoAcceso({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColores.fondoAccesoProfundo,
                AppColores.primario,
                AppColores.secundario,
              ],
              stops: [0, 0.48, 1],
            ),
          ),
        ),
        Positioned(
          top: -70,
          right: -90,
          child: _SimboloFondo(
            tamano: 360,
            angulo: -0.35,
            color: AppColores.superficie.withValues(alpha: 0.15),
          ),
        ),
        Positioned(
          bottom: 24,
          left: -120,
          child: _SimboloFondo(
            tamano: 320,
            angulo: 0.5,
            color: AppColores.acento.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}

/// Se desenfoca solo el símbolo, manteniendo nítidos textos y formularios.
class _SimboloFondo extends StatelessWidget {
  const _SimboloFondo({
    required this.tamano,
    required this.angulo,
    required this.color,
  });

  final double tamano;
  final double angulo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Transform.rotate(
        angle: angulo,
        child: Icon(Icons.sports_tennis, size: tamano, color: color),
      ),
    );
  }
}
