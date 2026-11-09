import 'package:flutter/material.dart';

import '../../../domain/models/espacio.dart';
import '../../../domain/models/servicio_extra.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';
import 'mis_reservas_screen.dart';

/// Reserva de demostración: los horarios y asistentes son datos precargados.
class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({super.key, this.espacio, this.contenido});

  final Espacio? espacio;
  final Widget? contenido;

  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  static const String _fecha = 'Viernes, 13 de noviembre de 2026';
  static const String _horaInicio = '18:00';
  static const String _horaFin = '20:00';
  static const List<String> _asistentes = [
    'Alex García',
    'Lucía Martínez',
    'David Ruiz',
    'Tú',
  ];
  static const double _duracionHoras = 2;

  final Set<String> _extrasSeleccionados = {};

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
              : _formulario(context, espacioActual)),
    );
  }

  Widget _formulario(BuildContext context, Espacio espacio) {
    final incluidos = espacio.servicios
        .where((servicio) => servicio.precio == null)
        .toList();
    final extras = espacio.servicios
        .where((servicio) => servicio.precio != null)
        .toList();
    final subtotalAlquiler = espacio.tarifaHora * _duracionHoras;
    final subtotalExtras = _calcularSubtotalExtras(extras);
    final total = subtotalAlquiler + subtotalExtras;
    final tema = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _tarjeta(
          context,
          titulo: 'Espacio elegido',
          icono: Icons.sports_tennis_outlined,
          contenido: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(espacio.nombre, style: tema.textTheme.titleLarge),
              const SizedBox(height: AppEspaciado.xs),
              Text(espacio.ubicacion, style: tema.textTheme.bodyMedium),
              const SizedBox(height: AppEspaciado.xs),
              Text(
                'Capacidad: ${espacio.capacidad} jugadores',
                style: tema.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        _tarjeta(
          context,
          titulo: 'Datos de la reserva',
          icono: Icons.event_available_outlined,
          contenido: Column(
            children: [
              _dato(context, 'Actividad', 'Pádel'),
              _dato(context, 'Fecha', _fecha),
              _dato(context, 'Hora de inicio', _horaInicio),
              _dato(context, 'Hora de fin', _horaFin),
              _dato(context, 'Duración', '2 horas'),
              _dato(
                context,
                'Asistentes (${_asistentes.length}/${espacio.capacidad})',
                _asistentes.join(', '),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        _tarjeta(
          context,
          titulo: 'Incluido en el espacio',
          icono: Icons.check_circle_outline,
          contenido: incluidos.isEmpty
              ? Text(
                  'Este espacio no indica equipamiento incluido.',
                  style: tema.textTheme.bodyMedium,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final servicio in incluidos)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppEspaciado.xs),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 18,
                              color: tema.colorScheme.primary,
                            ),
                            const SizedBox(width: AppEspaciado.xs),
                            Expanded(
                              child: Text(
                                servicio.nombre,
                                style: tema.textTheme.bodyMedium,
                              ),
                            ),
                            Text('Incluido', style: tema.textTheme.labelMedium),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: AppEspaciado.md),
        _tarjeta(
          context,
          titulo: 'Extras de esta pista',
          icono: Icons.add_circle_outline,
          contenido: extras.isEmpty
              ? Text(
                  'Este espacio no tiene extras de pago.',
                  style: tema.textTheme.bodyMedium,
                )
              : Column(
                  children: [
                    for (final extra in extras)
                      MergeSemantics(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppEspaciado.xs,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                key: ValueKey<String>(
                                  'extra-${espacio.id}-${extra.nombre}',
                                ),
                                value: _extrasSeleccionados.contains(
                                  extra.nombre,
                                ),
                                onChanged: (seleccionado) {
                                  setState(() {
                                    if (seleccionado ?? false) {
                                      _extrasSeleccionados.add(extra.nombre);
                                    } else {
                                      _extrasSeleccionados.remove(extra.nombre);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: AppEspaciado.xs),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      extra.nombre,
                                      style: tema.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      '${_formatearPrecio(extra.precio!)} € por reserva',
                                      style: tema.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: AppEspaciado.md),
        _tarjeta(
          context,
          titulo: 'Desglose del precio',
          icono: Icons.receipt_long_outlined,
          contenido: Column(
            children: [
              _lineaPrecio(context, 'Duración', '2 horas'),
              _lineaPrecio(
                context,
                'Tarifa por hora',
                '${_formatearPrecio(espacio.tarifaHora)} €/hora',
              ),
              _lineaPrecio(
                context,
                'Subtotal alquiler',
                '${_formatearPrecio(subtotalAlquiler)} €',
              ),
              _lineaPrecio(
                context,
                'Subtotal extras',
                '${_formatearPrecio(subtotalExtras)} €',
              ),
              const Divider(height: AppEspaciado.lg),
              _lineaPrecio(
                context,
                'Total por reserva',
                '${_formatearPrecio(total)} €',
                destacado: true,
              ),
              const SizedBox(height: AppEspaciado.xs),
              Text(
                'Tarifa × duración + extras. Los extras se cobran una vez '
                'por reserva.',
                style: tema.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        FilledButton.icon(
          onPressed: () => _mostrarConfirmacion(
            context,
            espacio: espacio,
            extras: extras
                .where((extra) => _extrasSeleccionados.contains(extra.nombre))
                .toList(),
            subtotalAlquiler: subtotalAlquiler,
            subtotalExtras: subtotalExtras,
            total: total,
          ),
          icon: const Icon(Icons.event_available_outlined),
          label: const Text('Confirmar reserva'),
        ),
        const SizedBox(height: AppEspaciado.xs),
        Text(
          'Es una reserva de prueba: no se guarda. Mis reservas contiene '
          'solo ejemplos precargados.',
          textAlign: TextAlign.center,
          style: tema.textTheme.bodySmall,
        ),
      ],
    );
  }

  double _calcularSubtotalExtras(List<ServicioExtra> extras) {
    return extras
        .where((extra) => _extrasSeleccionados.contains(extra.nombre))
        .fold(0, (total, extra) => total + extra.precio!);
  }

  Widget _tarjeta(
    BuildContext context, {
    required String titulo,
    required IconData icono,
    required Widget contenido,
  }) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icono, color: tema.colorScheme.primary),
                const SizedBox(width: AppEspaciado.xs),
                Expanded(
                  child: Text(titulo, style: tema.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: AppEspaciado.md),
            contenido,
          ],
        ),
      ),
    );
  }

  Widget _dato(BuildContext context, String etiqueta, String valor) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(etiqueta, style: tema.textTheme.labelLarge),
          Text(valor, style: tema.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _lineaPrecio(
    BuildContext context,
    String etiqueta,
    String precio, {
    bool destacado = false,
  }) {
    final tema = Theme.of(context);
    final estilo = destacado
        ? tema.textTheme.titleMedium
        : tema.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppEspaciado.xxs),
      child: Row(
        children: [
          Expanded(child: Text(etiqueta, style: estilo)),
          const SizedBox(width: AppEspaciado.xs),
          Flexible(
            child: Text(precio, textAlign: TextAlign.end, style: estilo),
          ),
        ],
      ),
    );
  }

  void _mostrarConfirmacion(
    BuildContext context, {
    required Espacio espacio,
    required List<ServicioExtra> extras,
    required double subtotalAlquiler,
    required double subtotalExtras,
    required double total,
  }) {
    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (context) => ConfirmacionReservaScreen(
          espacio: espacio,
          extras: List<ServicioExtra>.unmodifiable(extras),
          fecha: _fecha,
          horaInicio: _horaInicio,
          horaFin: _horaFin,
          asistentes: _asistentes,
          duracionHoras: _duracionHoras,
          subtotalAlquiler: subtotalAlquiler,
          subtotalExtras: subtotalExtras,
          total: total,
        ),
      ),
    );
  }

  String _formatearPrecio(double precio) =>
      precio.toStringAsFixed(2).replaceAll('.', ',');
}

class ConfirmacionReservaScreen extends StatelessWidget {
  const ConfirmacionReservaScreen({
    super.key,
    required this.espacio,
    required this.extras,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.asistentes,
    required this.duracionHoras,
    required this.subtotalAlquiler,
    required this.subtotalExtras,
    required this.total,
  });

  final Espacio espacio;
  final List<ServicioExtra> extras;
  final String fecha;
  final String horaInicio;
  final String horaFin;
  final List<String> asistentes;
  final double duracionHoras;
  final double subtotalAlquiler;
  final double subtotalExtras;
  final double total;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final textoExtras = extras.isEmpty
        ? 'Ninguno'
        : extras.map((extra) => extra.nombre).join(', ');

    return PaginaBase(
      titulo: 'Reserva de prueba',
      subtitulo: 'Resumen de la reserva. No se ha guardado ningún dato.',
      anchoMaximo: AppEspaciado.anchoFormulario,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppEspaciado.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(espacio.nombre, style: tema.textTheme.titleLarge),
                  const SizedBox(height: AppEspaciado.xs),
                  _dato(context, 'Actividad', 'Pádel'),
                  _dato(context, 'Fecha', fecha),
                  _dato(context, 'Hora de inicio', horaInicio),
                  _dato(context, 'Hora de fin', horaFin),
                  _dato(
                    context,
                    'Asistentes (${asistentes.length}/${espacio.capacidad})',
                    asistentes.join(', '),
                  ),
                  _dato(context, 'Extras', textoExtras),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppEspaciado.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppEspaciado.md),
              child: Column(
                children: [
                  _filaPrecio(
                    context,
                    'Duración',
                    '${_formatearPrecio(duracionHoras)} horas',
                  ),
                  _filaPrecio(
                    context,
                    'Tarifa por hora',
                    '${_formatearPrecio(espacio.tarifaHora)} €/hora',
                  ),
                  _filaPrecio(
                    context,
                    'Subtotal alquiler',
                    '${_formatearPrecio(subtotalAlquiler)} €',
                  ),
                  _filaPrecio(
                    context,
                    'Subtotal extras',
                    '${_formatearPrecio(subtotalExtras)} €',
                  ),
                  const Divider(height: AppEspaciado.lg),
                  _filaPrecio(
                    context,
                    'Total por reserva',
                    '${_formatearPrecio(total)} €',
                    destacado: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppEspaciado.md),
          Text(
            'Reserva de prueba: no se guarda ni altera los ejemplos. Mis '
            'reservas muestra datos precargados.',
            style: tema.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppEspaciado.md),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const MisReservasScreen(),
              ),
            ),
            icon: const Icon(Icons.event_note_outlined),
            label: const Text('Mis reservas'),
          ),
        ],
      ),
    );
  }

  Widget _dato(BuildContext context, String etiqueta, String valor) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppEspaciado.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta, style: tema.textTheme.labelLarge),
          Text(valor, style: tema.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _filaPrecio(
    BuildContext context,
    String etiqueta,
    String precio, {
    bool destacado = false,
  }) {
    final tema = Theme.of(context);
    final estilo = destacado
        ? tema.textTheme.titleMedium
        : tema.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppEspaciado.xxs),
      child: Row(
        children: [
          Expanded(child: Text(etiqueta, style: estilo)),
          const SizedBox(width: AppEspaciado.xs),
          Flexible(
            child: Text(precio, textAlign: TextAlign.end, style: estilo),
          ),
        ],
      ),
    );
  }

  String _formatearPrecio(double precio) =>
      precio.toStringAsFixed(2).replaceAll('.', ',');
}
