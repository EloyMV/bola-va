import 'package:flutter/material.dart';

import 'ui/core/theme/app_tema.dart';
import 'ui/espacios/ui/espacios_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bola Va',
      debugShowCheckedModeBanner: false,
      theme: AppTema.claro,
      themeMode: ThemeMode.light,
      home: const EspaciosScreen(),
    );
  }
}
