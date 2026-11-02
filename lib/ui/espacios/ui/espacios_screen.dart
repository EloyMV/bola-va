import 'package:flutter/material.dart';

import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Añade el listado en [contenido] y usa Theme.of(context).textTheme.
class EspaciosScreen extends StatelessWidget {
  const EspaciosScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Pistas de pádel',
      subtitulo: 'Tu espacio para jugar.',
      child:
          contenido ??
          const EstadoVacio(
            icono: Icons.sports_tennis,
            titulo: 'Todavía no hay pistas',
            mensaje: 'Las pistas del club aparecerán aquí.',
          ),
    );
  }
}
