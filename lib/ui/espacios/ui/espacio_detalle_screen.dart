import 'package:flutter/material.dart';

import '../../../domain/models/espacio.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/espacio_tarjeta.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

class EspacioDetalleScreen extends StatelessWidget {
  const EspacioDetalleScreen({super.key, this.espacio, this.contenido});

  final Espacio? espacio;
  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Detalle de la pista',
      subtitulo: espacio?.nombre ?? 'Conoce el lugar de tu próxima partida.',
      child: contenido ?? _contenidoEspacio(context),
    );
  }

  Widget _contenidoEspacio(BuildContext context) {
    final espacioActual = espacio;
    if (espacioActual == null) {
      return const EstadoVacio(
        icono: Icons.info_outline,
        titulo: 'Información de la pista',
        mensaje: 'Aquí encontrarás sus características y servicios.',
      );
    }

    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EspacioImagen(
          imagenUrl: espacioActual.imagenUrl,
          etiqueta: espacioActual.nombre,
          altura: 240,
        ),
        const SizedBox(height: AppEspaciado.lg),
        Text(espacioActual.nombre, style: tema.textTheme.headlineSmall),
        const SizedBox(height: AppEspaciado.xs),
        Text(espacioActual.ubicacion, style: tema.textTheme.bodyLarge),
        const SizedBox(height: AppEspaciado.md),
        Text(
          'Capacidad: ${espacioActual.capacidad} jugadores',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: AppEspaciado.md),
        Text(espacioActual.descripcion, style: tema.textTheme.bodyLarge),
        const SizedBox(height: AppEspaciado.md),
        Text('Actividades', style: tema.textTheme.titleMedium),
        const SizedBox(height: AppEspaciado.xs),
        Wrap(
          spacing: AppEspaciado.xs,
          runSpacing: AppEspaciado.xs,
          children: [
            for (final actividad in espacioActual.actividades)
              Chip(label: Text(actividad)),
          ],
        ),
      ],
    );
  }
}
