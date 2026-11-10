import 'package:flutter/material.dart';

import '../formatters/formatos.dart';
import '../theme/app_espaciado.dart';

class LineaPrecio extends StatelessWidget {
  const LineaPrecio({
    super.key,
    required this.etiqueta,
    required this.importe,
    this.total = false,
  });

  final String etiqueta;
  final double importe;
  final bool total;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final estilo = total
        ? tema.textTheme.titleMedium
        : tema.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppEspaciado.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(etiqueta, style: estilo)),
          const SizedBox(width: AppEspaciado.sm),
          Flexible(
            child: Text(
              '${formatearPrecio(importe)} €',
              textAlign: TextAlign.end,
              style: estilo,
            ),
          ),
        ],
      ),
    );
  }
}
