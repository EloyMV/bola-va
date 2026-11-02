import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Añade el formulario en [contenido] y usa Theme.of(context).textTheme.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Iniciar sesión',
      subtitulo: 'Tu próxima partida empieza aquí.',
      anchoMaximo: AppEspaciado.anchoFormulario,
      centrarContenido: true,
      child:
          contenido ??
          const EstadoVacio(
            icono: Icons.sports_tennis,
            titulo: 'Bienvenido al club',
            mensaje: 'Todo listo para volver a la pista.',
          ),
    );
  }
}
