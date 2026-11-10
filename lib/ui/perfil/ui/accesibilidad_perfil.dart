import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import '../../core/theme/app_preferencias.dart';
import '../../core/theme/colores_estado.dart';
import '../../core/ui/seccion_contenido.dart';

class AccesibilidadPerfil extends StatelessWidget {
  const AccesibilidadPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return SeccionContenido(
      titulo: 'Accesibilidad',
      icono: Icons.accessibility_new,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<double>(
            valueListenable: AppPreferencias.escalaTexto,
            builder: (context, escala, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  liveRegion: true,
                  child: Text(
                    'Tamaño del texto: ${(escala * 100).round()} %',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: AppEspaciado.xs),
                Row(
                  children: [
                    const Icon(Icons.text_decrease),
                    Expanded(
                      child: Slider(
                        value: escala,
                        min: 0.8,
                        max: 1.6,
                        divisions: 8,
                        label: '${(escala * 100).round()} %',
                        semanticFormatterCallback: (valor) =>
                            '${(valor * 100).round()} por ciento',
                        onChanged: (valor) {
                          AppPreferencias.escalaTexto.value = valor;
                        },
                      ),
                    ),
                    const Icon(Icons.text_increase),
                  ],
                ),
                const Text(
                  'Ajusta el texto respetando también el tamaño del dispositivo.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppEspaciado.md),
          ValueListenableBuilder<bool>(
            valueListenable: AppPreferencias.apoyoDaltonismo,
            builder: (context, apoyo, child) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Apoyo para daltonismo rojo-verde'),
              subtitle: const Text(
                'Distingue los estados con colores, texto e iconos.',
              ),
              value: apoyo,
              onChanged: (valor) {
                AppPreferencias.apoyoDaltonismo.value = valor;
              },
            ),
          ),
          Wrap(
            spacing: AppEspaciado.xs,
            runSpacing: AppEspaciado.xs,
            children: [
              _estado(
                'Libre',
                Icons.check_circle_outline,
                ColoresEstado.disponible(context),
              ),
              _estado(
                'Pendiente',
                Icons.schedule,
                ColoresEstado.pendiente(context),
              ),
              _estado(
                'Cancelada',
                Icons.cancel_outlined,
                ColoresEstado.cancelada(context),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.md),
          ValueListenableBuilder<bool>(
            valueListenable: AppPreferencias.reducirEfectos,
            builder: (context, reducir, child) => SwitchListTile(
              key: const Key('reducir-efectos'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Reducir efectos'),
              subtitle: const Text(
                'Reduce las animaciones decorativas de entrada y cambio de tema.',
              ),
              value: reducir,
              onChanged: (valor) {
                AppPreferencias.reducirEfectos.value = valor;
              },
            ),
          ),
          const SizedBox(height: AppEspaciado.sm),
          TextButton.icon(
            key: const Key('restablecer-accesibilidad'),
            onPressed: () {
              AppPreferencias.escalaTexto.value = 1;
              AppPreferencias.apoyoDaltonismo.value = false;
              AppPreferencias.reducirEfectos.value = false;
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Restablecer accesibilidad'),
          ),
        ],
      ),
    );
  }

  Widget _estado(String texto, IconData icono, Color color) {
    return Chip(
      avatar: Icon(icono, color: color, size: 18),
      label: Text(texto),
      labelStyle: TextStyle(color: color),
      side: BorderSide(color: color),
      backgroundColor: color.withValues(alpha: 0.08),
    );
  }
}
