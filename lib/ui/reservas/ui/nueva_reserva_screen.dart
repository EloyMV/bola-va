import 'package:flutter/material.dart';

import '../../../data/repositories/disponibilidad_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/services/datos_demo.dart';
import '../../../domain/models/disponibilidad_dia.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/franja_disponibilidad.dart';
import '../../../domain/models/servicio_extra.dart';
import '../../core/formatters/formatos.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/theme/app_preferencias.dart';
import '../../core/ui/dato_etiqueta.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/linea_precio.dart';
import '../../core/ui/pagina_base.dart';
import '../../core/ui/seccion_contenido.dart';
import 'confirmacion_reserva_screen.dart';

export 'confirmacion_reserva_screen.dart';

class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({
    super.key,
    this.espacio,
    this.contenido,
    this.fechaActual,
  });

  final Espacio? espacio;
  final Widget? contenido;
  final DateTime? fechaActual;

  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  final Set<String> _extrasSeleccionados = {};
  late final DateTime _referencia;
  late DateTime _fechaSeleccionada;
  late String _horario;
  late int _numeroAsistentes;
  FranjaDisponibilidad? _turnoSeleccionado;
  bool _confirmando = false;

  @override
  void initState() {
    super.initState();
    _referencia = widget.fechaActual ?? DateTime.now();
    _fechaSeleccionada = DateTime(
      _referencia.year,
      _referencia.month,
      _referencia.day,
    );
    _horario = AppPreferencias.horarioFavorito.value;
    _numeroAsistentes = (widget.espacio?.capacidad ?? 4).clamp(1, 4);
    for (final dia in _disponibilidad()) {
      if (_turnosLibres(dia).isNotEmpty) {
        _fechaSeleccionada = dia.fecha;
        break;
      }
    }
    _seleccionarTurno();
  }

  List<DisponibilidadDia> _disponibilidad() =>
      DisponibilidadRepository.disponibilidadSemana(
        widget.espacio?.id ?? '',
        referencia: _referencia,
      );

  List<FranjaDisponibilidad> _turnosLibres(DisponibilidadDia dia) => [
    for (final turno in dia.franjas)
      if (turno.libre &&
          !_fechaHora(
            dia.fecha,
            turno.horaInicio,
          ).isBefore(widget.fechaActual ?? DateTime.now()))
        turno,
  ];

  void _seleccionarTurno() {
    final dia = _disponibilidad().firstWhere(
      (dia) => dia.fecha == _fechaSeleccionada,
    );
    final turnos = _turnosLibres(dia);
    final preferidos = turnos.where(
      (turno) => _periodoParaHora(turno.horaInicio) == _horario,
    );
    _turnoSeleccionado = preferidos.isNotEmpty
        ? preferidos.first
        : (turnos.isEmpty ? null : turnos.first);
  }

  @override
  Widget build(BuildContext context) => PaginaBase(
    titulo: 'Nueva reserva',
    subtitulo: 'Haz sitio para tu próxima partida.',
    anchoMaximo: AppEspaciado.anchoFormulario,
    child:
        widget.contenido ??
        (widget.espacio == null
            ? const EstadoVacio(
                icono: Icons.calendar_month_outlined,
                titulo: 'Elige una pista',
                mensaje:
                    'Abre un espacio para consultar sus turnos y reservar.',
              )
            : _formulario(context, widget.espacio!)),
  );

  Widget _formulario(BuildContext context, Espacio espacio) {
    final tema = Theme.of(context);
    final dias = _disponibilidad();
    final dia = dias.firstWhere((dia) => dia.fecha == _fechaSeleccionada);
    final libres = _turnosLibres(dia);
    final incluidos = espacio.servicios.where(
      (servicio) => servicio.precio == null,
    );
    final extras = espacio.servicios
        .where((servicio) => servicio.precio != null)
        .toList();
    final asistentes = _asistentes();
    final subtotalAlquiler = espacio.tarifaHora * 2;
    final subtotalExtras = extras
        .where((extra) => _extrasSeleccionados.contains(extra.nombre))
        .fold<double>(0, (suma, extra) => suma + extra.precio!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SeccionContenido(
          titulo: 'Espacio elegido',
          icono: Icons.sports_tennis_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(espacio.nombre, style: tema.textTheme.titleLarge),
              const SizedBox(height: AppEspaciado.xs),
              Text(espacio.ubicacion),
              Text('Capacidad: ${espacio.capacidad} jugadores'),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        SeccionContenido(
          titulo: 'Datos de la reserva',
          icono: Icons.event_available_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DatoEtiqueta(etiqueta: 'Actividad', valor: 'Pádel'),
              DropdownButtonFormField<String>(
                key: ValueKey('selector-periodo-$_horario'),
                initialValue: _horario,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Periodo preferido',
                ),
                items: [
                  for (final horario in AppPreferencias.horariosFavoritos)
                    DropdownMenuItem(value: horario, child: Text(horario)),
                ],
                onChanged: (horario) {
                  if (horario == null) {
                    return;
                  }
                  setState(() {
                    _horario = horario;
                    _seleccionarTurno();
                  });
                },
              ),
              const SizedBox(height: AppEspaciado.sm),
              DropdownButtonFormField<DateTime>(
                key: const ValueKey('selector-fecha-reserva'),
                initialValue: _fechaSeleccionada,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha disponible',
                ),
                items: [
                  for (final dia in dias)
                    DropdownMenuItem(
                      value: dia.fecha,
                      child: Text(formatearFechaCorta(dia.fecha)),
                    ),
                ],
                onChanged: (fecha) {
                  if (fecha == null) {
                    return;
                  }
                  setState(() {
                    _fechaSeleccionada = fecha;
                    _seleccionarTurno();
                  });
                },
              ),
              const SizedBox(height: AppEspaciado.sm),
              DatoEtiqueta(
                etiqueta: 'Fecha',
                valor: formatearFecha(_fechaSeleccionada),
              ),
              Text(
                'Hora de inicio · turnos de 2 horas',
                style: tema.textTheme.labelLarge,
              ),
              const SizedBox(height: AppEspaciado.xs),
              Wrap(
                spacing: AppEspaciado.xs,
                runSpacing: AppEspaciado.xs,
                children: [
                  for (final turno in dia.franjas)
                    ChoiceChip(
                      key: ValueKey('horario-${turno.horaInicio}'),
                      label: Text(turno.horaInicio),
                      tooltip: libres.contains(turno)
                          ? 'Turno disponible'
                          : 'Turno no disponible',
                      selected:
                          _turnoSeleccionado?.horaInicio == turno.horaInicio,
                      onSelected: !libres.contains(turno)
                          ? null
                          : (elegido) {
                              if (!elegido) {
                                return;
                              }
                              setState(() {
                                _turnoSeleccionado = turno;
                                _horario = _periodoParaHora(turno.horaInicio);
                              });
                            },
                    ),
                ],
              ),
              const SizedBox(height: AppEspaciado.sm),
              if (_turnoSeleccionado case final turno?) ...[
                DatoEtiqueta(
                  etiqueta: 'Hora de inicio',
                  valor: turno.horaInicio,
                ),
                DatoEtiqueta(etiqueta: 'Hora de fin', valor: turno.horaFin),
              ] else
                const Text(
                  'No quedan turnos libres para esta fecha. Elige otro día.',
                ),
              const DatoEtiqueta(etiqueta: 'Duración', valor: '2 horas'),
              DatoEtiqueta(
                etiqueta:
                    'Asistentes ($_numeroAsistentes/${espacio.capacidad})',
                valor: asistentes.join(', '),
              ),
              DropdownButtonFormField<int>(
                key: const ValueKey('selector-personas-reserva'),
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
                    DropdownMenuItem(
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
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        ValueListenableBuilder<bool>(
          valueListenable: AppPreferencias.avisosReservas,
          builder: (context, avisos, child) => !avisos
              ? const SizedBox.shrink()
              : Card(
                  key: const Key('aviso-reserva'),
                  color: tema.colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(AppEspaciado.md),
                    child: Text(
                      'Comprueba el horario y las condiciones antes de reservar.',
                      style: TextStyle(
                        color: tema.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
        ),
        SeccionContenido(
          titulo: 'Incluido en el espacio',
          icono: Icons.check_circle_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (incluidos.isEmpty)
                const Text('No se indica equipamiento incluido.'),
              for (final servicio in incluidos)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppEspaciado.xs),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: tema.colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: AppEspaciado.xs),
                      Expanded(child: Text(servicio.nombre)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        SeccionContenido(
          titulo: 'Extras de esta pista',
          icono: Icons.add_circle_outline,
          child: Column(
            children: [
              if (extras.isEmpty)
                const Text('Este espacio no tiene extras de pago.'),
              for (final extra in extras)
                CheckboxListTile(
                  key: ValueKey('extra-${espacio.id}-${extra.nombre}'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(extra.nombre),
                  subtitle: Text(
                    '${formatearPrecio(extra.precio!)} € por reserva',
                  ),
                  value: _extrasSeleccionados.contains(extra.nombre),
                  onChanged: (elegido) => setState(() {
                    if (elegido ?? false) {
                      _extrasSeleccionados.add(extra.nombre);
                    } else {
                      _extrasSeleccionados.remove(extra.nombre);
                    }
                  }),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        SeccionContenido(
          titulo: 'Desglose del precio',
          icono: Icons.receipt_long_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DatoEtiqueta(etiqueta: 'Duración', valor: '2 horas'),
              DatoEtiqueta(
                etiqueta: 'Tarifa por hora',
                valor: '${formatearPrecio(espacio.tarifaHora)} €/hora',
              ),
              LineaPrecio(
                etiqueta: 'Subtotal alquiler',
                importe: subtotalAlquiler,
              ),
              LineaPrecio(etiqueta: 'Subtotal extras', importe: subtotalExtras),
              const Divider(height: AppEspaciado.lg),
              LineaPrecio(
                etiqueta: 'Total por reserva',
                importe: subtotalAlquiler + subtotalExtras,
                total: true,
              ),
              const SizedBox(height: AppEspaciado.xs),
              const Text(
                'Tarifa × duración + extras. Los extras se cobran una vez por reserva.',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        FilledButton.icon(
          onPressed: _confirmando || _turnoSeleccionado == null
              ? null
              : () => _confirmar(espacio, extras),
          icon: const Icon(Icons.event_available_outlined),
          label: const Text('Confirmar reserva'),
        ),
      ],
    );
  }

  void _confirmar(Espacio espacio, List<ServicioExtra> extras) {
    if (_confirmando || _turnoSeleccionado == null) {
      return;
    }
    final turno = _turnoSeleccionado!;
    final reserva = ReservasRepository.crear(
      espacio: espacio,
      inicio: _fechaHora(_fechaSeleccionada, turno.horaInicio),
      fin: _fechaHora(_fechaSeleccionada, turno.horaFin),
      asistentes: _asistentes(),
      extras: extras
          .where((extra) => _extrasSeleccionados.contains(extra.nombre))
          .toList(),
      fechaActual: widget.fechaActual,
    );
    if (reserva == null) {
      setState(_seleccionarTurno);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El turno ya no está disponible. Elige otro horario.'),
        ),
      );
      return;
    }
    setState(() => _confirmando = true);
    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (_) => ConfirmacionReservaScreen(
          reserva: reserva,
          fechaActual: widget.fechaActual,
        ),
      ),
    );
  }

  List<String> _asistentes() {
    final nombres = [
      DatosDemo.usuario.nombre,
      'Lucía Martínez',
      'David Ruiz',
      'Sara López',
    ];
    return List.generate(
      _numeroAsistentes,
      (indice) =>
          indice < nombres.length ? nombres[indice] : 'Jugador ${indice + 1}',
    );
  }

  DateTime _fechaHora(DateTime fecha, String hora) {
    final partes = hora.split(':');
    return DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );
  }

  String _periodoParaHora(String hora) {
    final numero = int.parse(hora.split(':').first);
    if (numero < 12) {
      return 'Mañana';
    }
    if (numero < 18) {
      return 'Tarde';
    }
    return 'Noche';
  }
}
