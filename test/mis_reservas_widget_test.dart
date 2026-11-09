import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/core/ui/espacio_tarjeta.dart';
import 'package:proyecto/ui/espacios/ui/espacios_screen.dart';
import 'package:proyecto/ui/perfil/ui/perfil_screen.dart';
import 'package:proyecto/ui/reservas/ui/mis_reservas_screen.dart';

void main() {
  final fechaDemo = DateTime(2026, 11, 9, 23, 59);

  testWidgets('Muestra tarjetas compactas con imagen y datos principales', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: MisReservasScreen(fechaActual: fechaDemo),
      ),
    );

    final panoramica = find.byKey(const ValueKey<String>('reserva-panoramica'));
    final indoor = find.byKey(const ValueKey<String>('reserva-indoor'));

    expect(
      find.descendant(of: panoramica, matching: find.byType(EspacioImagen)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: panoramica, matching: find.text('Pista Panorámica')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: panoramica,
        matching: find.text('Sábado, 14 de noviembre de 2026'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: panoramica, matching: find.text('De 10:00 a 11:30')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: panoramica,
        matching: find.text('Precio total: 50,00 €'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: panoramica, matching: find.text('Confirmada')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: panoramica, matching: find.text('Actividad: Pádel')),
      findsNothing,
    );
    expect(
      find.descendant(of: indoor, matching: find.text('Precio total: 26,00 €')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: indoor, matching: find.text('Pendiente')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: panoramica, matching: find.text('Ver detalles')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Los detalles mantienen accesible la información secundaria', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: MisReservasScreen(fechaActual: fechaDemo),
      ),
    );

    final panoramica = find.byKey(const ValueKey<String>('reserva-panoramica'));
    await tester.tap(
      find.descendant(of: panoramica, matching: find.text('Ver detalles')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Actividad: Pádel'), findsOneWidget);
    expect(find.text('Asistentes: 4'), findsOneWidget);
    expect(find.text('Alquiler de raquetas · 5,00 €'), findsOneWidget);
    expect(find.text('Cesta de bolas · 3,00 €'), findsOneWidget);
    expect(find.text('Precio total: 50,00 €'), findsNWidgets(2));
    expect(find.text('Responsable: Pau Ferrer'), findsOneWidget);
    expect(find.text('Teléfono: 600 222 333'), findsOneWidget);
    expect(find.text('Correo: pau@bolava.example'), findsOneWidget);

    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    final indoor = find.byKey(const ValueKey<String>('reserva-indoor'));
    final detallesIndoor = find.descendant(
      of: indoor,
      matching: find.text('Ver detalles'),
    );
    await tester.ensureVisible(detallesIndoor);
    await tester.tap(detallesIndoor);
    await tester.pumpAndSettle();
    expect(find.text('Sin extras'), findsOneWidget);
    expect(find.text('Actividad: Pádel'), findsOneWidget);
    expect(find.text('Asistentes: 2'), findsOneWidget);
    expect(find.text('Responsable: Núria Vidal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Oculta las reservas del día anterior y conserva las de hoy', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: MisReservasScreen(fechaActual: DateTime(2026, 11, 15, 23, 59)),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('reserva-panoramica')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('reserva-indoor')),
      findsOneWidget,
    );
    expect(find.text('No tienes reservas próximas.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mantiene visibles las reservas de fechas futuras', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: MisReservasScreen(fechaActual: DateTime(2026, 11, 14, 23, 59)),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('reserva-indoor')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cancelar pide confirmación y actualiza solo al aceptar', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: MisReservasScreen(fechaActual: fechaDemo),
      ),
    );

    final panoramica = find.byKey(const ValueKey<String>('reserva-panoramica'));
    await tester.tap(
      find.descendant(of: panoramica, matching: find.text('Cancelar')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        'no se guardará ni modificará ningún dato persistente.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: panoramica, matching: find.text('Confirmada')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: panoramica, matching: find.text('Cancelar')),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: panoramica, matching: find.text('Cancelar')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sí, cancelar'));
    await tester.pumpAndSettle();

    expect(panoramica, findsNothing);
    final indoor = find.byKey(const ValueKey<String>('reserva-indoor'));
    expect(indoor, findsOneWidget);

    final cancelarIndoor = find.descendant(
      of: indoor,
      matching: find.text('Cancelar'),
    );
    await tester.ensureVisible(cancelarIndoor);
    await tester.tap(cancelarIndoor);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sí, cancelar'));
    await tester.pumpAndSettle();

    expect(indoor, findsNothing);
    expect(find.text('No tienes reservas próximas.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Permite navegar desde reservas a Espacios y Perfil', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: MisReservasScreen(fechaActual: fechaDemo),
      ),
    );

    await tester.tap(find.text('Ir a Espacios'));
    await tester.pumpAndSettle();
    expect(find.byType(EspaciosScreen), findsOneWidget);
    expect(find.text('Pistas de pádel'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ir a Perfil'));
    await tester.pumpAndSettle();
    expect(find.byType(PerfilScreen), findsOneWidget);
    expect(find.text('Mi perfil'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
