import 'package:flutter/material.dart';

import '../../espacios/ui/espacios_screen.dart';
import '../../perfil/ui/perfil_screen.dart';
import '../../reservas/ui/mis_reservas_screen.dart';
import '../theme/app_bordes.dart';
import '../theme/app_espaciado.dart';

enum SeccionPrincipal { espacios, reservas, perfil }

/// Abre una sección principal y retira detalles o formularios anteriores.
void abrirSeccionPrincipal(BuildContext context, SeccionPrincipal seccion) {
  final destino = switch (seccion) {
    SeccionPrincipal.espacios => const EspaciosScreen(),
    SeccionPrincipal.reservas => const MisReservasScreen(),
    SeccionPrincipal.perfil => const PerfilScreen(),
  };
  Navigator.of(context).pushAndRemoveUntil<void>(
    MaterialPageRoute<void>(builder: (context) => destino),
    (route) => false,
  );
}

/// Acceso al perfil compartido por las cabeceras de la sesión.
class AccesoPerfil extends StatelessWidget {
  const AccesoPerfil({super.key, this.seccionActual});

  final SeccionPrincipal? seccionActual;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final seleccionado = seccionActual == SeccionPrincipal.perfil;
    return Semantics(
      selected: seleccionado,
      child: TextButton.icon(
        key: const Key('abrir-perfil'),
        onPressed: () {
          if (!seleccionado) {
            abrirSeccionPrincipal(context, SeccionPrincipal.perfil);
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: colores.primary,
          backgroundColor: seleccionado ? colores.primaryContainer : null,
          padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
        ),
        icon: const Icon(Icons.account_circle_outlined),
        label: const Text('Perfil', maxLines: 1),
      ),
    );
  }
}

/// Barra inferior fija; Scaffold reserva su espacio fuera del contenido.
class NavegacionPrincipal extends StatelessWidget {
  const NavegacionPrincipal({super.key, this.seccionActual});

  final SeccionPrincipal? seccionActual;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      key: const Key('barra-inferior'),
      decoration: BoxDecoration(
        color: colores.surface,
        border: Border(top: BorderSide(color: colores.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppEspaciado.md,
            vertical: AppEspaciado.xs,
          ),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppEspaciado.anchoFormulario,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _boton(
                      context,
                      destino: SeccionPrincipal.espacios,
                      texto: 'Inicio',
                      icono: Icons.home_outlined,
                      iconoSeleccionado: Icons.home,
                    ),
                  ),
                  const SizedBox(width: AppEspaciado.sm),
                  Expanded(
                    child: _boton(
                      context,
                      destino: SeccionPrincipal.reservas,
                      texto: 'Mis reservas',
                      icono: Icons.event_note_outlined,
                      iconoSeleccionado: Icons.event_note,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _boton(
    BuildContext context, {
    required SeccionPrincipal destino,
    required String texto,
    required IconData icono,
    required IconData iconoSeleccionado,
  }) {
    final colores = Theme.of(context).colorScheme;
    final seleccionado = seccionActual == destino;
    return Semantics(
      selected: seleccionado,
      child: OutlinedButton(
        onPressed: () {
          if (!seleccionado) abrirSeccionPrincipal(context, destino);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: seleccionado
              ? colores.primary
              : colores.onSurfaceVariant,
          backgroundColor: seleccionado
              ? colores.primaryContainer
              : colores.surface,
          side: BorderSide(
            color: seleccionado ? colores.primary : colores.outlineVariant,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBordes.medio),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppEspaciado.xs,
            vertical: AppEspaciado.xs,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(seleccionado ? iconoSeleccionado : icono),
            const SizedBox(height: AppEspaciado.xxs),
            Text(texto, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
