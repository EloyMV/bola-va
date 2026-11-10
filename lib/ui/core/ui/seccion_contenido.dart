import 'package:flutter/material.dart';

import '../theme/app_espaciado.dart';

/// Agrupa el contenido con el mismo margen, título y color en toda la app.
class SeccionContenido extends StatelessWidget {
  const SeccionContenido({
    super.key,
    required this.titulo,
    required this.icono,
    required this.child,
  });

  final String titulo;
  final IconData icono;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icono, color: tema.colorScheme.primary),
                const SizedBox(width: AppEspaciado.sm),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(titulo, style: tema.textTheme.titleLarge),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppEspaciado.md),
            child,
          ],
        ),
      ),
    );
  }
}
