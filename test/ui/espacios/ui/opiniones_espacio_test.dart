import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/data/repositories/comentarios_repository.dart';
import 'package:proyecto/domain/models/comentario.dart';
import 'package:proyecto/domain/models/espacio.dart';
import 'package:proyecto/ui/core/theme/app_tema.dart';
import 'package:proyecto/ui/espacios/ui/opiniones_espacio.dart';

const pistaCentral = Espacio(
  id: 'opiniones-central',
  nombre: 'Pista Central',
  ubicacion: 'Valencia',
  capacidad: 4,
  actividades: ['Pádel'],
  imagenUrl: '',
  descripcion: 'Pista cubierta',
  opiniones: [
    Comentario(
      autor: 'María López',
      fecha: '10/11/2026',
      texto: 'Buena iluminación.',
      puntuacion: 4,
    ),
  ],
);

const pistaExterior = Espacio(
  id: 'opiniones-exterior',
  nombre: 'Pista Exterior',
  ubicacion: 'Valencia',
  capacidad: 4,
  actividades: ['Pádel'],
  imagenUrl: '',
  descripcion: 'Pista al aire libre',
  opiniones: [
    Comentario(
      autor: 'Pedro Ruiz',
      fecha: '10/11/2026',
      texto: 'Hay mucho espacio.',
      puntuacion: 3,
    ),
  ],
);

Widget appDeOpiniones() => MaterialApp(
  theme: AppTema.claro,
  home: Builder(
    builder: (context) => Scaffold(
      body: Column(
        children: [
          for (final espacio in [pistaCentral, pistaExterior])
            TextButton(
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: Text(espacio.nombre)),
                    body: SingleChildScrollView(
                      child: OpinionesEspacio(espacio: espacio),
                    ),
                  ),
                ),
              ),
              child: Text(espacio.nombre),
            ),
        ],
      ),
    ),
  ),
);

Future<void> abrirPista(WidgetTester tester, Espacio espacio) async {
  await tester.tap(find.text(espacio.nombre));
  await tester.pumpAndSettle();
}

Future<void> publicarOpinion(WidgetTester tester, String texto) async {
  await tester.enterText(find.byType(TextField), texto);
  final publicar = find.text('Publicar opinión');
  await tester.ensureVisible(publicar);
  await tester.tap(publicar);
  await tester.pumpAndSettle();
}

void main() {
  setUp(ComentariosRepository.restablecer);
  tearDown(ComentariosRepository.restablecer);

  testWidgets(
    'La opinión y la media se conservan al salir y reabrir la pista',
    (tester) async {
      await tester.pumpWidget(appDeOpiniones());
      await abrirPista(tester, pistaCentral);
      await publicarOpinion(tester, 'Volveremos a jugar aquí.');
      await tester.pageBack();
      await tester.pumpAndSettle();
      await abrirPista(tester, pistaCentral);

      expect(find.text('Volveremos a jugar aquí.'), findsOneWidget);
      expect(find.text('Buena iluminación.'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('· 2 valoraciones'), findsOneWidget);
      expect(pistaCentral.opiniones, hasLength(1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Publicar en una pista no cambia las opiniones de otra', (
    tester,
  ) async {
    await tester.pumpWidget(appDeOpiniones());
    await abrirPista(tester, pistaCentral);
    await publicarOpinion(tester, 'Una partida estupenda.');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await abrirPista(tester, pistaExterior);

    expect(find.text('Una partida estupenda.'), findsNothing);
    expect(find.text('Buena iluminación.'), findsNothing);
    expect(find.text('Hay mucho espacio.'), findsOneWidget);
    expect(find.text('3.0'), findsOneWidget);
    expect(find.text('· 1 valoración'), findsOneWidget);
    expect(pistaExterior.opiniones, hasLength(1));
    expect(tester.takeException(), isNull);
  });
}
