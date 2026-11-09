import 'package:flutter/material.dart';

import 'ui/core/theme/app_tema.dart';
import 'ui/core/theme/app_preferencias.dart';
import 'ui/acceso/ui/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppPreferencias.tema,
      builder: (context, modoTema, child) => ValueListenableBuilder<double>(
        valueListenable: AppPreferencias.escalaTexto,
        builder: (context, escalaTexto, child) => MaterialApp(
          title: 'Bola Va',
          debugShowCheckedModeBanner: false,
          theme: AppTema.claro,
          darkTheme: AppTema.oscuro,
          themeMode: modoTema,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: _EscalaDeTexto(mediaQuery.textScaler, escalaTexto),
              ),
              child: child!,
            );
          },
          home: const LoginScreen(),
        ),
      ),
    );
  }
}

class _EscalaDeTexto extends TextScaler {
  const _EscalaDeTexto(this.escaladorBase, this.escalaPreferida);

  final TextScaler escaladorBase;
  final double escalaPreferida;

  @override
  double scale(double fontSize) =>
      escaladorBase.scale(fontSize) * escalaPreferida;

  @override
  double get textScaleFactor => escaladorBase.scale(14) / 14 * escalaPreferida;

  @override
  bool operator ==(Object other) =>
      other is _EscalaDeTexto &&
      other.escaladorBase == escaladorBase &&
      other.escalaPreferida == escalaPreferida;

  @override
  int get hashCode => Object.hash(escaladorBase, escalaPreferida);
}
