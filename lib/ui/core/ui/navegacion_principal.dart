import 'package:flutter/material.dart';

import '../../espacios/ui/espacios_screen.dart';
import '../../perfil/ui/perfil_screen.dart';
import '../../reservas/ui/mis_reservas_screen.dart';
import '../theme/app_espaciado.dart';

enum SeccionPrincipal { espacios, reservas, perfil }

/// Sustituye la sección actual para no acumular rutas al cambiar de pestaña.
class NavegacionPrincipal extends StatelessWidget {
  const NavegacionPrincipal({super.key, required this.seccionActual});

  final SeccionPrincipal seccionActual;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppEspaciado.sm,
      runSpacing: AppEspaciado.sm,
      children: [
        if (seccionActual != SeccionPrincipal.espacios)
          OutlinedButton.icon(
            onPressed: () => _abrir(context, const EspaciosScreen()),
            icon: const Icon(Icons.sports_tennis_outlined),
            label: const Text('Espacios'),
          ),
        if (seccionActual != SeccionPrincipal.reservas)
          OutlinedButton.icon(
            onPressed: () => _abrir(context, const MisReservasScreen()),
            icon: const Icon(Icons.event_note_outlined),
            label: const Text('Mis reservas'),
          ),
        if (seccionActual != SeccionPrincipal.perfil)
          OutlinedButton.icon(
            onPressed: () => _abrir(context, const PerfilScreen()),
            icon: const Icon(Icons.person_outline),
            label: const Text('Perfil'),
          ),
      ],
    );
  }

  void _abrir(BuildContext context, Widget destino) {
    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(builder: (context) => destino),
    );
  }
}
