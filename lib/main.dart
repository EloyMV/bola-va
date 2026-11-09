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
      builder: (context, modoTema, child) => MaterialApp(
        title: 'Bola Va',
        debugShowCheckedModeBanner: false,
        theme: AppTema.claro,
        darkTheme: AppTema.oscuro,
        themeMode: modoTema,
        home: const LoginScreen(),
      ),
    );
  }
}
