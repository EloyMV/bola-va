import 'package:flutter/material.dart';

import '../theme/app_colores.dart';
import '../theme/app_espaciado.dart';

/// Tarjeta visual de una pista. Recibe textos y una acción desde la pantalla.
class EspacioTarjeta extends StatelessWidget {
  const EspacioTarjeta({
    super.key,
    required this.nombre,
    required this.ubicacion,
    required this.precio,
    this.detalle,
    this.disponible = true,
    this.onTap,
  });

  final String nombre;
  final String ubicacion;
  final String precio;
  final String? detalle;
  final bool disponible;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colorEstado = disponible ? AppColores.exito : AppColores.ocupado;

    return Semantics(
      container: true,
      button: onTap != null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppEspaciado.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.sports_tennis, color: tema.colorScheme.primary),
                    const SizedBox(width: AppEspaciado.sm),
                    Expanded(
                      child: Text(nombre, style: tema.textTheme.titleLarge),
                    ),
                  ],
                ),
                const SizedBox(height: AppEspaciado.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppEspaciado.xs),
                    Expanded(
                      child: Text(ubicacion, style: tema.textTheme.bodyMedium),
                    ),
                  ],
                ),
                if (detalle != null) ...[
                  const SizedBox(height: AppEspaciado.sm),
                  Text(detalle!, style: tema.textTheme.bodyMedium),
                ],
                const SizedBox(height: AppEspaciado.md),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppEspaciado.md,
                  runSpacing: AppEspaciado.xs,
                  children: [
                    Text(
                      precio,
                      style: tema.textTheme.titleMedium?.copyWith(
                        color: tema.colorScheme.primary,
                      ),
                    ),
                    Chip(
                      avatar: Icon(
                        disponible ? Icons.check_circle_outline : Icons.block,
                        size: 18,
                        color: colorEstado,
                      ),
                      label: Text(disponible ? 'Disponible' : 'Ocupado'),
                      labelStyle: tema.textTheme.labelMedium?.copyWith(
                        color: colorEstado,
                      ),
                      backgroundColor: tema.colorScheme.surface,
                      side: BorderSide(color: colorEstado),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
