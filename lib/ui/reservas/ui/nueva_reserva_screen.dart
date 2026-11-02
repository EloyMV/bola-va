import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';

/// Añade el formulario en [contenido] y usa Theme.of(context).textTheme.
class NuevaReservaScreen extends StatelessWidget {
  const NuevaReservaScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Nueva reserva',
      subtitulo: 'Haz sitio para tu próxima partida.',
      anchoMaximo: AppEspaciado.anchoFormulario,
      child:
          contenido ??
          const EstadoVacio(
            icono: Icons.calendar_month_outlined,
            titulo: 'Una nueva partida',
            mensaje: 'Aquí aparecerán los detalles de tu próxima reserva.',
          ),
    );
  }
}
