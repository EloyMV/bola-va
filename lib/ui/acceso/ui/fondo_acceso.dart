import 'package:flutter/material.dart';

import '../../core/theme/app_colores.dart';

/// Luz ambiental suave sobre la superficie del tema elegido.
class FondoAcceso extends StatelessWidget {
  const FondoAcceso({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esOscuro = tema.brightness == Brightness.dark;
    final luzPrincipal = esOscuro
        ? tema.colorScheme.primary
        : AppColores.primario;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: tema.scaffoldBackgroundColor),
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
                  luzPrincipal.withValues(alpha: esOscuro ? 0.035 : 0.07),
                  luzPrincipal.withValues(alpha: 0),
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
                  AppColores.acento.withValues(alpha: esOscuro ? 0.04 : 0.13),
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
