import 'package:flutter/material.dart';

import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Añade las reservas en [contenido] y usa Theme.of(context).textTheme.
class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Mis reservas',
      subtitulo: 'Tus encuentros con la pista.',
      child:
          contenido ??
          const EstadoVacio(
            icono: Icons.event_note_outlined,
            titulo: 'Todavía no hay reservas',
            mensaje: 'Tus próximas partidas aparecerán aquí.',
          ),
    );
  }
}
