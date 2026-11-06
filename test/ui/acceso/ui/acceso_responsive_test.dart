import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/ui/acceso/ui/login_screen.dart';
import 'package:proyecto/ui/acceso/ui/registro_screen.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/espacios/ui/espacios_screen.dart';

Future<void> pulsar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto));
  await tester.tap(find.text(texto));
  await tester.pumpAndSettle();
}

void configurarVista(WidgetTester tester, Size tamano) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = tamano;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

void main() {
  testWidgets(
    'El recorrido de acceso funciona en la composición de escritorio',
    (tester) async {
      configurarVista(tester, const Size(1440, 900));
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.text('Bola Va'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await pulsar(tester, 'Registrarse');
      expect(find.byType(RegistroScreen), findsOneWidget);
      await pulsar(tester, 'Crear cuenta de prueba');
      expect(find.byType(AlertDialog), findsOneWidget);
      await pulsar(tester, 'Volver al login');
      expect(find.byType(BackButton), findsNothing);
      await pulsar(tester, 'Entrar');
      expect(find.byType(EspaciosScreen), findsOneWidget);
      await tester.tap(find.byTooltip('Cerrar sesión'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Texto grande y movimiento reducido mantienen el formulario usable',
    (tester) async {
      configurarVista(tester, const Size(1024, 640));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTema.claro,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(2),
              disableAnimations: true,
            ),
            child: child!,
          ),
          home: const LoginScreen(),
        ),
      );
      await pulsar(tester, 'Registrarse');
      await tester.ensureVisible(find.byType(TextFormField).last);
      await tester.enterText(
        find.byType(TextFormField).last,
        'clave de prueba',
      );
      await pulsar(tester, 'Crear cuenta de prueba');
      await pulsar(tester, 'Volver al login');
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
