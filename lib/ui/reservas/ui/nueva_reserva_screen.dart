import 'package:flutter/material.dart';

import '../../../domain/models/espacio.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Muestra el espacio elegido y conserva el tema compartido de la aplicación.
class NuevaReservaScreen extends StatelessWidget {
  const NuevaReservaScreen({super.key, this.espacio, this.contenido});

  final Espacio? espacio;
  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    final espacioActual = espacio;
    return PaginaBase(
      titulo: 'Nueva reserva',
      subtitulo: 'Haz sitio para tu próxima partida.',
      anchoMaximo: AppEspaciado.anchoFormulario,
      child:
          contenido ??
          (espacioActual == null
              ? const EstadoVacio(
                  icono: Icons.calendar_month_outlined,
                  titulo: 'Una nueva partida',
                  mensaje:
                      'Aquí aparecerán los detalles de tu próxima reserva.',
                )
              : _resumenEspacio(context, espacioActual)),
    );
  }

  Widget _resumenEspacio(BuildContext context, Espacio espacio) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Espacio seleccionado', style: tema.textTheme.titleMedium),
            const SizedBox(height: AppEspaciado.md),
            Text(espacio.nombre, style: tema.textTheme.titleLarge),
            const SizedBox(height: AppEspaciado.xs),
            Text(espacio.ubicacion, style: tema.textTheme.bodyMedium),
            const SizedBox(height: AppEspaciado.md),
            Text(
              'Aforo: ${espacio.capacidad} jugadores',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppEspaciado.xs),
            Text(
              'Tarifa: ${espacio.tarifaHora.toStringAsFixed(0)} €/hora',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppEspaciado.lg),
            Text(
              'La reserva es una demostración y todavía no se ha confirmado.',
              style: tema.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
