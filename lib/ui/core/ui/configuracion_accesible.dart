import 'package:flutter/material.dart';

import '../theme/app_preferencias.dart';

/// Aplica los ajustes de la app sin reemplazar los ajustes del dispositivo.
class ConfiguracionAccesible extends StatelessWidget {
  const ConfiguracionAccesible({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppPreferencias.accesibilidad,
      child: child,
      builder: (context, contenido) {
        final sistema = MediaQuery.of(context);
        return MediaQuery(
          data: sistema.copyWith(
            textScaler: _EscalaDeTexto(
              sistema.textScaler,
              AppPreferencias.escalaTexto.value,
            ),
            disableAnimations:
                sistema.disableAnimations ||
                AppPreferencias.reducirEfectos.value,
          ),
          child: contenido!,
        );
      },
    );
  }
}

class _EscalaDeTexto extends TextScaler {
  const _EscalaDeTexto(this.escaladorBase, this.escalaPreferida);

  final TextScaler escaladorBase;
  final double escalaPreferida;

  @override
  double scale(double fontSize) =>
      escaladorBase.scale(fontSize) * escalaPreferida;

  @override
  double get textScaleFactor => escaladorBase.scale(14) / 14 * escalaPreferida;

  @override
  bool operator ==(Object other) =>
      other is _EscalaDeTexto &&
      other.escaladorBase == escaladorBase &&
      other.escalaPreferida == escalaPreferida;

  @override
  int get hashCode => Object.hash(escaladorBase, escalaPreferida);
}
