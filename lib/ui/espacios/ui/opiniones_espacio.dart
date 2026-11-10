import 'package:flutter/material.dart';

import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/services/datos_demo.dart';
import '../../../domain/models/comentario.dart';
import '../../../domain/models/espacio.dart';
import '../../core/formatters/formatos.dart';
import '../../core/theme/app_colores.dart';
import '../../core/theme/app_espaciado.dart';

class OpinionesEspacio extends StatefulWidget {
  const OpinionesEspacio({super.key, required this.espacio});

  final Espacio espacio;

  @override
  State<OpinionesEspacio> createState() => _OpinionesEspacioState();
}

class _OpinionesEspacioState extends State<OpinionesEspacio> {
  late List<Comentario> _opiniones;
  final TextEditingController _controladorOpinion = TextEditingController();
  int _puntuacionSeleccionada = 5;

  @override
  void initState() {
    super.initState();
    _opiniones = ComentariosRepository.obtener(widget.espacio);
  }

  @override
  void didUpdateWidget(covariant OpinionesEspacio oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.espacio.id != widget.espacio.id) {
      _opiniones = ComentariosRepository.obtener(widget.espacio);
      _puntuacionSeleccionada = 5;
      _controladorOpinion.clear();
    }
  }

  @override
  void dispose() {
    _controladorOpinion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colorEstrellas = tema.brightness == Brightness.dark
        ? AppColores.avisoOscuro
        : AppColores.aviso;
    final media = _opiniones.isEmpty
        ? 0.0
        : _opiniones.fold<int>(
                0,
                (suma, opinion) => suma + opinion.puntuacion,
              ) /
              _opiniones.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_opiniones.isEmpty)
          Text('Sin valoraciones', style: tema.textTheme.bodyLarge)
        else ...[
          Row(
            children: [
              Icon(Icons.star, color: colorEstrellas),
              const SizedBox(width: AppEspaciado.xs),
              Text(media.toStringAsFixed(1), style: tema.textTheme.titleLarge),
              const SizedBox(width: AppEspaciado.xs),
              Expanded(
                child: Text(
                  '· ${_opiniones.length} ${_opiniones.length == 1 ? 'valoración' : 'valoraciones'}',
                  style: tema.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.md),
          for (var indice = 0; indice < _opiniones.length; indice++) ...[
            if (indice > 0) const Divider(),
            _opinionItem(context, _opiniones[indice]),
          ],
        ],
        const SizedBox(height: AppEspaciado.md),
        const Divider(),
        const SizedBox(height: AppEspaciado.sm),
        Text('Añadir una opinión', style: tema.textTheme.titleMedium),
        const SizedBox(height: AppEspaciado.xs),
        TextField(
          controller: _controladorOpinion,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Tu comentario',
            hintText: 'Cuéntanos cómo fue tu partida',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: AppEspaciado.sm),
        Text(
          'Puntuación: $_puntuacionSeleccionada de 5',
          style: tema.textTheme.bodyMedium,
        ),
        Row(
          children: [
            for (var puntuacion = 1; puntuacion <= 5; puntuacion++)
              IconButton(
                tooltip: '$puntuacion estrellas',
                onPressed: () => setState(() {
                  _puntuacionSeleccionada = puntuacion;
                }),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                icon: Icon(
                  puntuacion <= _puntuacionSeleccionada
                      ? Icons.star
                      : Icons.star_border,
                  color: puntuacion <= _puntuacionSeleccionada
                      ? colorEstrellas
                      : tema.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppEspaciado.sm),
        FilledButton.icon(
          onPressed: () => _agregarOpinion(context),
          icon: const Icon(Icons.rate_review_outlined),
          label: const Text('Publicar opinión'),
        ),
      ],
    );
  }

  Widget _opinionItem(BuildContext context, Comentario opinion) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppEspaciado.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppEspaciado.sm,
            runSpacing: AppEspaciado.xxs,
            children: [
              Text(opinion.autor, style: tema.textTheme.titleMedium),
              Text(opinion.fecha, style: tema.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: AppEspaciado.xxs),
          Row(
            children: [
              _estrellas(context, opinion.puntuacion),
              const SizedBox(width: AppEspaciado.xs),
              Text('${opinion.puntuacion}/5', style: tema.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: AppEspaciado.xs),
          Text(opinion.texto, style: tema.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _estrellas(BuildContext context, int puntuacion) {
    final tema = Theme.of(context);
    final colorEstrellas = tema.brightness == Brightness.dark
        ? AppColores.avisoOscuro
        : AppColores.aviso;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var indice = 1; indice <= 5; indice++)
          Icon(
            indice <= puntuacion ? Icons.star : Icons.star_border,
            size: 18,
            color: indice <= puntuacion
                ? colorEstrellas
                : tema.colorScheme.onSurfaceVariant,
          ),
      ],
    );
  }

  void _agregarOpinion(BuildContext context) {
    final texto = _controladorOpinion.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe un comentario antes de publicarlo.'),
        ),
      );
      return;
    }

    setState(() {
      ComentariosRepository.agregar(
        widget.espacio,
        Comentario(
          autor: DatosDemo.usuario.nombre,
          fecha: formatearFechaCorta(DateTime.now()),
          texto: texto,
          puntuacion: _puntuacionSeleccionada,
        ),
      );
      _opiniones = ComentariosRepository.obtener(widget.espacio);
      _controladorOpinion.clear();
      _puntuacionSeleccionada = 5;
    });
  }
}
