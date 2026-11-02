import 'package:flutter/material.dart';

import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Añade el listado en [contenido] y usa Theme.of(context).textTheme.
class EspaciosScreen extends StatelessWidget {
  const EspaciosScreen({
    super.key,
    this.contenido,
    this.nombreUsuario,
    this.onCerrarSesion,
  });

  final Widget? contenido;
  final String? nombreUsuario;
  final VoidCallback? onCerrarSesion;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Pistas de pádel',
      subtitulo: nombreUsuario == null
          ? 'Tu espacio para jugar.'
          : 'Hola, $nombreUsuario. Acceso simulado.',
      acciones: [
        if (onCerrarSesion != null)
          IconButton(
            onPressed: onCerrarSesion,
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
          ),
      ],
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
