import 'package:flutter/material.dart';

import '../../core/theme/app_bordes.dart';
import '../../core/theme/app_colores.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: AppColores.accesoSuave.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(AppBordes.medio),
        border: Border.all(color: AppColores.accesoBorde),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.science_outlined,
              size: 18,
              color: AppColores.accesoTextoSecundario,
            ),
            const SizedBox(width: AppEspaciado.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: tema.textTheme.labelLarge?.copyWith(
                      fontSize: 12,
                      color: AppColores.accesoTinta,
                    ),
                  ),
                  const SizedBox(height: AppEspaciado.xxs),
                  Text(
                    mensaje,
                    style: tema.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      height: 1.45,
                      color: AppColores.accesoTinta.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
