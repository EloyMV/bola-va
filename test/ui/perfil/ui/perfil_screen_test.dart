import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data/services/datos_demo.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/ui/acceso/ui/login_screen.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/espacios/ui/espacios_screen.dart';
import 'package:proyecto/ui/perfil/ui/perfil_screen.dart';
import 'package:proyecto/ui/reservas/ui/mis_reservas_screen.dart';

Future<void> pulsar(WidgetTester tester, String texto) async {
  final boton = find.text(texto);
  await tester.ensureVisible(boton);
  await tester.tap(boton);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Perfil muestra la cuenta y los controles de preferencias', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTema.claro, home: const PerfilScreen()),
    );

    expect(find.text('Perfil y ajustes'), findsOneWidget);
    expect(find.text(DatosDemo.usuario.nombre), findsOneWidget);
    expect(find.text(DatosDemo.usuario.correo), findsOneWidget);
    expect(find.text(DatosDemo.usuario.iniciales), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('Preferencias'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<ThemeMode>), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);
    expect(find.textContaining('Ejemplo fijo'), findsNothing);
    expect(find.text('Sobre Bola Va'), findsOneWidget);
    expect(find.text('Versión 1.0.0 · Compilación 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Cerrar sesión desde Perfil elimina también las rutas anteriores',
    (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      const rutaAnterior = Key('ruta-anterior-a-la-sesion');
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          theme: AppTema.claro,
          home: const Scaffold(body: Text('Ruta anterior', key: rutaAnterior)),
        ),
      );

      // Dejamos una ruta real debajo para detectar un cierre que solo haga pop.
      navigatorKey.currentState!.push<void>(
        MaterialPageRoute<void>(builder: (_) => const EspaciosScreen()),
      );
      await tester.pumpAndSettle();
      navigatorKey.currentState!.push<void>(
        MaterialPageRoute<void>(builder: (_) => const PerfilScreen()),
      );
      await tester.pumpAndSettle();
      expect(navigatorKey.currentState!.canPop(), isTrue);
      await pulsar(tester, 'Cerrar sesión');

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byKey(rutaAnterior, skipOffstage: false), findsNothing);
      expect(find.byType(PerfilScreen, skipOffstage: false), findsNothing);
      expect(find.byType(EspaciosScreen, skipOffstage: false), findsNothing);
      expect(find.byType(MisReservasScreen, skipOffstage: false), findsNothing);
      expect(navigatorKey.currentState!.canPop(), isFalse);
      expect(await navigatorKey.currentState!.maybePop(), isFalse);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(PerfilScreen, skipOffstage: false), findsNothing);
      expect(find.byType(EspaciosScreen, skipOffstage: false), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Las secciones comparten usuario y no acumulan rutas principales',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      final campoCorreo = tester.widget<TextField>(
        find.byType(TextField).first,
      );
      expect(campoCorreo.controller!.text, DatosDemo.usuario.correo);

      await pulsar(tester, 'Entrar');
      expect(find.textContaining(DatosDemo.usuario.nombre), findsOneWidget);
      await pulsar(tester, 'Perfil');
      expect(find.text(DatosDemo.usuario.nombre), findsOneWidget);
      expect(find.text(DatosDemo.usuario.correo), findsOneWidget);

      for (final destino in [
        'Mis reservas',
        'Inicio',
        'Perfil',
        'Inicio',
        'Mis reservas',
        'Perfil',
      ]) {
        await pulsar(tester, destino);
        Finder pantalla;
        if (destino == 'Inicio') {
          pantalla = find.byType(EspaciosScreen);
        } else if (destino == 'Mis reservas') {
          pantalla = find.byType(MisReservasScreen);
        } else {
          pantalla = find.byType(PerfilScreen);
        }
        expect(pantalla, findsOneWidget);
        expect(Navigator.of(tester.element(pantalla)).canPop(), isFalse);
      }

      expect(find.byType(EspaciosScreen, skipOffstage: false), findsNothing);
      expect(find.byType(MisReservasScreen, skipOffstage: false), findsNothing);
      expect(find.text(DatosDemo.usuario.nombre), findsOneWidget);
      expect(find.text(DatosDemo.usuario.correo), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Perfil admite móvil pequeño y escritorio con texto grande', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    for (final tamano in [const Size(320, 568), const Size(1440, 900)]) {
      tester.view.physicalSize = tamano;
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(tamano),
          theme: AppTema.claro,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: const PerfilScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(DatosDemo.usuario.correo), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '$tamano');
      await tester.ensureVisible(find.text('Cerrar sesión'));
      expect(find.text('Cerrar sesión').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '$tamano');
    }
  });
}
