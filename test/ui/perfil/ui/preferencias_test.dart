import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/ui/acceso/ui/login_screen.dart';
import 'package:proyecto/ui/core/theme/app_colores.dart';
import 'package:proyecto/ui/core/theme/app_preferencias.dart';
import 'package:proyecto/ui/core/ui/reserva_tarjeta.dart';
import 'package:proyecto/ui/espacios/ui/espacios_screen.dart';
import 'package:proyecto/ui/perfil/ui/perfil_screen.dart';
import 'package:proyecto/ui/reservas/ui/nueva_reserva_screen.dart';

void restaurarPreferencias() {
  AppPreferencias.tema.value = ThemeMode.light;
  AppPreferencias.avisosReservas.value = false;
  AppPreferencias.horarioFavorito.value = 'Tarde';
  AppPreferencias.escalaTexto.value = 1;
  AppPreferencias.apoyoDaltonismo.value = false;
  AppPreferencias.reducirEfectos.value = false;
}

Future<void> pulsar(WidgetTester tester, String texto) async {
  final boton = find.text(texto);
  await tester.ensureVisible(boton);
  await tester.tap(boton);
  await tester.pumpAndSettle();
}

Future<void> elegir<T>(WidgetTester tester, String opcion) async {
  final campo = find.byType(DropdownButtonFormField<T>);
  await tester.ensureVisible(campo);
  await tester.tap(campo);
  await tester.pumpAndSettle();
  await tester.tap(find.text(opcion).last);
  await tester.pumpAndSettle();
}

Future<void> abrirPerfil(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await pulsar(tester, 'Entrar');
  await pulsar(tester, 'Perfil');
}

Future<void> prepararReserva(WidgetTester tester) async {
  await pulsar(tester, 'Inicio');
  final pista = find.byKey(const ValueKey<String>('espacio-card-central'));
  await tester.ensureVisible(pista);
  await tester.tap(pista);
  await tester.pumpAndSettle();
  final reservar = find.widgetWithText(FilledButton, 'Reservar').first;
  await tester.ensureVisible(reservar);
  await tester.tap(reservar);
  await tester.pumpAndSettle();
  expect(find.byType(NuevaReservaScreen), findsOneWidget);
}

void comprobarHorario(String horario) {
  expect(
    find.descendant(
      of: find.byType(DropdownButtonFormField<String>),
      matching: find.text(horario),
    ),
    findsOneWidget,
  );
}

void main() {
  setUp(restaurarPreferencias);
  tearDown(restaurarPreferencias);

  testWidgets('La apariencia elegida se mantiene al navegar y cerrar sesión', (
    tester,
  ) async {
    await abrirPerfil(tester);
    await elegir<ThemeMode>(tester, 'Oscuro');
    expect(
      Theme.of(tester.element(find.byType(PerfilScreen))).brightness,
      Brightness.dark,
    );

    await pulsar(tester, 'Inicio');
    expect(
      Theme.of(tester.element(find.byType(EspaciosScreen))).brightness,
      Brightness.dark,
    );
    await pulsar(tester, 'Perfil');
    await pulsar(tester, 'Cerrar sesión');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(TextFormField).first)).brightness,
      Brightness.dark,
    );
    expect(
      Navigator.of(tester.element(find.byType(LoginScreen))).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('La apariencia Sistema sigue los cambios del dispositivo', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await abrirPerfil(tester);
    expect(
      Theme.of(tester.element(find.byType(PerfilScreen))).brightness,
      Brightness.light,
    );

    await elegir<ThemeMode>(tester, 'Sistema');
    expect(
      Theme.of(tester.element(find.byType(PerfilScreen))).brightness,
      Brightness.dark,
    );
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(PerfilScreen))).brightness,
      Brightness.light,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('El tamaño de texto se aplica a toda la aplicación', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const MyApp());
    expect(
      MediaQuery.textScalerOf(tester.element(find.byType(LoginScreen)))
          .scale(10),
      12,
    );

    await abrirPerfil(tester);
    final controlTexto = tester.widget<Slider>(find.byType(Slider));
    controlTexto.onChanged!(1.4);
    await tester.pumpAndSettle();
    expect(AppPreferencias.escalaTexto.value, 1.4);
    expect(
      MediaQuery.textScalerOf(tester.element(find.byType(PerfilScreen)))
          .scale(10),
      closeTo(16.8, 0.0001),
    );
    expect(find.text('Tamaño del texto: 140 %'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('El apoyo para daltonismo cambia los colores de los estados', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: const ReservaTarjeta(
          nombreEspacio: 'Pista Central',
          fecha: 'Hoy',
          hora: '18:00',
        ),
      ),
    );
    final chipAntes = tester.widget<Chip>(find.byType(Chip));
    expect(chipAntes.labelStyle?.color, AppColores.exito);

    AppPreferencias.apoyoDaltonismo.value = true;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: const ReservaTarjeta(
          nombreEspacio: 'Pista Central',
          fecha: 'Hoy',
          hora: '18:00',
        ),
      ),
    );
    final chipDespues = tester.widget<Chip>(find.byType(Chip));
    expect(chipDespues.labelStyle?.color, AppColores.disponibleDaltonismo);
    expect(find.text('Confirmada'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Horario y avisos modifican la reserva y se conservan al navegar',
    (tester) async {
      await abrirPerfil(tester);
      await elegir<String>(tester, 'Noche');
      final avisos = find.byType(CheckboxListTile);
      await tester.ensureVisible(avisos);
      await tester.tap(avisos);
      await tester.pumpAndSettle();
      expect(tester.widget<CheckboxListTile>(avisos).value, isTrue);

      await prepararReserva(tester);
      comprobarHorario('Noche');
      expect(find.byKey(const Key('aviso-reserva')), findsOneWidget);
      expect(
        find.text('Comprueba el horario y las condiciones antes de reservar.'),
        findsOneWidget,
      );
      await elegir<String>(tester, 'Mañana');
      comprobarHorario('Mañana');

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await pulsar(tester, 'Perfil');
      comprobarHorario('Noche');
      expect(tester.widget<CheckboxListTile>(avisos).value, isTrue);
      await tester.ensureVisible(avisos);
      await tester.tap(avisos);
      await tester.pumpAndSettle();

      await prepararReserva(tester);
      comprobarHorario('Noche');
      expect(find.byKey(const Key('aviso-reserva')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Acceso, registro y perfil no muestran etiquetas de ejemplo', (
    tester,
  ) async {
    final etiquetas = find.textContaining(
      RegExp(
        r'\b(demo|demostración|simulad[oa]s?|ejemplo|fictici[oa]|de prueba)\b',
        caseSensitive: false,
      ),
    );
    await tester.pumpWidget(const MyApp());
    expect(etiquetas, findsNothing);
    await pulsar(tester, 'Registrarse');
    expect(etiquetas, findsNothing);
    final crearCuenta = find.widgetWithText(FilledButton, 'Crear cuenta');
    await tester.ensureVisible(crearCuenta);
    await tester.tap(crearCuenta);
    await tester.pumpAndSettle();
    expect(etiquetas, findsNothing);
    await pulsar(tester, 'Volver al login');
    await pulsar(tester, 'Entrar');
    expect(etiquetas, findsNothing);
    await pulsar(tester, 'Perfil');
    expect(etiquetas, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
