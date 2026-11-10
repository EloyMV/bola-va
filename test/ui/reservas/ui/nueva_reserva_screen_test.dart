import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data/repositories/reservas_repository.dart';
import 'package:proyecto/data/services/datos_demo.dart';
import 'package:proyecto/domain/models/reserva.dart';
import 'package:proyecto/ui/core/theme/app_preferencias.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/reservas/ui/mis_reservas_screen.dart';
import 'package:proyecto/ui/reservas/ui/nueva_reserva_screen.dart';

void main() {
  setUp(() {
    ReservasRepository.restablecer();
    AppPreferencias.horarioFavorito.value = 'Tarde';
  });
  tearDown(ReservasRepository.restablecer);

  Future<void> abrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: NuevaReservaScreen(
          espacio: DatosDemo.espacios.first,
          fechaActual: DateTime(2026, 11, 13),
        ),
      ),
    );
  }

  Future<void> pulsar(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Los extras recalculan el precio y la reserva aparece en el listado',
    (tester) async {
      await abrir(tester);
      expect(find.text('Viernes, 13 de noviembre de 2026'), findsOneWidget);
      expect(find.textContaining(DatosDemo.usuario.nombre), findsOneWidget);
      expect(find.text('48,00 €'), findsNWidgets(2));

      await pulsar(
        tester,
        find.byKey(const ValueKey('extra-central-Alquiler de raquetas')),
      );
      expect(find.text('52,00 €'), findsOneWidget);
      await pulsar(
        tester,
        find.byKey(const ValueKey('extra-central-Cesta de bolas')),
      );
      expect(find.text('55,00 €'), findsOneWidget);
      await pulsar(tester, find.text('Confirmar reserva'));

      expect(find.byType(ConfirmacionReservaScreen), findsOneWidget);
      expect(find.text('Reserva confirmada'), findsOneWidget);
      expect(find.text('55,00 €'), findsOneWidget);
      expect(find.text('Alquiler de raquetas, Cesta de bolas'), findsOneWidget);
      expect(ReservasRepository.reservas.value.length, 3);
      final creada = ReservasRepository.reservas.value.last;
      expect(creada.total, 55);
      expect(creada.inicio, DateTime(2026, 11, 13, 12));

      await pulsar(tester, find.text('Mis reservas'));
      expect(find.byType(MisReservasScreen), findsOneWidget);
      expect(find.byKey(ValueKey('reserva-${creada.id}')), findsOneWidget);
      expect(find.text('Precio total: 55,00 €'), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(MisReservasScreen))).canPop(),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Permite elegir fecha, turno y número de personas', (
    tester,
  ) async {
    await abrir(tester);
    await pulsar(tester, find.byKey(const ValueKey('selector-fecha-reserva')));
    await pulsar(tester, find.text('14 nov 2026').last);
    await pulsar(tester, find.byKey(const ValueKey('horario-14:00')));
    await pulsar(
      tester,
      find.byKey(const ValueKey('selector-personas-reserva')),
    );
    await pulsar(tester, find.text('2 personas').last);
    await pulsar(tester, find.text('Confirmar reserva'));

    expect(find.byType(ConfirmacionReservaScreen), findsOneWidget);
    expect(find.text('Sábado, 14 de noviembre de 2026'), findsOneWidget);
    expect(find.textContaining('Asistentes (2/4)'), findsOneWidget);
    expect(find.text('Álex García, Lucía Martínez'), findsOneWidget);
    expect(
      ReservasRepository.reservas.value.last.inicio,
      DateTime(2026, 11, 14, 14),
    );
    expect(
      ReservasRepository.reservas.value.last.fin,
      DateTime(2026, 11, 14, 16),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Una doble pulsación no duplica la reserva', (tester) async {
    await abrir(tester);
    final confirmar = find.widgetWithText(FilledButton, 'Confirmar reserva');
    await tester.ensureVisible(confirmar);
    await tester.pumpAndSettle();
    final accion = tester.widget<FilledButton>(confirmar).onPressed!;
    accion();
    accion();
    await tester.pumpAndSettle();
    expect(ReservasRepository.reservas.value.length, 3);
    expect(find.byType(ConfirmacionReservaScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Los turnos ocupados se desactivan y se comprueban al confirmar',
    (tester) async {
      await abrir(tester);
      expect(
        tester
            .widget<ChoiceChip>(find.byKey(const ValueKey('horario-14:00')))
            .onSelected,
        isNull,
      );
      final creada = ReservasRepository.crear(
        espacio: DatosDemo.espacios.first,
        inicio: DateTime(2026, 11, 13, 12),
        fin: DateTime(2026, 11, 13, 14),
        asistentes: [DatosDemo.usuario.nombre],
        fechaActual: DateTime(2026, 11, 13),
      );
      expect(creada, isNotNull);
      await pulsar(tester, find.text('Confirmar reserva'));
      expect(find.byType(ConfirmacionReservaScreen), findsNothing);
      expect(
        find.text('El turno ya no está disponible. Elige otro horario.'),
        findsOneWidget,
      );
      expect(ReservasRepository.reservas.value.length, 3);
      expect(
        tester
            .widget<ChoiceChip>(find.byKey(const ValueKey('horario-12:00')))
            .onSelected,
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'El formulario y el resumen admiten móvil estrecho y texto grande',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final espacio = DatosDemo.espacios.first;
      final reserva = Reserva(
        id: 'vista',
        espacio: espacio,
        inicio: DateTime(2026, 11, 13, 16),
        fin: DateTime(2026, 11, 13, 18),
        asistentes: [
          DatosDemo.usuario.nombre,
          'Lucía Martínez',
          'David Ruiz',
          'Sara López',
        ],
        extras: espacio.servicios
            .where((extra) => extra.precio != null)
            .toList(),
      );
      for (final pantalla in <Widget>[
        NuevaReservaScreen(
          espacio: espacio,
          fechaActual: DateTime(2026, 11, 13),
        ),
        ConfirmacionReservaScreen(reserva: reserva),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTema.claro,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(2)),
              child: child!,
            ),
            home: pantalla,
          ),
        );
        expect(tester.takeException(), isNull, reason: '$pantalla');
      }
    },
  );
}
