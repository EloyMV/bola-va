import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/ui/acceso/ui/login_screen.dart';
import 'package:proyecto/ui/core/theme/app_preferencias.dart';
import 'package:proyecto/ui/perfil/ui/perfil_screen.dart';

Future<void> pulsar(WidgetTester tester, Finder boton) async {
  await tester.ensureVisible(boton);
  await tester.tap(boton);
  await tester.pumpAndSettle();
}

Future<void> abrirPerfil(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await pulsar(tester, find.text('Entrar'));
  await pulsar(tester, find.text('Perfil'));
}

void restablecer() {
  AppPreferencias.tema.value = ThemeMode.light;
  AppPreferencias.escalaTexto.value = 1;
  AppPreferencias.apoyoDaltonismo.value = false;
  AppPreferencias.reducirEfectos.value = false;
}

void main() {
  setUp(restablecer);
  tearDown(restablecer);

  testWidgets('Daltonismo actualiza la vista previa sin salir del perfil', (
    tester,
  ) async {
    await abrirPerfil(tester);
    final libre = find.widgetWithText(Chip, 'Libre');
    final colorInicial = tester.widget<Chip>(libre).labelStyle!.color;
    await pulsar(
      tester,
      find.widgetWithText(SwitchListTile, 'Apoyo para daltonismo rojo-verde'),
    );

    expect(tester.widget<Chip>(libre).labelStyle!.color, isNot(colorInicial));
    expect(find.text('Libre'), findsOneWidget);
    expect(find.text('Pendiente'), findsOneWidget);
    expect(find.text('Cancelada'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Reducir efectos se aplica al acceso y restablecer respeta el sistema',
    (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await abrirPerfil(tester);
      final slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChanged!(1.4);
      await tester.pumpAndSettle();
      await pulsar(tester, find.byKey(const Key('reducir-efectos')));
      expect(
        MediaQuery.disableAnimationsOf(
          tester.element(find.byType(PerfilScreen)),
        ),
        isTrue,
      );
      await pulsar(tester, find.text('Cerrar sesión'));
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(
        MediaQuery.disableAnimationsOf(
          tester.element(find.byType(LoginScreen)),
        ),
        isTrue,
      );

      await pulsar(tester, find.text('Entrar'));
      await pulsar(tester, find.text('Perfil'));
      await pulsar(tester, find.byKey(const Key('restablecer-accesibilidad')));
      final contexto = tester.element(find.byType(PerfilScreen));
      expect(MediaQuery.textScalerOf(contexto).scale(10), closeTo(12, 0.001));
      expect(MediaQuery.disableAnimationsOf(contexto), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Perfil sigue usable a 160 % con letra del sistema ampliada y modo oscuro',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      AppPreferencias.tema.value = ThemeMode.dark;
      AppPreferencias.escalaTexto.value = 1.6;
      await abrirPerfil(tester);
      expect(find.text('Accesibilidad'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await pulsar(tester, find.byKey(const Key('restablecer-accesibilidad')));
      await pulsar(tester, find.text('Cerrar sesión'));
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
