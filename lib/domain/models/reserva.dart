import 'espacio.dart';
import 'servicio_extra.dart';

enum EstadoReserva { confirmada, pendiente, cancelada }

/// Una reserva mantiene juntos el turno, los asistentes y su precio.
class Reserva {
  Reserva({
    required this.id,
    required this.espacio,
    required this.inicio,
    required this.fin,
    required List<String> asistentes,
    List<ServicioExtra> extras = const [],
    this.estado = EstadoReserva.confirmada,
  }) : asistentes = List.unmodifiable(asistentes),
       extras = List.unmodifiable(extras);

  final String id;
  final Espacio espacio;
  final DateTime inicio;
  final DateTime fin;
  final List<String> asistentes;
  final List<ServicioExtra> extras;
  final EstadoReserva estado;

  double get duracionHoras => fin.difference(inicio).inMinutes / 60;
  double get subtotalAlquiler => espacio.tarifaHora * duracionHoras;
  double get subtotalExtras =>
      extras.fold(0, (suma, extra) => suma + (extra.precio ?? 0));
  double get total => subtotalAlquiler + subtotalExtras;

  Reserva conEstado(EstadoReserva nuevoEstado) => Reserva(
    id: id,
    espacio: espacio,
    inicio: inicio,
    fin: fin,
    asistentes: asistentes,
    extras: extras,
    estado: nuevoEstado,
  );
}
