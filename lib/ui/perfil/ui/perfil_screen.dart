import 'package:flutter/material.dart';

import '../../../data/services/datos_demo.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../domain/models/reserva.dart';
import '../../acceso/ui/cerrar_sesion.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/pagina_base.dart';
import '../../core/ui/navegacion_principal.dart';
import '../../core/ui/seccion_contenido.dart';
import 'accesibilidad_perfil.dart';
import 'preferencias_perfil.dart';
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
          const NavegacionPrincipal(seccionActual: SeccionPrincipal.perfil),
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
                      const AccesibilidadPerfil(),
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
    return SeccionContenido(
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
          ValueListenableBuilder<List<Reserva>>(
            valueListenable: ReservasRepository.reservas,
            builder: (context, reservas, child) {
              final cantidad = ReservasRepository.proximas().length;
              return Text(
                cantidad == 0
                    ? 'Todavía no tienes reservas.'
                    : 'Tienes $cantidad ${cantidad == 1 ? 'reserva próxima' : 'reservas próximas'}.',
              );
            },
          ),
          const SizedBox(height: AppEspaciado.sm),
          const Text('Consulta los espacios y prepara tu próxima partida.'),
        ],
      ),
    );
  }

  Widget _informacionAplicacion(BuildContext context) {
    return SeccionContenido(
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
