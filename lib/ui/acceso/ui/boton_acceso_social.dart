import 'package:flutter/material.dart';

/// Cada proveedor comparte el aspecto; su nombre, icono y acción son parámetros.
class BotonAccesoSocial extends StatelessWidget {
  const BotonAccesoSocial({
    super.key,
    required this.proveedor,
    required this.icono,
    required this.onPressed,
  });

  final String proveedor;
  final IconData icono;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono),
      label: Text('Continuar con $proveedor (simulado)'),
    );
  }
}
