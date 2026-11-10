import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data/repositories/disponibilidad_repository.dart';
import 'package:proyecto/data/repositories/reservas_repository.dart';
import 'package:proyecto/domain/models/espacio.dart';
import 'package:proyecto/ui/core/formatters/formatos.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/espacios/ui/espacio_detalle_screen.dart';
import 'package:proyecto/ui/reservas/ui/nueva_reserva_screen.dart';

const espacio = Espacio(
  id: 'detalle-reserva',
  nombre: 'Pista del detalle',
  ubicacion: 'Valencia',
  capacidad: 4,
  actividades: ['Pádel'],
  imagenUrl: '',
  descripcion: 'Pista cubierta con iluminación.',
  tarifaHora: 20,
);

void main() {
  setUp(ReservasRepository.restablecer);
  tearDown(ReservasRepository.restablecer);

  Future<void> abrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: const EspacioDetalleScreen(espacio: espacio),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('El detalle muestra tres días sin recortar el repositorio', (
    tester,
  ) async {
    await abrir(tester);
    final dias = DisponibilidadRepository.disponibilidadSemana(espacio.id);
    expect(dias, hasLength(7));
    expect(find.text('Horarios de los próximos 3 días'), findsOneWidget);
    for (var indice = 0; indice < dias.length; indice++) {
      final fecha = formatearFecha(dias[indice].fecha);
      expect(
        find.text('${indice == 0 ? 'Hoy · ' : ''}$fecha'),
        indice < 3 ? findsOneWidget : findsNothing,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ambos botones Reservar abren el formulario del mismo espacio', (
    tester,
  ) async {
    await abrir(tester);
    for (var indice = 0; indice < 2; indice++) {
      final botones = find.widgetWithText(FilledButton, 'Reservar');
      expect(botones, findsNWidgets(2));
      await tester.ensureVisible(botones.at(indice));
      await tester.pumpAndSettle();
      await tester.tap(botones.at(indice));
      await tester.pumpAndSettle();
      expect(find.byType(NuevaReservaScreen), findsOneWidget);
      expect(
        tester
            .widget<NuevaReservaScreen>(find.byType(NuevaReservaScreen))
            .espacio,
        same(espacio),
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });
}
