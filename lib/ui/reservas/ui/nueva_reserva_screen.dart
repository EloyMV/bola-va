import 'package:flutter/material.dart';

import '../../../domain/models/espacio.dart';
import '../../../domain/models/servicio_extra.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';
import 'mis_reservas_screen.dart';

/// Reserva de demostración con disponibilidad precargada.
class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({super.key, this.espacio, this.contenido});

  final Espacio? espacio;
  final Widget? contenido;

  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  static final List<DateTime> _fechasDisponibles = [
    DateTime(2026, 11, 13),
    DateTime(2026, 11, 14),
    DateTime(2026, 11, 16),
  ];
  static const List<String> _horasDisponibles = [
    '10:00',
    '12:00',
    '14:00',
    '16:00',
    '18:00',
  ];
  static const List<String> _nombresAsistentes = [
    'Alex García',
    'Lucía Martínez',
    'David Ruiz',
    'Tú',
  ];
  static const double _duracionHoras = 2;

  final Set<String> _extrasSeleccionados = {};
  late DateTime _fechaSeleccionada;
  String _horaInicioSeleccionada = '18:00';
  late int _numeroAsistentes;

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = _fechasDisponibles.first;
    final capacidad = widget.espacio?.capacidad ?? _nombresAsistentes.length;
    _numeroAsistentes = capacidad < _nombresAsistentes.length
        ? capacidad
        : _nombresAsistentes.length;
    if (_numeroAsistentes < 1) {
      _numeroAsistentes = 1;
    }
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
    final horaFin = _calcularHoraFin(_horaInicioSeleccionada);
    final asistentes = _obtenerAsistentes();
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
              Padding(
                padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
                child: DropdownButtonFormField<DateTime>(
                  key: const ValueKey<String>('selector-fecha-reserva'),
                  initialValue: _fechaSeleccionada,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha disponible',
                  ),
                  items: [
                    for (final fecha in _fechasDisponibles)
                      DropdownMenuItem<DateTime>(
                        value: fecha,
                        child: Text(_formatearFechaCorta(fecha)),
                      ),
                  ],
                  onChanged: (fecha) {
                    if (fecha != null) {
                      setState(() => _fechaSeleccionada = fecha);
                    }
                  },
                ),
              ),
              _dato(context, 'Fecha', _formatearFecha(_fechaSeleccionada)),
              Padding(
                padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Hora de inicio · turnos de 2 horas',
                      style: tema.textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppEspaciado.xxs),
                    Text(
                      'Turnos disponibles de demostración',
                      style: tema.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppEspaciado.xs),
                    Wrap(
                      spacing: AppEspaciado.xs,
                      runSpacing: AppEspaciado.xs,
                      children: [
                        for (final hora in _horasDisponibles)
                          ChoiceChip(
                            key: ValueKey<String>('horario-$hora'),
                            label: Text(hora),
                            selected: _horaInicioSeleccionada == hora,
                            onSelected: (seleccionado) {
                              if (seleccionado) {
                                setState(() => _horaInicioSeleccionada = hora);
                              }
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              _dato(context, 'Hora de inicio', _horaInicioSeleccionada),
              _dato(context, 'Hora de fin', horaFin),
              _dato(
                context,
                'Duración',
                '${_formatearPrecio(_duracionHoras)} horas',
              ),
              _dato(
                context,
                'Asistentes ($_numeroAsistentes/${espacio.capacidad})',
                asistentes.join(', '),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppEspaciado.xs),
                child: DropdownButtonFormField<int>(
                  key: const ValueKey<String>('selector-personas-reserva'),
                  initialValue: _numeroAsistentes,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Número de personas',
                  ),
                  items: [
                    for (
                      var cantidad = 1;
                      cantidad <= espacio.capacidad;
                      cantidad++
                    )
                      DropdownMenuItem<int>(
                        value: cantidad,
                        child: Text(
                          '$cantidad ${cantidad == 1 ? 'persona' : 'personas'}',
                        ),
                      ),
                  ],
                  onChanged: (cantidad) {
                    if (cantidad != null) {
                      setState(() => _numeroAsistentes = cantidad);
                    }
                  },
                ),
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
              _lineaPrecio(
                context,
                'Duración',
                '${_formatearPrecio(_duracionHoras)} horas',
              ),
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
            fecha: _formatearFecha(_fechaSeleccionada),
            horaInicio: _horaInicioSeleccionada,
            horaFin: horaFin,
            asistentes: asistentes,
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

  List<String> _obtenerAsistentes() {
    return List<String>.generate(_numeroAsistentes, (indice) {
      if (indice < _nombresAsistentes.length) {
        return _nombresAsistentes[indice];
      }
      return 'Jugador ${indice + 1}';
    });
  }

  String _calcularHoraFin(String horaInicio) {
    final partes = horaInicio.split(':');
    final minutosTotales =
        int.parse(partes[0]) * 60 +
        int.parse(partes[1]) +
        (_duracionHoras * 60).round();
    final hora = (minutosTotales ~/ 60).toString().padLeft(2, '0');
    final minutos = (minutosTotales % 60).toString().padLeft(2, '0');
    return '$hora:$minutos';
  }

  static String _formatearFecha(DateTime fecha) {
    const dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final dia = dias[fecha.weekday - 1];
    final mes = meses[fecha.month - 1];
    return '${dia[0].toUpperCase()}${dia.substring(1)}, '
        '${fecha.day} de $mes de ${fecha.year}';
  }

  static String _formatearFechaCorta(DateTime fecha) {
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
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
    required String fecha,
    required String horaInicio,
    required String horaFin,
    required List<String> asistentes,
  }) {
    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (context) => ConfirmacionReservaScreen(
          espacio: espacio,
          extras: List<ServicioExtra>.unmodifiable(extras),
          fecha: fecha,
          horaInicio: horaInicio,
          horaFin: horaFin,
          asistentes: List<String>.unmodifiable(asistentes),
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
