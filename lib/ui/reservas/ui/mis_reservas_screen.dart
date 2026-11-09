import 'package:flutter/material.dart';

import '../../../data/services/datos_demo.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/pagina_base.dart';
import '../../core/ui/reserva_tarjeta.dart';
import '../../espacios/ui/espacios_screen.dart';
import '../../perfil/ui/perfil_screen.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key, this.contenido, this.fechaActual});

  final Widget? contenido;
  final DateTime? fechaActual;

  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  static final List<_ReservaDemo> _reservas = [
    _ReservaDemo(
      espacioId: 'panoramica',
      fecha: 'Sábado, 14 de noviembre de 2026',
      hora: 'De 10:00 a 11:30',
      duracionMinutos: 90,
      asistentes: 4,
      servicios: ['Alquiler de raquetas', 'Cesta de bolas'],
      estado: EstadoReserva.confirmada,
      fechaDia: DateTime(2026, 11, 14),
    ),
    _ReservaDemo(
      espacioId: 'indoor',
      fecha: 'Domingo, 15 de noviembre de 2026',
      hora: 'De 16:00 a 17:00',
      duracionMinutos: 60,
      asistentes: 2,
      servicios: [],
      estado: EstadoReserva.pendiente,
      fechaDia: DateTime(2026, 11, 15),
    ),
  ];

  final Map<String, EstadoReserva> _estadosEnMemoria = {};

  @override
  Widget build(BuildContext context) {
    final hoy = _soloFecha(widget.fechaActual ?? DateTime.now());
    final reservasVisibles = _reservas.where((reserva) {
      final fechaReserva = _soloFecha(reserva.fechaDia);
      return !fechaReserva.isBefore(hoy) &&
          _estadosEnMemoria[reserva.espacioId] != EstadoReserva.cancelada;
    }).toList();

    return PaginaBase(
      titulo: 'Mis reservas',
      subtitulo: 'Consulta los detalles de tus reservas de demostración.',
      child:
          widget.contenido ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Datos de demostración; no se ha guardado ninguna solicitud. '
                'Las reservas pasadas y canceladas se ocultan; los cambios '
                'solo se mantienen en memoria.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppEspaciado.md),
              Wrap(
                spacing: AppEspaciado.sm,
                runSpacing: AppEspaciado.sm,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context)
                        .pushReplacement<void, void>(
                          MaterialPageRoute<void>(
                            builder: (context) => const EspaciosScreen(),
                          ),
                        ),
                    icon: const Icon(Icons.sports_tennis_outlined),
                    label: const Text('Espacios'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context)
                        .pushReplacement<void, void>(
                          MaterialPageRoute<void>(
                            builder: (context) => const PerfilScreen(),
                          ),
                        ),
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Perfil'),
                  ),
                ],
              ),
              const SizedBox(height: AppEspaciado.md),
              if (reservasVisibles.isEmpty)
                const Text('No tienes reservas próximas.')
              else
                for (
                  var indice = 0;
                  indice < reservasVisibles.length;
                  indice++
                ) ...[
                  if (indice > 0) const SizedBox(height: AppEspaciado.sm),
                  _tarjetaReserva(reservasVisibles[indice]),
                ],
            ],
          ),
    );
  }

  Widget _tarjetaReserva(_ReservaDemo reserva) {
    final espacio = DatosDemo.espacios.firstWhere(
      (espacio) => espacio.id == reserva.espacioId,
    );
    final contacto = espacio.contacto;
    final extras = reserva.servicios.map((nombreServicio) {
      final servicio = espacio.servicios.firstWhere(
        (servicio) => servicio.nombre == nombreServicio,
      );
      return '${servicio.nombre} · ${_formatearPrecio(servicio.precio ?? 0)}';
    }).toList();
    final total =
        espacio.tarifaHora * reserva.duracionMinutos / 60 +
        reserva.servicios.fold<double>(0, (suma, nombreServicio) {
          final servicio = espacio.servicios.firstWhere(
            (servicio) => servicio.nombre == nombreServicio,
          );
          return suma + (servicio.precio ?? 0);
        });

    return ReservaTarjeta(
      key: ValueKey<String>('reserva-${reserva.espacioId}'),
      nombreEspacio: espacio.nombre,
      imagenUrl: espacio.imagenUrl,
      fecha: reserva.fecha,
      hora: reserva.hora,
      estado: _estadosEnMemoria[reserva.espacioId] ?? reserva.estado,
      actividad: espacio.actividades.first,
      asistentes: reserva.asistentes,
      servicios: extras,
      precioTotal: _formatearPrecio(total),
      responsable: contacto?.nombre,
      telefono: contacto?.telefono,
      correo: contacto?.correo,
      onDetails: () => _mostrarDetalles(
        reserva: reserva,
        nombreEspacio: espacio.nombre,
        extras: extras,
        precioTotal: _formatearPrecio(total),
      ),
      onCancel:
          (_estadosEnMemoria[reserva.espacioId] ?? reserva.estado) ==
              EstadoReserva.cancelada
          ? null
          : () => _confirmarCancelacion(reserva),
    );
  }

  Future<void> _confirmarCancelacion(_ReservaDemo reserva) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: const Text(
          '¿Quieres cancelar esta reserva? Es una acción de demostración: '
          'no se guardará ni modificará ningún dato persistente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      setState(() {
        _estadosEnMemoria[reserva.espacioId] = EstadoReserva.cancelada;
      });
    }
  }

  Future<void> _mostrarDetalles({
    required _ReservaDemo reserva,
    required String nombreEspacio,
    required List<String> extras,
    required String precioTotal,
  }) async {
    final espacio = DatosDemo.espacios.firstWhere(
      (espacio) => espacio.id == reserva.espacioId,
    );
    final contacto = espacio.contacto;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles · $nombreEspacio'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Actividad: ${espacio.actividades.first}'),
              const SizedBox(height: AppEspaciado.xs),
              Text('Asistentes: ${reserva.asistentes}'),
              const SizedBox(height: AppEspaciado.xs),
              const Text('Servicios contratados:'),
              if (extras.isEmpty)
                const Text('Sin extras')
              else
                for (final extra in extras) Text(extra),
              const SizedBox(height: AppEspaciado.xs),
              Text('Precio total: $precioTotal'),
              if (contacto != null) ...[
                const SizedBox(height: AppEspaciado.sm),
                const Text('Contacto del espacio'),
                Text('Responsable: ${contacto.nombre}'),
                Text('Teléfono: ${contacto.telefono}'),
                Text('Correo: ${contacto.correo}'),
              ],
              const SizedBox(height: AppEspaciado.sm),
              const Text(
                'Información de demostración; no se guarda en un servidor.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _formatearPrecio(double precio) =>
      '${precio.toStringAsFixed(2).replaceAll('.', ',')} €';

  DateTime _soloFecha(DateTime fecha) =>
      DateTime(fecha.year, fecha.month, fecha.day);
}

class _ReservaDemo {
  _ReservaDemo({
    required this.espacioId,
    required this.fecha,
    required this.hora,
    required this.duracionMinutos,
    required this.asistentes,
    required this.servicios,
    required this.estado,
    required this.fechaDia,
  });

  final String espacioId;
  final String fecha;
  final String hora;
  final int duracionMinutos;
  final int asistentes;
  final List<String> servicios;
  final EstadoReserva estado;
  final DateTime fechaDia;
}
