import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data/services/datos_demo.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/ui/acceso/ui/login_screen.dart';
import 'package:proyecto/ui/acceso/ui/registro_screen.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/espacios/ui/espacios_screen.dart';

Future<void> pulsar(WidgetTester tester, String texto) async {
  final boton = find.text(texto);
  await tester.ensureVisible(boton);
  await tester.tap(boton);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Entrar acepta cualquier dato y no permite volver al login', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'correo sin formato',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await pulsar(tester, 'Entrar');

    expect(find.byType(EspaciosScreen), findsOneWidget);
    expect(find.textContaining(DatosDemo.usuario.nombre), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);

    final navigator = Navigator.of(tester.element(find.byType(EspaciosScreen)));
    expect(navigator.canPop(), isFalse);
    expect(await navigator.maybePop(), isFalse);
    await tester.pumpAndSettle();
    expect(find.byType(EspaciosScreen), findsOneWidget);
  });

  for (final proveedor in ['Google', 'Apple']) {
    testWidgets('$proveedor abre la misma cuenta de demostración', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await pulsar(tester, 'Continuar con $proveedor');

      expect(find.text('Pistas de pádel'), findsOneWidget);
      expect(find.textContaining(DatosDemo.usuario.nombre), findsOneWidget);
      final navigator = Navigator.of(
        tester.element(find.byType(EspaciosScreen)),
      );
      expect(navigator.canPop(), isFalse);
    });
  }

  testWidgets('Registrarse abre registro y permite volver al mismo login', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField).first, 'mi-correo');
    await pulsar(tester, 'Registrarse');

    expect(find.byType(RegistroScreen), findsOneWidget);
    expect(find.text('Crear cuenta'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    final campoCorreo = tester.widget<TextField>(find.byType(TextField).first);
    expect(campoCorreo.controller!.text, 'mi-correo');
  });

  testWidgets('Cerrar sesión limpia el historial y permite acceder otra vez', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await pulsar(tester, 'Entrar');
    expect(find.byTooltip('Cerrar sesión'), findsNothing);
    await pulsar(tester, 'Perfil');
    await pulsar(tester, 'Cerrar sesión');

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(EspaciosScreen), findsNothing);
    final navigator = Navigator.of(tester.element(find.byType(LoginScreen)));
    expect(navigator.canPop(), isFalse);

    await pulsar(tester, 'Entrar');
    expect(find.byType(EspaciosScreen), findsOneWidget);
    expect(find.textContaining(DatosDemo.usuario.nombre), findsOneWidget);
  });

  testWidgets(
    'Login usable con teclado abierto, móvil pequeño y texto grande',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTema.claro,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(2),
              viewInsets: const EdgeInsets.only(bottom: 240),
            ),
            child: child!,
          ),
          home: const LoginScreen(),
        ),
      );

      await tester.ensureVisible(find.byType(TextFormField).last);
      await tester.enterText(find.byType(TextFormField).last, 'otra clave');
      await pulsar(tester, 'Entrar');
      expect(find.byType(EspaciosScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
