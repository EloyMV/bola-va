import 'package:flutter/material.dart';

import '../../../domain/models/espacio.dart';
import '../../core/theme/app_bordes.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/espacio_imagen.dart';

/// Galería con estado propio: cambiar de foto no reconstruye las demás secciones.
class GaleriaEspacio extends StatefulWidget {
  const GaleriaEspacio({super.key, required this.espacio});

  final Espacio espacio;

  @override
  State<GaleriaEspacio> createState() => _GaleriaEspacioState();
}

class _GaleriaEspacioState extends State<GaleriaEspacio> {
  int _indiceImagenActual = 0;

  @override
  void didUpdateWidget(covariant GaleriaEspacio oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.espacio.id != widget.espacio.id) _indiceImagenActual = 0;
  }

  @override
  Widget build(BuildContext context) {
    final espacio = widget.espacio;
    final tema = Theme.of(context);
    final imagenes = espacio.galeriaImagenes;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppBordes.grande),
          child: SizedBox(
            height: 240,
            child: PageView.builder(
              key: ValueKey<String>('galeria-${espacio.id}'),
              itemCount: imagenes.length,
              onPageChanged: (indice) => setState(() {
                _indiceImagenActual = indice;
              }),
              itemBuilder: (context, indice) => EspacioImagen(
                imagenUrl: imagenes[indice],
                etiqueta: '${espacio.nombre}, imagen ${indice + 1}',
                altura: 240,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppEspaciado.sm),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppEspaciado.xs,
          children: [
            for (var indice = 0; indice < imagenes.length; indice++)
              AnimatedContainer(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                width: indice == _indiceImagenActual ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indice == _indiceImagenActual
                      ? tema.colorScheme.primary
                      : tema.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(AppBordes.redondo),
                ),
              ),
            Text(
              'Foto ${_indiceImagenActual + 1} de ${imagenes.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
