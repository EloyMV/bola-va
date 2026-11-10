import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data/repositories/reservas_repository.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/ui/acceso/ui/login_screen.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/core/ui/navegacion_principal.dart';
import 'package:proyecto/ui/espacios/ui/espacio_detalle_screen.dart';
import 'package:proyecto/ui/espacios/ui/espacios_screen.dart';
import 'package:proyecto/ui/perfil/ui/perfil_screen.dart';
import 'package:proyecto/ui/reservas/ui/mis_reservas_screen.dart';
import 'package:proyecto/ui/reservas/ui/nueva_reserva_screen.dart';

void vistaMovil(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

void main() {
  setUp(ReservasRepository.restablecer);
  tearDown(ReservasRepository.restablecer);

  testWidgets('Cabecera y barra inferior permanecen visibles al desplazar', (
    tester,
  ) async {
    vistaMovil(tester);
    const finalContenido = Key('final-contenido');
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTema.claro,
        home: EspaciosScreen(
          contenido: Column(
            children: [
              const SizedBox(height: 1400, child: Text('Contenido largo')),
              FilledButton(
                key: finalContenido,
                onPressed: () {},
                child: const Text('Final del contenido'),
              ),
            ],
          ),
        ),
      ),
    );
    final cabecera = tester.getRect(find.byType(AppBar));
    final barra = tester.getRect(find.byKey(const Key('barra-inferior')));
    await tester.ensureVisible(find.byKey(finalContenido));
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byType(AppBar)), cabecera);
    expect(tester.getRect(find.byKey(const Key('barra-inferior'))), barra);
    expect(find.text('Perfil').hitTestable(), findsOneWidget);
    expect(find.text('Inicio').hitTestable(), findsOneWidget);
    expect(find.text('Mis reservas').hitTestable(), findsOneWidget);
    expect(
      tester.getRect(find.byKey(finalContenido)).bottom,
      lessThanOrEqualTo(barra.top),
    );
    expect(find.text('Cerrar sesión'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'La barra permite salir de un formulario sin conservar sus rutas',
    (tester) async {
      vistaMovil(tester);
      await tester.pumpWidget(const MyApp());
      expect(find.byType(NavegacionPrincipal), findsNothing);
      expect(find.byType(AccesoPerfil), findsNothing);
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('espacio-card-central')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reservar').first);
      await tester.pumpAndSettle();
      expect(find.byType(NuevaReservaScreen), findsOneWidget);

      await tester.tap(find.text('Mis reservas'));
      await tester.pumpAndSettle();
      expect(find.byType(MisReservasScreen), findsOneWidget);
      expect(
        find.byType(NuevaReservaScreen, skipOffstage: false),
        findsNothing,
      );
      expect(
        find.byType(EspacioDetalleScreen, skipOffstage: false),
        findsNothing,
      );
      expect(
        Navigator.of(tester.element(find.byType(MisReservasScreen))).canPop(),
        isFalse,
      );

      await tester.tap(find.text('Inicio'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inicio'));
      await tester.pumpAndSettle();
      expect(find.byType(EspaciosScreen, skipOffstage: false), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(EspaciosScreen))).canPop(),
        isFalse,
      );
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Cerrar sesión'));
      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(PerfilScreen, skipOffstage: false), findsNothing);
      expect(find.byType(NavegacionPrincipal), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Los accesos fijos admiten texto ampliado en claro y oscuro', (
    tester,
  ) async {
    vistaMovil(tester);
    tester.view.physicalSize = const Size(320, 568);
    for (final oscuro in [false, true]) {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(oscuro),
          theme: oscuro ? AppTema.oscuro : AppTema.claro,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2.4)),
            child: child!,
          ),
          home: const EspaciosScreen(contenido: SizedBox(height: 900)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Perfil').hitTestable(), findsOneWidget);
      expect(find.text('Inicio').hitTestable(), findsOneWidget);
      expect(find.text('Mis reservas').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
