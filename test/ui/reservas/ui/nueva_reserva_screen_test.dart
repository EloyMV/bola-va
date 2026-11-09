import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data/services/datos_demo.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/espacios/ui/espacio_detalle_screen.dart';
import 'package:proyecto/ui/reservas/ui/mis_reservas_screen.dart';
import 'package:proyecto/ui/reservas/ui/nueva_reserva_screen.dart';

void main() {
  testWidgets('La selección de extras actualiza el precio por reserva', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final espacio = DatosDemo.espacios.first;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: NuevaReservaScreen(espacio: espacio),
      ),
    );

    expect(find.text('Pista Central'), findsOneWidget);
    expect(find.text('Pádel'), findsOneWidget);
    expect(find.text('Viernes, 13 de noviembre de 2026'), findsOneWidget);
    expect(find.text('Hora de inicio'), findsOneWidget);
    expect(find.text('18:00'), findsNWidgets(2));
    expect(find.text('Hora de fin'), findsOneWidget);
    expect(find.text('20:00'), findsOneWidget);
    expect(find.textContaining('Asistentes (4/4)'), findsOneWidget);
    expect(find.textContaining('Alex García'), findsOneWidget);
    expect(find.text('Incluido'), findsNWidgets(3));
    expect(find.text('48,00 €'), findsNWidgets(2));

    final raquetas = find.byKey(
      const ValueKey<String>('extra-central-Alquiler de raquetas'),
    );
    final bolas = find.byKey(
      const ValueKey<String>('extra-central-Cesta de bolas'),
    );
    await tester.ensureVisible(raquetas);
    await tester.pumpAndSettle();
    await tester.tap(raquetas);
    await tester.pumpAndSettle();
    expect(find.text('52,00 €'), findsOneWidget);

    await tester.ensureVisible(bolas);
    await tester.tap(bolas);
    await tester.pumpAndSettle();
    expect(find.text('55,00 €'), findsOneWidget);

    await tester.ensureVisible(raquetas);
    await tester.pumpAndSettle();
    await tester.tap(raquetas);
    await tester.pumpAndSettle();
    expect(find.text('51,00 €'), findsOneWidget);
  });

  testWidgets('Permite elegir fecha, turno y número de personas', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: NuevaReservaScreen(espacio: DatosDemo.espacios.first),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('selector-fecha-reserva')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('14 nov 2026').last);
    await tester.pumpAndSettle();

    final turno = find.byKey(const ValueKey('horario-16:00'));
    await tester.ensureVisible(turno);
    await tester.tap(turno);
    await tester.pumpAndSettle();

    final selectorPersonas = find.byKey(
      const ValueKey('selector-personas-reserva'),
    );
    await tester.ensureVisible(selectorPersonas);
    await tester.tap(selectorPersonas);
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 personas').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Asistentes (2/4)'), findsOneWidget);

    final confirmar = find.text('Confirmar reserva');
    await tester.ensureVisible(confirmar);
    await tester.tap(confirmar);
    await tester.pumpAndSettle();

    expect(find.byType(ConfirmacionReservaScreen), findsOneWidget);
    expect(find.text('Sábado, 14 de noviembre de 2026'), findsOneWidget);
    expect(find.text('16:00'), findsOneWidget);
    expect(find.text('18:00'), findsOneWidget);
    expect(find.textContaining('Asistentes (2/4)'), findsOneWidget);
    expect(find.text('Alex García, Lucía Martínez'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'La confirmación conserva el espacio y los extras y Mis reservas son ejemplos',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final espacio = DatosDemo.espacios.first;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTema.claro,
          home: EspacioDetalleScreen(espacio: espacio),
        ),
      );

      await tester.ensureVisible(find.text('Reservar'));
      await tester.tap(find.text('Reservar'));
      await tester.pumpAndSettle();
      expect(find.text('Pista Central'), findsOneWidget);

      final raquetas = find.byKey(
        const ValueKey<String>('extra-central-Alquiler de raquetas'),
      );
      final bolas = find.byKey(
        const ValueKey<String>('extra-central-Cesta de bolas'),
      );
      await tester.ensureVisible(raquetas);
      await tester.pumpAndSettle();
      await tester.tap(raquetas);
      await tester.pumpAndSettle();
      await tester.ensureVisible(bolas);
      await tester.pumpAndSettle();
      await tester.tap(bolas);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Confirmar reserva'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar reserva'));
      await tester.pumpAndSettle();
      expect(find.text('Reserva de prueba'), findsOneWidget);
      expect(
        find.textContaining('Alquiler de raquetas, Cesta de bolas'),
        findsOneWidget,
      );
      expect(find.byType(ConfirmacionReservaScreen), findsOneWidget);
      expect(find.text('55,00 €'), findsOneWidget);
      expect(find.textContaining('no se guarda ni altera'), findsOneWidget);

      await tester.ensureVisible(find.text('Mis reservas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mis reservas'));
      await tester.pumpAndSettle();
      expect(find.byType(MisReservasScreen), findsOneWidget);
      expect(find.text('Pista Panorámica'), findsOneWidget);
      expect(find.text('Pista Indoor'), findsOneWidget);
      expect(find.textContaining('no se ha guardado'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ConfirmacionReservaScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(EspacioDetalleScreen), findsOneWidget);
      expect(find.text('Pista Central'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('La reserva y su resumen admiten móvil estrecho y texto grande', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final espacio = DatosDemo.espacios.first;
    final extra = espacio.servicios.firstWhere(
      (servicio) => servicio.precio != null,
    );
    final pantallas = <Widget>[
      NuevaReservaScreen(espacio: espacio),
      ConfirmacionReservaScreen(
        espacio: espacio,
        extras: [extra],
        fecha: 'Viernes, 13 de noviembre de 2026',
        horaInicio: '18:00',
        horaFin: '20:00',
        asistentes: const ['Alex García', 'Lucía Martínez', 'David Ruiz', 'Tú'],
        duracionHoras: 2,
        subtotalAlquiler: 48,
        subtotalExtras: extra.precio!,
        total: 48 + extra.precio!,
      ),
    ];

    for (final pantalla in pantallas) {
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
      final error = tester.takeException();
      expect(error, isNull, reason: '$pantalla');
    }
  });
}
