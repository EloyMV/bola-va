import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data/repositories/disponibilidad_repository.dart';
import 'package:proyecto/data/repositories/reservas_repository.dart';
import 'package:proyecto/data/services/datos_demo.dart';
import 'package:proyecto/domain/models/reserva.dart';
import 'package:proyecto/domain/models/servicio_extra.dart';

void main() {
  setUp(ReservasRepository.restablecer);
  tearDown(ReservasRepository.restablecer);

  Reserva? reservar(int hora, {int? fin, int minuto = 0}) =>
      ReservasRepository.crear(
        espacio: DatosDemo.espacios.first,
        inicio: DateTime(2026, 11, 13, hora, minuto),
        fin: DateTime(2026, 11, 13, fin ?? hora + 2),
        asistentes: [DatosDemo.usuario.nombre],
        fechaActual: DateTime(2026, 11, 13),
        extras: DatosDemo.espacios.first.servicios
            .where((extra) => extra.precio != null)
            .toList(),
      );

  test('La semilla conserva importes y el usuario común', () {
    expect(ReservasRepository.reservas.value.map((reserva) => reserva.total), [
      50,
      26,
    ]);
    for (final reserva in ReservasRepository.reservas.value) {
      expect(reserva.asistentes.first, DatosDemo.usuario.nombre);
    }
  });

  test(
    'Crear informa al listado y rechaza solapamientos exactos y parciales',
    () {
      final creada = reservar(16);
      expect(creada, isNotNull);
      expect(creada!.total, 55);
      expect(
        ReservasRepository.proximas(fechaActual: DateTime(2026, 11, 13)),
        contains(creada),
      );
      expect(reservar(16), isNull);
      expect(reservar(17, fin: 18), isNull);
      expect(reservar(18), isNotNull);
      expect(ReservasRepository.reservas.value.length, 4);
    },
  );

  test(
    'La disponibilidad refleja crear y cancelar sin alterar otros turnos',
    () {
      final creada = reservar(16)!;
      final antes = DisponibilidadRepository.disponibilidadSemana(
        'central',
        referencia: DateTime(2026, 11, 13),
      );
      expect(
        antes.first.franjas
            .firstWhere((franja) => franja.horaInicio == '16:00')
            .libre,
        isFalse,
      );
      expect(
        antes.first.franjas
            .firstWhere((franja) => franja.horaInicio == '18:00')
            .libre,
        isTrue,
      );
      ReservasRepository.cancelar(creada.id);
      final despues = DisponibilidadRepository.disponibilidadSemana(
        'central',
        referencia: DateTime(2026, 11, 13),
      );
      expect(
        despues.first.franjas
            .firstWhere((franja) => franja.horaInicio == '16:00')
            .libre,
        isTrue,
      );
      expect(
        ReservasRepository.proximas(fechaActual: DateTime(2026, 11, 13)),
        isNot(contains(creada)),
      );
      expect(reservar(16), isNotNull);
    },
  );

  test('No admite los turnos ocupados ni reservas fuera del horario', () {
    expect(reservar(14), isNull);
    expect(reservar(8), isNull);
    expect(reservar(20), isNull);
    expect(reservar(12, fin: 11), isNull);
  });

  test('La disponibilidad de una fecha no cambia al consultar otra semana', () {
    final semana = DisponibilidadRepository.disponibilidadSemana(
      'central',
      referencia: DateTime(2026, 11, 10),
    );
    final viernes = DisponibilidadRepository.disponibilidadSemana(
      'central',
      referencia: DateTime(2026, 11, 13),
    ).first;
    expect(
      semana[3].franjas.map((franja) => franja.libre),
      viernes.franjas.map((franja) => franja.libre),
    );
  });

  test('Rechaza fechas pasadas, demasiados asistentes y extras ajenos', () {
    final espacio = DatosDemo.espacios.first;
    final inicio = DateTime(2026, 11, 13, 16);
    final fin = DateTime(2026, 11, 13, 18);
    expect(
      ReservasRepository.crear(
        espacio: espacio,
        inicio: inicio,
        fin: fin,
        asistentes: [DatosDemo.usuario.nombre],
        fechaActual: DateTime(2026, 11, 14),
      ),
      isNull,
    );
    expect(
      ReservasRepository.crear(
        espacio: espacio,
        inicio: inicio,
        fin: fin,
        asistentes: ['A', 'B', 'C', 'D', 'E'],
        fechaActual: DateTime(2026, 11, 13),
      ),
      isNull,
    );
    expect(
      ReservasRepository.crear(
        espacio: espacio,
        inicio: inicio,
        fin: fin,
        asistentes: [DatosDemo.usuario.nombre],
        extras: const [
          ServicioExtra(nombre: 'Extra inexistente', icono: 'extra', precio: 1),
        ],
        fechaActual: DateTime(2026, 11, 13),
      ),
      isNull,
    );
    expect(ReservasRepository.reservas.value.length, 2);
  });
}
