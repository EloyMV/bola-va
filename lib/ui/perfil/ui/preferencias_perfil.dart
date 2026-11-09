import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import '../../core/theme/app_preferencias.dart';
import 'seccion_perfil.dart';

class PreferenciasPerfil extends StatelessWidget {
  const PreferenciasPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return SeccionPerfil(
      titulo: 'Preferencias',
      icono: Icons.tune_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: AppPreferencias.tema,
            builder: (context, tema, child) =>
                DropdownButtonFormField<ThemeMode>(
                  key: ValueKey(tema),
                  initialValue: tema,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Apariencia',
                    prefixIcon: Icon(Icons.palette_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Claro'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Oscuro'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('Sistema'),
                    ),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      AppPreferencias.tema.value = valor;
                    }
                  },
                ),
          ),
          const SizedBox(height: AppEspaciado.md),
          ValueListenableBuilder<bool>(
            valueListenable: AppPreferencias.avisosReservas,
            builder: (context, avisos, child) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Avisos de reservas'),
              subtitle: const Text(
                'Mostrar recomendaciones al preparar una reserva.',
              ),
              controlAffinity: ListTileControlAffinity.leading,
              value: avisos,
              onChanged: (valor) {
                AppPreferencias.avisosReservas.value = valor ?? false;
              },
            ),
          ),
          const SizedBox(height: AppEspaciado.md),
          ValueListenableBuilder<String>(
            valueListenable: AppPreferencias.horarioFavorito,
            builder: (context, horario, child) =>
                DropdownButtonFormField<String>(
                  key: ValueKey(horario),
                  initialValue: horario,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Horario favorito',
                    prefixIcon: Icon(Icons.schedule_outlined),
                  ),
                  items: [
                    for (final opcion in AppPreferencias.horariosFavoritos)
                      DropdownMenuItem(value: opcion, child: Text(opcion)),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      AppPreferencias.horarioFavorito.value = valor;
                    }
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class AccesibilidadPerfil extends StatelessWidget {
  const AccesibilidadPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return SeccionPerfil(
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
                Text(
                  'Tamaño del texto: ${(escala * 100).round()} %',
                  style: Theme.of(context).textTheme.titleMedium,
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
                const Text('Ajusta el tamaño del texto en toda la aplicación.'),
              ],
            ),
          ),
          const SizedBox(height: AppEspaciado.md),
          ValueListenableBuilder<bool>(
            valueListenable: AppPreferencias.apoyoDaltonismo,
            builder: (context, apoyoActivo, child) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Apoyo para daltonismo rojo-verde'),
              subtitle: const Text(
                'Usa azul, naranja y morado para distinguir los estados, '
                'además de sus iconos y etiquetas.',
              ),
              value: apoyoActivo,
              onChanged: (valor) {
                AppPreferencias.apoyoDaltonismo.value = valor;
              },
            ),
          ),
        ],
      ),
    );
  }
}
