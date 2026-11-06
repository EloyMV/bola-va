import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/ui/acceso/ui/login_screen.dart';
import 'package:proyecto/ui/acceso/ui/registro_screen.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/core/ui/espacio_tarjeta.dart';
import 'package:proyecto/ui/core/ui/pagina_base.dart';
import 'package:proyecto/ui/core/ui/reserva_tarjeta.dart';
import 'package:proyecto/ui/espacios/ui/espacio_detalle_screen.dart';
import 'package:proyecto/ui/espacios/ui/espacios_screen.dart';
import 'package:proyecto/ui/perfil/ui/perfil_screen.dart';
import 'package:proyecto/ui/reservas/ui/mis_reservas_screen.dart';
import 'package:proyecto/ui/reservas/ui/nueva_reserva_screen.dart';

Widget appDePrueba(Widget pantalla, {double teclado = 0}) {
  return MaterialApp(
    theme: AppTema.claro,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(2),
        viewInsets: EdgeInsets.only(bottom: teclado),
      ),
      child: child!,
    ),
    home: pantalla,
  );
}

void usarMovilPequeno(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(320, 568);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

void main() {
  testWidgets('La aplicación abre el login con la contraseña oculta', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Bola Va'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    final campoClave = tester.widget<TextField>(find.byType(TextField).at(1));
    expect(campoClave.obscureText, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('El último espacio es accesible y abre su detalle', (
    tester,
  ) async {
    usarMovilPequeno(tester);
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Entrar'));
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    const tarjetaFinal = ValueKey<String>('espacio-card-pro');
    expect(find.byType(EspacioTarjeta), findsNWidgets(6));
    await tester.ensureVisible(find.byKey(tarjetaFinal));
    await tester.pumpAndSettle();
    expect(find.text('Pista Pro'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(tarjetaFinal),
        matching: find.text('Hasta 4 jugadores'),
      ),
      findsOneWidget,
    );
    expect(find.text('Competición'), findsOneWidget);

    await tester.tap(find.byKey(tarjetaFinal));
    await tester.pumpAndSettle();
    expect(find.text('Pista Pro'), findsOneWidget);
    expect(find.text('Aforo'), findsOneWidget);
    expect(find.text('4 jugadores'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Las siete plantillas admiten móvil pequeño y texto grande', (
    tester,
  ) async {
    usarMovilPequeno(tester);
    for (final pantalla in const <Widget>[
      LoginScreen(),
      RegistroScreen(),
      EspaciosScreen(),
      EspacioDetalleScreen(),
      NuevaReservaScreen(),
      MisReservasScreen(),
      PerfilScreen(),
    ]) {
      await tester.pumpWidget(appDePrueba(pantalla));
      expect(tester.takeException(), isNull, reason: '$pantalla');
    }
  });

  testWidgets('Un formulario largo sigue siendo accesible con el teclado', (
    tester,
  ) async {
    usarMovilPequeno(tester);
    var pulsado = false;
    const boton = Key('continuar');
    await tester.pumpWidget(
      appDePrueba(
        LoginScreen(
          contenido: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < 6; i++)
                TextField(decoration: InputDecoration(labelText: 'Campo $i')),
              FilledButton(
                key: boton,
                onPressed: () => pulsado = true,
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
        teclado: 240,
      ),
    );
    await tester.ensureVisible(find.byKey(boton));
    await tester.tap(find.byKey(boton));
    await tester.pump();
    expect(pulsado, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Las tarjetas ajustan textos largos sin desbordarse', (
    tester,
  ) async {
    usarMovilPequeno(tester);
    await tester.pumpWidget(
      appDePrueba(
        const PaginaBase(
          titulo: 'Reservas',
          child: Column(
            children: [
              EspacioTarjeta(
                nombre: 'Pista panorámica exterior del club de pádel',
                ubicacion:
                    'Avenida de las instalaciones deportivas, número 123',
                precio: '24,00 € por una hora y media',
                disponible: false,
              ),
              ReservaTarjeta(
                nombreEspacio: 'Pista panorámica exterior del club de pádel',
                fecha: 'Lunes, 2 de noviembre de 2026',
                hora: 'De 18:00 a 19:30',
                estado: EstadoReserva.cancelada,
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Ocupado'), findsOneWidget);
    expect(find.text('Cancelada'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
