import 'package:flutter/material.dart';

import 'login_screen.dart';

/// Abre un acceso nuevo y retira todas las pantallas de la sesión anterior.
void cerrarSesion(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil<void>(
    MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}
