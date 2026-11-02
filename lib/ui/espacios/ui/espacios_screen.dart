import 'package:flutter/material.dart';

import '../../../data/services/datos_demo.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/espacio_tarjeta.dart';
import '../../core/ui/pagina_base.dart';
import '../../perfil/ui/perfil_screen.dart';
import '../../reservas/ui/mis_reservas_screen.dart';
import 'espacio_detalle_screen.dart';

class EspaciosScreen extends StatelessWidget {
  const EspaciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Pistas de pádel',
      subtitulo: 'Encuentra el espacio perfecto para tu próxima partida.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppEspaciado.sm,
            runSpacing: AppEspaciado.sm,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const MisReservasScreen(),
                  ),
                ),
                icon: const Icon(Icons.event_note_outlined),
                label: const Text('Mis reservas'),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const PerfilScreen(),
                  ),
                ),
                icon: const Icon(Icons.person_outline),
                label: const Text('Perfil'),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.lg),
          Text(
            '${DatosDemo.espacios.length} espacios disponibles',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppEspaciado.md),
          LayoutBuilder(
            builder: (context, constraints) {
              const separacion = AppEspaciado.md;
              final columnas = constraints.maxWidth >= 700 ? 2 : 1;
              final anchoTarjeta =
                  (constraints.maxWidth - separacion * (columnas - 1)) /
                  columnas;

              return Wrap(
                spacing: separacion,
                runSpacing: separacion,
                children: [
                  for (final espacio in DatosDemo.espacios)
                    SizedBox(
                      key: ValueKey<String>('espacio-card-${espacio.id}'),
                      width: anchoTarjeta,
                      child: EspacioTarjeta(
                        espacio: espacio,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                EspacioDetalleScreen(espacio: espacio),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
