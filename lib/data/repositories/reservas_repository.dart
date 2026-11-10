import 'package:flutter/foundation.dart';

import '../../domain/models/espacio.dart';
import '../../domain/models/reserva.dart';
import '../../domain/models/servicio_extra.dart';
import '../services/datos_demo.dart';

/// Estado compartido durante la ejecución; se reinicia al cerrar la app.
abstract final class ReservasRepository {
  static final reservas = ValueNotifier<List<Reserva>>(
    List.unmodifiable(DatosDemo.reservas),
  );
  static int _siguienteId = 1;

  static List<Reserva> proximas({DateTime? fechaActual}) {
    final referencia = fechaActual ?? DateTime.now();
    final hoy = DateTime(referencia.year, referencia.month, referencia.day);
    return reservas.value
        .where(
          (reserva) =>
              reserva.estado != EstadoReserva.cancelada &&
              !reserva.inicio.isBefore(hoy),
        )
        .toList()
      ..sort((primera, segunda) => primera.inicio.compareTo(segunda.inicio));
  }

  static bool estaLibre(String espacioId, DateTime inicio, DateTime fin) {
    if (!fin.isAfter(inicio)) {
      return false;
    }
    final dia = DatosDemo.disponibilidadSemana(
      espacioId,
      referencia: inicio,
    ).first;
    final turnoPermitido = dia.franjas.any((franja) {
      final partesInicio = franja.horaInicio.split(':');
      final partesFin = franja.horaFin.split(':');
      final inicioTurno = DateTime(
        inicio.year,
        inicio.month,
        inicio.day,
        int.parse(partesInicio[0]),
        int.parse(partesInicio[1]),
      );
      final finTurno = DateTime(
        inicio.year,
        inicio.month,
        inicio.day,
        int.parse(partesFin[0]),
        int.parse(partesFin[1]),
      );
      return franja.libre &&
          !inicio.isBefore(inicioTurno) &&
          !fin.isAfter(finTurno);
    });
    if (!turnoPermitido) {
      return false;
    }
    return !haySolapamiento(espacioId, inicio, fin);
  }

  static bool haySolapamiento(
    String espacioId,
    DateTime inicio,
    DateTime fin,
  ) => reservas.value.any(
    (reserva) =>
        reserva.espacio.id == espacioId &&
        reserva.estado != EstadoReserva.cancelada &&
        inicio.isBefore(reserva.fin) &&
        fin.isAfter(reserva.inicio),
  );

  static Reserva? crear({
    required Espacio espacio,
    required DateTime inicio,
    required DateTime fin,
    required List<String> asistentes,
    List<ServicioExtra> extras = const [],
    DateTime? fechaActual,
  }) {
    final espacios = DatosDemo.espacios.where((dato) => dato.id == espacio.id);
    if (espacios.isEmpty) {
      return null;
    }
    final espacioCatalogo = espacios.first;
    if (asistentes.isEmpty ||
        asistentes.length > espacioCatalogo.capacidad ||
        inicio.isBefore(fechaActual ?? DateTime.now()) ||
        !estaLibre(espacio.id, inicio, fin)) {
      return null;
    }
    final nombresExtras = extras.map((extra) => extra.nombre).toSet();
    final extrasCatalogo = espacioCatalogo.servicios
        .where(
          (extra) =>
              extra.precio != null && nombresExtras.contains(extra.nombre),
        )
        .toList();
    if (extrasCatalogo.length != nombresExtras.length) {
      return null;
    }
    final reserva = Reserva(
      id: 'reserva-${_siguienteId++}',
      espacio: espacioCatalogo,
      inicio: inicio,
      fin: fin,
      asistentes: asistentes,
      extras: extrasCatalogo,
    );
    reservas.value = List.unmodifiable([...reservas.value, reserva]);
    return reserva;
  }

  static void cancelar(String id) {
    if (!reservas.value.any(
      (reserva) =>
          reserva.id == id && reserva.estado != EstadoReserva.cancelada,
    )) {
      return;
    }
    reservas.value = List.unmodifiable([
      for (final reserva in reservas.value)
        reserva.id == id ? reserva.conEstado(EstadoReserva.cancelada) : reserva,
    ]);
  }

  static void restablecer() {
    _siguienteId = 1;
    reservas.value = List.unmodifiable(DatosDemo.reservas);
  }
}
