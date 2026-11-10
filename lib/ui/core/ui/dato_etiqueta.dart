import 'package:flutter/material.dart';

import '../theme/app_espaciado.dart';

/// Etiqueta y valor en vertical para admitir textos largos o ampliados.
class DatoEtiqueta extends StatelessWidget {
  const DatoEtiqueta({super.key, required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(etiqueta, style: tema.textTheme.labelLarge),
          Text(valor, style: tema.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
