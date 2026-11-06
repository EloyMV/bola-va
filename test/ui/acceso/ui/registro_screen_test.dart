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

Future<void> abrirRegistro(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await pulsar(tester, 'Registrarse');
}

void main() {
  testWidgets('Registro muestra etiquetas y oculta ambas contraseñas', (
    tester,
  ) async {
    await abrirRegistro(tester);

    for (final etiqueta in [
      'Nombre y apellidos',
      'Correo electrónico',
      'Contraseña',
      'Repetir contraseña',
    ]) {
      expect(find.text(etiqueta), findsOneWidget);
    }
    expect(find.text('Registro simulado'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    final campos = tester
        .widgetList<TextField>(find.byType(TextField))
        .toList();
    expect(campos[2].obscureText, isTrue);
    expect(campos[3].obscureText, isTrue);
  });

  testWidgets('Confirmar no valida datos y vuelve al login antes de entrar', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField).first, 'correo previo');
    await pulsar(tester, 'Registrarse');
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'correo sin formato',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'una clave');
    await tester.enterText(find.byType(TextFormField).at(3), 'otra clave');
    await pulsar(tester, 'Crear cuenta de prueba');

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.textContaining('no se ha creado ninguna cuenta'),
      findsOneWidget,
    );
    expect(find.byType(EspaciosScreen), findsNothing);

    await pulsar(tester, 'Volver al login');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(RegistroScreen), findsNothing);
    expect(find.byType(EspaciosScreen), findsNothing);
    final campoCorreo = tester.widget<TextField>(find.byType(TextField).first);
    expect(campoCorreo.controller!.text, 'correo previo');

    await pulsar(tester, 'Entrar');
    expect(find.byType(EspaciosScreen), findsOneWidget);
    expect(find.textContaining('Usuario demo'), findsOneWidget);
  });

  testWidgets('Se puede cerrar la confirmación y usar el enlace al login', (
    tester,
  ) async {
    await abrirRegistro(tester);
    await pulsar(tester, 'Crear cuenta de prueba');
    await pulsar(tester, 'Seguir aquí');

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(RegistroScreen), findsOneWidget);
    await pulsar(tester, 'Volver al inicio de sesión');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(EspaciosScreen), findsNothing);
  });

  testWidgets(
    'Atrás cierra el diálogo y después vuelve del registro al login',
    (tester) async {
      await abrirRegistro(tester);
      await pulsar(tester, 'Crear cuenta de prueba');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(RegistroScreen), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(RegistroScreen), findsNothing);
    },
  );

  testWidgets('Al reabrir registro vuelven los datos fijos de demostración', (
    tester,
  ) async {
    await abrirRegistro(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'Otro nombre');
    await tester.enterText(find.byType(TextFormField).at(2), 'otra clave');
    await pulsar(tester, 'Volver al inicio de sesión');
    await pulsar(tester, 'Registrarse');

    final campos = tester
        .widgetList<TextField>(find.byType(TextField))
        .toList();
    expect(campos[0].controller!.text, 'Usuario Demo');
    expect(campos[2].controller!.text, 'demopadel');
  });

  testWidgets(
    'Registro y diálogo admiten teclado, móvil pequeño y texto grande',
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
      await pulsar(tester, 'Registrarse');
      await tester.ensureVisible(find.byType(TextFormField).last);
      await tester.enterText(find.byType(TextFormField).last, 'otra clave');
      await pulsar(tester, 'Crear cuenta de prueba');

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
      await pulsar(tester, 'Volver al login');
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
