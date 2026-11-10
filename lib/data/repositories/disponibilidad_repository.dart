import '../../domain/models/disponibilidad_dia.dart';
import '../../domain/models/franja_disponibilidad.dart';
import '../services/datos_demo.dart';
import 'reservas_repository.dart';

abstract final class DisponibilidadRepository {
  static List<DisponibilidadDia> disponibilidadSemana(
    String espacioId, {
    DateTime? referencia,
  }) {
    final ahora = referencia ?? DateTime.now();
    return [
      for (final dia in DatosDemo.disponibilidadSemana(
        espacioId,
        referencia: ahora,
      ))
        DisponibilidadDia(
          fecha: dia.fecha,
          franjas: [
            for (final franja in dia.franjas)
              FranjaDisponibilidad(
                horaInicio: franja.horaInicio,
                horaFin: franja.horaFin,
                libre:
                    franja.libre &&
                    !_fechaHora(dia.fecha, franja.horaInicio).isBefore(ahora) &&
                    !ReservasRepository.haySolapamiento(
                      espacioId,
                      _fechaHora(dia.fecha, franja.horaInicio),
                      _fechaHora(dia.fecha, franja.horaFin),
                    ),
              ),
          ],
        ),
    ];
  }

  static DateTime _fechaHora(DateTime fecha, String hora) {
    final partes = hora.split(':');
    return DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );
  }
}
