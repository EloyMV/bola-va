import 'package:flutter/material.dart';

import '../theme/app_espaciado.dart';

/// Presentación compartida para listas vacías y secciones pendientes de datos.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    required this.mensaje,
  });

  final IconData icono;
  final String titulo;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppEspaciado.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppEspaciado.md),
              decoration: BoxDecoration(
                color: tema.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icono,
                size: AppEspaciado.xxl,
                color: tema.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppEspaciado.md),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: tema.textTheme.titleLarge,
            ),
            const SizedBox(height: AppEspaciado.xs),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
