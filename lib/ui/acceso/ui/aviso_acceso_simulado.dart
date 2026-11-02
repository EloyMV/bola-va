import 'package:flutter/material.dart';

import '../../core/theme/app_bordes.dart';
import '../../core/theme/app_espaciado.dart';

/// Aviso compartido por login y registro, con un mensaje para cada pantalla.
class AvisoAccesoSimulado extends StatelessWidget {
  const AvisoAccesoSimulado({
    super.key,
    required this.titulo,
    required this.mensaje,
  });

  final String titulo;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      color: tema.colorScheme.primary.withValues(alpha: 0.06),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBordes.medio),
        side: BorderSide(
          color: tema.colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: tema.colorScheme.primary),
            const SizedBox(width: AppEspaciado.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: tema.textTheme.labelLarge?.copyWith(
                      color: tema.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppEspaciado.xxs),
                  Text(mensaje, style: tema.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
