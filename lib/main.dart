import 'package:flutter/material.dart';

import 'ui/core/theme/app_tema.dart';
import 'ui/core/theme/app_preferencias.dart';
import 'ui/acceso/ui/login_screen.dart';
import 'ui/core/ui/configuracion_accesible.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppPreferencias.apariencia,
      builder: (context, child) => MaterialApp(
        title: 'Bola Va',
        debugShowCheckedModeBanner: false,
        theme: AppPreferencias.apoyoDaltonismo.value
            ? AppTema.claroAccesible
            : AppTema.claro,
        darkTheme: AppPreferencias.apoyoDaltonismo.value
            ? AppTema.oscuroAccesible
            : AppTema.oscuro,
        themeMode: AppPreferencias.tema.value,
        themeAnimationDuration: AppPreferencias.reducirEfectos.value
            ? Duration.zero
            : const Duration(milliseconds: 200),
        builder: (context, child) => ConfiguracionAccesible(child: child!),
        home: const LoginScreen(),
      ),
    );
  }
}
