import 'package:flutter/material.dart';

import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Añade los detalles en [contenido] y usa Theme.of(context).textTheme.
class EspacioDetalleScreen extends StatelessWidget {
  const EspacioDetalleScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Detalle de la pista',
      subtitulo: 'Conoce el lugar de tu próxima partida.',
      child:
          contenido ??
          const EstadoVacio(
            icono: Icons.info_outline,
            titulo: 'Información de la pista',
            mensaje: 'Aquí encontrarás sus características y servicios.',
          ),
    );
  }
}
