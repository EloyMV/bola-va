import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';
import '../../espacios/ui/espacios_screen.dart';
import '../../perfil/ui/perfil_screen.dart';

/// Añade las reservas en [contenido] y usa Theme.of(context).textTheme.
class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Mis reservas',
      subtitulo: 'Tus encuentros con la pista.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppEspaciado.sm,
            runSpacing: AppEspaciado.sm,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context)
                    .pushReplacement<void, void>(
                      MaterialPageRoute<void>(
                        builder: (_) => const EspaciosScreen(),
                      ),
                    ),
                icon: const Icon(Icons.sports_tennis_outlined),
                label: const Text('Espacios'),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context)
                    .pushReplacement<void, void>(
                      MaterialPageRoute<void>(
                        builder: (_) => const PerfilScreen(),
                      ),
                    ),
                icon: const Icon(Icons.person_outline),
                label: const Text('Perfil'),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.lg),
          contenido ??
              const EstadoVacio(
                icono: Icons.event_note_outlined,
                titulo: 'Todavía no hay reservas',
                mensaje: 'Tus próximas partidas aparecerán aquí.',
              ),
        ],
      ),
    );
  }
}
