import 'package:flutter/material.dart';

import '../../core/theme/app_colores.dart';

/// Luz ambiental suave sobre un fondo marfil; el formulario conserva el contraste.
class FondoAcceso extends StatelessWidget {
  const FondoAcceso({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColores.accesoFondo),
        Positioned(
          top: -220,
          right: -180,
          child: Container(
            width: 640,
            height: 640,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColores.primario.withValues(alpha: 0.07),
                  AppColores.primario.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -220,
          left: -200,
          child: Container(
            width: 560,
            height: 560,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColores.acento.withValues(alpha: 0.13),
                  AppColores.acento.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
