import 'package:flutter/material.dart';

/// Campo compartido por login y registro, configurado mediante parámetros.
class CampoAcceso extends StatelessWidget {
  const CampoAcceso({
    super.key,
    required this.etiqueta,
    required this.icono,
    this.valorInicial = '',
    this.tipoTeclado = TextInputType.text,
    this.esContrasena = false,
  });

  final String etiqueta;
  final IconData icono;
  final String valorInicial;
  final TextInputType tipoTeclado;
  final bool esContrasena;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: valorInicial,
      decoration: InputDecoration(labelText: etiqueta, prefixIcon: Icon(icono)),
      keyboardType: tipoTeclado,
      obscureText: esContrasena,
      autocorrect: false,
      enableSuggestions: !esContrasena,
      textInputAction: esContrasena
          ? TextInputAction.done
          : TextInputAction.next,
    );
  }
}
