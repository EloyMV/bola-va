import 'franja_disponibilidad.dart';

class DisponibilidadDia {
  const DisponibilidadDia({required this.fecha, required this.franjas});

  final DateTime fecha;
  final List<FranjaDisponibilidad> franjas;
}
