import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';

/// Tarjeta común para agrupar las preferencias y la información del proyecto.
class SeccionPerfil extends StatelessWidget {
  const SeccionPerfil({
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icono, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppEspaciado.sm),
                Expanded(
                  child: Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleLarge,
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
