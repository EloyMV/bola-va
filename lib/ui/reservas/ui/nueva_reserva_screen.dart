import 'package:flutter/material.dart';

import '../../../domain/models/espacio.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/theme/app_preferencias.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Muestra el espacio elegido y conserva el tema compartido de la aplicación.
class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({super.key, this.espacio, this.contenido});

  final Espacio? espacio;
  final Widget? contenido;

  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  late String _horario;

  @override
  void initState() {
    super.initState();
    _horario = AppPreferencias.horarioFavorito.value;
  }

  @override
  Widget build(BuildContext context) {
    final espacioActual = widget.espacio;
    return PaginaBase(
      titulo: 'Nueva reserva',
      subtitulo: 'Haz sitio para tu próxima partida.',
      anchoMaximo: AppEspaciado.anchoFormulario,
      child:
          widget.contenido ??
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
            DropdownButtonFormField<String>(
              initialValue: _horario,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Horario de juego',
                prefixIcon: Icon(Icons.schedule_outlined),
              ),
              items: [
                for (final horario in AppPreferencias.horariosFavoritos)
                  DropdownMenuItem(value: horario, child: Text(horario)),
              ],
              onChanged: (horario) {
                if (horario != null) setState(() => _horario = horario);
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: AppPreferencias.avisosReservas,
              builder: (context, avisos, child) {
                if (!avisos) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: AppEspaciado.md),
                  child: Card(
                    key: const Key('aviso-reserva'),
                    color: tema.colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(AppEspaciado.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: tema.colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(width: AppEspaciado.sm),
                          Expanded(
                            child: Text(
                              'Comprueba el horario y las condiciones antes de reservar.',
                              style: tema.textTheme.bodyMedium?.copyWith(
                                color: tema.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
