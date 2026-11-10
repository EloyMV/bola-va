import 'package:flutter/material.dart';

import '../../../data/repositories/disponibilidad_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../domain/models/disponibilidad_dia.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/franja_disponibilidad.dart';
import '../../../domain/models/reserva.dart';
import '../../../domain/models/servicio_extra.dart';
import '../../core/formatters/formatos.dart';
import '../../core/theme/app_bordes.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/theme/colores_estado.dart';
import '../../core/ui/dato_etiqueta.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/pagina_base.dart';
import '../../core/ui/seccion_contenido.dart';
import '../../reservas/ui/nueva_reserva_screen.dart';
import 'galeria_espacio.dart';
import 'opiniones_espacio.dart';

class EspacioDetalleScreen extends StatelessWidget {
  const EspacioDetalleScreen({super.key, this.espacio, this.contenido});

  final Espacio? espacio;
  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    final espacio = this.espacio;
    return PaginaBase(
      titulo: espacio?.nombre ?? 'Detalle del espacio',
      subtitulo: espacio == null
          ? 'Conoce el lugar de tu próxima partida.'
          : 'Información, servicios y disponibilidad del espacio.',
      child:
          contenido ??
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
        GaleriaEspacio(espacio: espacio),
        const SizedBox(height: AppEspaciado.lg),
        SeccionContenido(
          titulo: 'Descripción',
          icono: Icons.sports_tennis_outlined,
          child: Column(
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
        SeccionContenido(
          titulo: 'Equipamiento y servicios',
          icono: Icons.sports_outlined,
          child: Column(
            children: [
              for (
                var indice = 0;
                indice < espacio.servicios.length;
                indice++
              ) ...[
                if (indice > 0) const SizedBox(height: AppEspaciado.sm),
                _filaServicio(context, espacio.servicios[indice]),
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
        SeccionContenido(
          titulo: 'Tarifa y contacto',
          icono: Icons.payments_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dato(
                context,
                icono: Icons.euro_symbol,
                etiqueta: 'Tarifa por hora',
                valor: '${formatearPrecio(espacio.tarifaHora)} €/hora',
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
        SeccionContenido(
          titulo: 'Condiciones y horario',
          icono: Icons.schedule_outlined,
          child: Column(
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
        SeccionContenido(
          titulo: 'Disponibilidad',
          icono: Icons.calendar_month_outlined,
          child: ValueListenableBuilder<List<Reserva>>(
            valueListenable: ReservasRepository.reservas,
            builder: (context, reservas, child) =>
                _contenidoDisponibilidad(context, espacio),
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        SeccionContenido(
          titulo: 'Opiniones',
          icono: Icons.star_outline,
          child: OpinionesEspacio(espacio: espacio),
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
          child: DatoEtiqueta(etiqueta: etiqueta, valor: valor),
        ),
      ],
    );
  }

  Widget _filaServicio(BuildContext context, ServicioExtra servicio) {
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
            _iconoServicio(servicio.icono),
            color: tema.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppEspaciado.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(servicio.nombre, style: tema.textTheme.bodyLarge),
              Text(
                servicio.precio == null
                    ? 'Incluido'
                    : '${formatearPrecio(servicio.precio!)} € por reserva',
                style: tema.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _iconoServicio(String clave) {
    if (clave == 'luz') return Icons.lightbulb_outline;
    if (clave == 'ducha') return Icons.shower;
    if (clave == 'parking') return Icons.local_parking;
    if (clave == 'descanso') return Icons.weekend_outlined;
    if (clave == 'raqueta') return Icons.sports_tennis;
    if (clave == 'pelotas') return Icons.sports_baseball_outlined;
    if (clave == 'vestuario') return Icons.meeting_room_outlined;
    if (clave == 'cubierta') return Icons.home_work_outlined;
    if (clave == 'monitor') return Icons.school_outlined;
    if (clave == 'taquilla') return Icons.lock_outline;
    if (clave == 'marcador') return Icons.edit_note_outlined;
    return Icons.check_circle_outline;
  }

  Widget _contenidoDisponibilidad(BuildContext context, Espacio espacio) {
    final tema = Theme.of(context);
    final colorAviso = ColoresEstado.pendiente(context);
    final dias = DisponibilidadRepository.disponibilidadSemana(espacio.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: colorAviso, size: 20),
            const SizedBox(width: AppEspaciado.xs),
            Expanded(
              child: Text(
                'Horarios de esta semana',
                style: tema.textTheme.labelLarge?.copyWith(color: colorAviso),
              ),
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
            '${esHoy ? 'Hoy · ' : ''}${formatearFecha(dia.fecha)}',
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
    final tema = Theme.of(context);
    final color = franja.libre
        ? ColoresEstado.disponible(context)
        : ColoresEstado.ocupado(context);
    return Chip(
      avatar: Icon(
        franja.libre ? Icons.check_circle_outline : Icons.block_outlined,
        size: 18,
        color: color,
      ),
      label: Text(
        '${franja.horaInicio}–${franja.horaFin} · ${franja.libre ? 'Libre' : 'Ocupada'}',
      ),
      labelStyle: tema.textTheme.labelMedium?.copyWith(color: color),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color),
    );
  }
}
