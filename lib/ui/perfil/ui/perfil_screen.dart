import 'package:flutter/material.dart';

import '../../../data/services/datos_demo.dart';
import '../../acceso/ui/cerrar_sesion.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/pagina_base.dart';
import '../../espacios/ui/espacios_screen.dart';
import '../../reservas/ui/mis_reservas_screen.dart';
import 'preferencias_perfil.dart';
import 'seccion_perfil.dart';
import 'tarjeta_usuario.dart';

/// Información del usuario y ajustes compartidos de la aplicación.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Perfil y ajustes',
      subtitulo: 'Tu cuenta, tus preferencias y la próxima partida.',
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
                        builder: (_) => const MisReservasScreen(),
                      ),
                    ),
                icon: const Icon(Icons.event_note_outlined),
                label: const Text('Mis reservas'),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.lg),
          contenido ??
              LayoutBuilder(
                builder: (context, constraints) {
                  final cuenta = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const TarjetaUsuario(usuario: DatosDemo.usuario),
                      const SizedBox(height: AppEspaciado.lg),
                      _actividad(context),
                    ],
                  );
                  final ajustes = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const PreferenciasPerfil(),
                      const SizedBox(height: AppEspaciado.lg),
                      _informacionAplicacion(context),
                      const SizedBox(height: AppEspaciado.lg),
                      OutlinedButton.icon(
                        onPressed: () => cerrarSesion(context),
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar sesión'),
                      ),
                    ],
                  );

                  final textoGrande =
                      MediaQuery.textScalerOf(context).scale(16) > 24;
                  if (constraints.maxWidth >= 760 && !textoGrande) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: cuenta),
                        const SizedBox(width: AppEspaciado.lg),
                        Expanded(flex: 5, child: ajustes),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      cuenta,
                      const SizedBox(height: AppEspaciado.lg),
                      ajustes,
                    ],
                  );
                },
              ),
        ],
      ),
    );
  }

  Widget _actividad(BuildContext context) {
    return SeccionPerfil(
      titulo: 'La pista te espera',
      icono: Icons.sports_tennis_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${DatosDemo.espacios.length} pistas para descubrir',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppEspaciado.xs),
          const Text('Todavía no tienes reservas.'),
          const SizedBox(height: AppEspaciado.sm),
          const Text('Consulta los espacios y prepara tu próxima partida.'),
        ],
      ),
    );
  }

  Widget _informacionAplicacion(BuildContext context) {
    return SeccionPerfil(
      titulo: 'Sobre Bola Va',
      icono: Icons.info_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/bola_va_icono.png',
                width: AppEspaciado.xxl,
                height: AppEspaciado.xxl,
                excludeFromSemantics: true,
              ),
              const SizedBox(width: AppEspaciado.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bola Va',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppEspaciado.xxs),
                    // Igual que version en pubspec.yaml.
                    const Text('Versión 1.0.0 · Compilación 1'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.md),
          const Text(
            'Aplicación de reservas de pistas de pádel desarrollada en Flutter. '
            'Encuentra tu pista y prepara tu próxima partida.',
          ),
        ],
      ),
    );
  }
}
