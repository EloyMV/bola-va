import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Añade el formulario en [contenido] y usa Theme.of(context).textTheme.
class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Crear cuenta',
      subtitulo: 'Nos vemos en la pista.',
      anchoMaximo: AppEspaciado.anchoFormulario,
      centrarContenido: true,
      child:
          contenido ??
          const EstadoVacio(
            icono: Icons.person_add_outlined,
            titulo: 'Únete al club',
            mensaje: 'Un lugar para disfrutar de tus próximas partidas.',
          ),
    );
  }
}
