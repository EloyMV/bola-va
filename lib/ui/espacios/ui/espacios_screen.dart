import 'package:flutter/material.dart';

import '../../../data/services/datos_demo.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/espacio_tarjeta.dart';
import '../../core/ui/pagina_base.dart';
import '../../core/ui/navegacion_principal.dart';
import 'espacio_detalle_screen.dart';

class EspaciosScreen extends StatelessWidget {
  const EspaciosScreen({super.key, this.contenido, this.nombreUsuario});

  final Widget? contenido;
  final String? nombreUsuario;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Pistas de pádel',
      subtitulo: 'Hola, ${nombreUsuario ?? DatosDemo.usuario.nombre}.',
      seccionActual: SeccionPrincipal.espacios,
      child:
          contenido ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${DatosDemo.espacios.length} espacios disponibles',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppEspaciado.md),
              LayoutBuilder(
                builder: (context, constraints) {
                  const separacion = AppEspaciado.md;
                  final columnas = constraints.maxWidth >= 700 ? 2 : 1;
                  final anchoTarjeta =
                      (constraints.maxWidth - separacion * (columnas - 1)) /
                      columnas;

                  return Wrap(
                    spacing: separacion,
                    runSpacing: separacion,
                    children: [
                      for (final espacio in DatosDemo.espacios)
                        SizedBox(
                          key: ValueKey<String>('espacio-card-${espacio.id}'),
                          width: anchoTarjeta,
                          child: EspacioTarjeta(
                            espacio: espacio,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) =>
                                    EspacioDetalleScreen(espacio: espacio),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
    );
  }
}
