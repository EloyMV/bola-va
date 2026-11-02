import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Añade los datos en [contenido] y usa Theme.of(context).textTheme.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Mi perfil',
      subtitulo: 'Tu espacio en el club.',
      anchoMaximo: AppEspaciado.anchoFormulario,
      child:
          contenido ??
          const EstadoVacio(
            icono: Icons.person_outline,
            titulo: 'Tu perfil de jugador',
            mensaje: 'Aquí aparecerán los datos de tu cuenta.',
          ),
    );
  }
}
