import 'package:flutter/material.dart';

import '../theme/app_colores.dart';
import '../theme/app_espaciado.dart';
import 'espacio_tarjeta.dart';

/// Estados visuales; los datos y las reglas de las reservas se añaden aparte.
enum EstadoReserva { confirmada, pendiente, cancelada }

class ReservaTarjeta extends StatelessWidget {
  const ReservaTarjeta({
    super.key,
    required this.nombreEspacio,
    required this.fecha,
    required this.hora,
    this.estado = EstadoReserva.confirmada,
    this.imagenUrl,
    this.actividad,
    this.asistentes,
    this.servicios,
    this.precioTotal,
    this.responsable,
    this.telefono,
    this.correo,
    this.onDetails,
    this.onCancel,
  });

  final String nombreEspacio;
  final String fecha;
  final String hora;
  final EstadoReserva estado;
  final String? imagenUrl;
  final String? actividad;
  final int? asistentes;
  final List<String>? servicios;
  final String? precioTotal;
  final String? responsable;
  final String? telefono;
  final String? correo;
  final VoidCallback? onDetails;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final (etiqueta, colorEstado, iconoEstado) = switch (estado) {
      EstadoReserva.confirmada => (
        'Confirmada',
        AppColores.exito,
        Icons.check_circle_outline,
      ),
      EstadoReserva.pendiente => (
        'Pendiente',
        AppColores.aviso,
        Icons.schedule,
      ),
      EstadoReserva.cancelada => (
        'Cancelada',
        AppColores.error,
        Icons.cancel_outlined,
      ),
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagenUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 92,
                      child: EspacioImagen(
                        imagenUrl: imagenUrl!,
                        etiqueta: nombreEspacio,
                        altura: 104,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppEspaciado.sm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreEspacio,
                        style: tema.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppEspaciado.xs),
                      _DatoReserva(
                        icono: Icons.calendar_today_outlined,
                        texto: fecha,
                      ),
                      const SizedBox(height: AppEspaciado.xxs),
                      _DatoReserva(icono: Icons.access_time, texto: hora),
                      if (precioTotal != null) ...[
                        const SizedBox(height: AppEspaciado.xxs),
                        _DatoReserva(
                          icono: Icons.euro_outlined,
                          texto: 'Precio total: $precioTotal',
                        ),
                      ],
                      const SizedBox(height: AppEspaciado.xs),
                      Chip(
                        avatar: Icon(iconoEstado, size: 18, color: colorEstado),
                        label: Text(etiqueta),
                        labelStyle: tema.textTheme.labelMedium?.copyWith(
                          color: colorEstado,
                        ),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: tema.colorScheme.surface,
                        side: BorderSide(color: colorEstado),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppEspaciado.xs),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: AppEspaciado.xs,
              runSpacing: AppEspaciado.xs,
              children: [
                OutlinedButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Ver detalles'),
                ),
                if (estado != EstadoReserva.cancelada && onCancel != null)
                  TextButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.event_busy_outlined),
                    label: const Text('Cancelar'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DatoReserva extends StatelessWidget {
  const _DatoReserva({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icono,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppEspaciado.xs),
        Expanded(child: Text(texto)),
      ],
    );
  }
}
