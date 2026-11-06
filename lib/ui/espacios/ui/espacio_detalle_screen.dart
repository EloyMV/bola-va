import 'package:flutter/material.dart';

import '../../../data/services/datos_demo.dart';
import '../../../domain/models/comentario.dart';
import '../../../domain/models/disponibilidad_dia.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/franja_disponibilidad.dart';
import '../../core/theme/app_bordes.dart';
import '../../core/theme/app_colores.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/espacio_tarjeta.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';
import '../../reservas/ui/nueva_reserva_screen.dart';

class EspacioDetalleScreen extends StatefulWidget {
  const EspacioDetalleScreen({super.key, this.espacio, this.contenido});

  final Espacio? espacio;
  final Widget? contenido;

  @override
  State<EspacioDetalleScreen> createState() => _EspacioDetalleScreenState();
}

class _EspacioDetalleScreenState extends State<EspacioDetalleScreen> {
  late List<Comentario> _opiniones;
  final TextEditingController _controladorOpinion = TextEditingController();
  int _indiceImagenActual = 0;
  int _puntuacionSeleccionada = 5;

  @override
  void initState() {
    super.initState();
    _opiniones = List<Comentario>.of(widget.espacio?.opiniones ?? const []);
  }

  @override
  void didUpdateWidget(covariant EspacioDetalleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.espacio?.id != widget.espacio?.id) {
      _opiniones = List<Comentario>.of(widget.espacio?.opiniones ?? const []);
      _indiceImagenActual = 0;
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
    final espacio = widget.espacio;
    return PaginaBase(
      titulo: espacio?.nombre ?? 'Detalle del espacio',
      subtitulo: espacio == null
          ? 'Conoce el lugar de tu próxima partida.'
          : 'Información, servicios y disponibilidad del espacio.',
      child:
          widget.contenido ??
          (espacio == null
              ? const EstadoVacio(
                  icono: Icons.info_outline,
                  titulo: 'Información del espacio',
                  mensaje: 'Aquí encontrarás sus características y servicios.',
                )
              : _contenidoEspacio(context, espacio)),
    );
  }

  Widget _contenidoEspacio(BuildContext context, Espacio espacio) {
    final contacto = espacio.contacto;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _carrusel(context, espacio),
        const SizedBox(height: AppEspaciado.lg),
        _seccion(
          context,
          titulo: 'Descripción',
          icono: Icons.sports_tennis_outlined,
          contenido: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                espacio.descripcion,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppEspaciado.md),
              _dato(
                context,
                icono: Icons.location_on_outlined,
                etiqueta: 'Ubicación',
                valor: espacio.ubicacion,
              ),
              const SizedBox(height: AppEspaciado.sm),
              _dato(
                context,
                icono: Icons.groups_outlined,
                etiqueta: 'Aforo',
                valor: '${espacio.capacidad} jugadores',
              ),
              const SizedBox(height: AppEspaciado.sm),
              Text(
                'Actividades admitidas',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppEspaciado.xs),
              Wrap(
                spacing: AppEspaciado.xs,
                runSpacing: AppEspaciado.xs,
                children: [
                  for (final actividad in espacio.actividades)
                    Chip(label: Text(actividad)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        _seccion(
          context,
          titulo: 'Equipamiento y servicios',
          icono: Icons.sports_outlined,
          contenido: Column(
            children: [
              for (
                var indice = 0;
                indice < espacio.servicios.length;
                indice++
              ) ...[
                if (indice > 0) const SizedBox(height: AppEspaciado.sm),
                _filaServicio(
                  context,
                  espacio.servicios[indice].nombre,
                  espacio.servicios[indice].icono,
                ),
              ],
              if (espacio.servicios.isEmpty)
                Text(
                  'Sin servicios adicionales indicados.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        _seccion(
          context,
          titulo: 'Tarifa y contacto',
          icono: Icons.payments_outlined,
          contenido: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dato(
                context,
                icono: Icons.euro_symbol,
                etiqueta: 'Tarifa por hora',
                valor: '${_formatearPrecio(espacio.tarifaHora)} €/hora',
              ),
              const SizedBox(height: AppEspaciado.md),
              if (contacto != null) ...[
                Text(
                  contacto.nombre,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppEspaciado.xs),
                _dato(
                  context,
                  icono: Icons.phone_outlined,
                  etiqueta: 'Teléfono',
                  valor: contacto.telefono,
                ),
                const SizedBox(height: AppEspaciado.xs),
                _dato(
                  context,
                  icono: Icons.email_outlined,
                  etiqueta: 'Correo',
                  valor: contacto.correo,
                ),
              ] else
                Text(
                  'Sin información de contacto.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const SizedBox(height: AppEspaciado.md),
              _dato(
                context,
                icono: Icons.language_outlined,
                etiqueta: 'Sitio web',
                valor: espacio.sitioWeb ?? 'Sin sitio web',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        _seccion(
          context,
          titulo: 'Condiciones y horario',
          icono: Icons.schedule_outlined,
          contenido: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dato(
                context,
                icono: Icons.rule_outlined,
                etiqueta: 'Condiciones de uso',
                valor: espacio.condicionesUso.isEmpty
                    ? 'Consulta las condiciones en recepción.'
                    : espacio.condicionesUso,
              ),
              const SizedBox(height: AppEspaciado.md),
              _dato(
                context,
                icono: Icons.access_time,
                etiqueta: 'Horario',
                valor: espacio.horarioUso.isEmpty
                    ? 'Horario no indicado.'
                    : espacio.horarioUso,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        _seccion(
          context,
          titulo: 'Disponibilidad',
          icono: Icons.calendar_month_outlined,
          contenido: _contenidoDisponibilidad(context, espacio),
        ),
        const SizedBox(height: AppEspaciado.md),
        _seccion(
          context,
          titulo: 'Opiniones',
          icono: Icons.star_outline,
          contenido: _contenidoOpiniones(context),
        ),
        const SizedBox(height: AppEspaciado.lg),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => NuevaReservaScreen(espacio: espacio),
            ),
          ),
          icon: const Icon(Icons.event_available_outlined),
          label: const Text('Reservar'),
        ),
      ],
    );
  }

  Widget _carrusel(BuildContext context, Espacio espacio) {
    final imagenes = espacio.galeriaImagenes;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppBordes.grande),
          child: SizedBox(
            height: 240,
            child: PageView.builder(
              key: ValueKey<String>('galeria-${espacio.id}'),
              itemCount: imagenes.length,
              onPageChanged: (indice) => setState(() {
                _indiceImagenActual = indice;
              }),
              itemBuilder: (context, indice) => EspacioImagen(
                imagenUrl: imagenes[indice],
                etiqueta: '${espacio.nombre}, imagen ${indice + 1}',
                altura: 240,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppEspaciado.sm),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppEspaciado.xs,
          children: [
            for (var indice = 0; indice < imagenes.length; indice++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: indice == _indiceImagenActual ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indice == _indiceImagenActual
                      ? AppColores.primario
                      : AppColores.borde,
                  borderRadius: BorderRadius.circular(AppBordes.redondo),
                ),
              ),
            Text(
              'Foto ${_indiceImagenActual + 1} de ${imagenes.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _seccion(
    BuildContext context, {
    required String titulo,
    required IconData icono,
    required Widget contenido,
  }) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: tema.colorScheme.primary),
                const SizedBox(width: AppEspaciado.xs),
                Expanded(child: Text(titulo, style: tema.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: AppEspaciado.md),
            contenido,
          ],
        ),
      ),
    );
  }

  Widget _dato(
    BuildContext context, {
    required IconData icono,
    required String etiqueta,
    required String valor,
  }) {
    final tema = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 20, color: tema.colorScheme.primary),
        const SizedBox(width: AppEspaciado.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(etiqueta, style: tema.textTheme.labelLarge),
              Text(valor, style: tema.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filaServicio(BuildContext context, String nombre, String claveIcono) {
    final tema = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: tema.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppBordes.medio),
          ),
          child: Icon(
            _iconoServicio(claveIcono),
            color: tema.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppEspaciado.md),
        Expanded(child: Text(nombre, style: tema.textTheme.bodyLarge)),
      ],
    );
  }

  IconData _iconoServicio(String clave) {
    if (clave == 'luz') return Icons.lightbulb_outline;
    if (clave == 'ducha') return Icons.shower;
    if (clave == 'parking') return Icons.local_parking;
    if (clave == 'descanso') return Icons.weekend_outlined;
    if (clave == 'raqueta') return Icons.sports_tennis;
    if (clave == 'vestuario') return Icons.meeting_room_outlined;
    if (clave == 'cubierta') return Icons.home_work_outlined;
    if (clave == 'monitor') return Icons.school_outlined;
    if (clave == 'taquilla') return Icons.lock_outline;
    if (clave == 'marcador') return Icons.edit_note_outlined;
    return Icons.check_circle_outline;
  }

  Widget _contenidoDisponibilidad(BuildContext context, Espacio espacio) {
    final dias = DatosDemo.disponibilidadSemana(espacio.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.info_outline, color: AppColores.aviso, size: 20),
            const SizedBox(width: AppEspaciado.xs),
            Text(
              'Disponibilidad simulada',
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: AppColores.aviso),
            ),
          ],
        ),
        const SizedBox(height: AppEspaciado.md),
        for (var indice = 0; indice < dias.length; indice++) ...[
          if (indice > 0) const Divider(),
          _filaDisponibilidad(context, dias[indice], esHoy: indice == 0),
        ],
      ],
    );
  }

  Widget _filaDisponibilidad(
    BuildContext context,
    DisponibilidadDia dia, {
    required bool esHoy,
  }) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppEspaciado.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatearDia(dia.fecha, esHoy: esHoy),
            style: tema.textTheme.titleMedium,
          ),
          const SizedBox(height: AppEspaciado.xs),
          Wrap(
            spacing: AppEspaciado.xs,
            runSpacing: AppEspaciado.xs,
            children: [
              for (final franja in dia.franjas) _chipFranja(context, franja),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipFranja(BuildContext context, FranjaDisponibilidad franja) {
    final color = franja.libre ? AppColores.exito : AppColores.ocupado;
    return Chip(
      avatar: Icon(
        franja.libre ? Icons.check_circle_outline : Icons.block_outlined,
        size: 18,
        color: color,
      ),
      label: Text(
        '${franja.horaInicio}–${franja.horaFin} · ${franja.libre ? 'Libre' : 'Ocupada'}',
      ),
      labelStyle: Theme.of(context).textTheme.labelMedium
          ?.copyWith(color: color),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color),
    );
  }

  Widget _contenidoOpiniones(BuildContext context) {
    final tema = Theme.of(context);
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
              const Icon(Icons.star, color: AppColores.aviso),
              const SizedBox(width: AppEspaciado.xs),
              Text(media.toStringAsFixed(1), style: tema.textTheme.titleLarge),
              const SizedBox(width: AppEspaciado.xs),
              Text(
                '· ${_opiniones.length} ${_opiniones.length == 1 ? 'valoración' : 'valoraciones'}',
                style: tema.textTheme.bodyMedium,
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
        Text('Añadir una opinión de prueba', style: tema.textTheme.titleMedium),
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
                      ? AppColores.aviso
                      : AppColores.textoSecundario,
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
          Row(
            children: [
              Expanded(
                child: Text(opinion.autor, style: tema.textTheme.titleMedium),
              ),
              Text(opinion.fecha, style: tema.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: AppEspaciado.xxs),
          Row(
            children: [
              _estrellas(opinion.puntuacion),
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

  Widget _estrellas(int puntuacion) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var indice = 1; indice <= 5; indice++)
          Icon(
            indice <= puntuacion ? Icons.star : Icons.star_border,
            size: 18,
            color: indice <= puntuacion
                ? AppColores.aviso
                : AppColores.textoSecundario,
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
      _opiniones.insert(
        0,
        Comentario(
          autor: 'Alex García',
          fecha: _fechaActual(),
          texto: texto,
          puntuacion: _puntuacionSeleccionada,
        ),
      );
      _controladorOpinion.clear();
      _puntuacionSeleccionada = 5;
    });
  }

  String _formatearDia(DateTime fecha, {required bool esHoy}) {
    const dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final fechaTexto =
        '${dias[fecha.weekday - 1]} ${fecha.day} de ${meses[fecha.month - 1]}';
    return esHoy ? 'Hoy · $fechaTexto' : fechaTexto;
  }

  String _fechaActual() {
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    final fecha = DateTime.now();
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }

  String _formatearPrecio(double precio) => precio == precio.roundToDouble()
      ? precio.toStringAsFixed(0)
      : precio.toStringAsFixed(2);
}
