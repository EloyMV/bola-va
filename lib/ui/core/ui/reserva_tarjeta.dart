import 'package:flutter/material.dart';

import '../theme/app_colores.dart';
import '../theme/app_espaciado.dart';

/// Estados visuales; los datos y las reglas de las reservas se añaden aparte.
enum EstadoReserva { confirmada, pendiente, cancelada }

class ReservaTarjeta extends StatelessWidget {
  const ReservaTarjeta({
    super.key,
    required this.nombreEspacio,
    required this.fecha,
    required this.hora,
    this.estado = EstadoReserva.confirmada,
    this.onTap,
  });

  final String nombreEspacio;
  final String fecha;
  final String hora;
  final EstadoReserva estado;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esOscuro = tema.brightness == Brightness.dark;
    final (etiqueta, colorEstado, iconoEstado) = switch (estado) {
      EstadoReserva.confirmada => (
        'Confirmada',
        esOscuro ? AppColores.exitoOscuro : AppColores.exito,
        Icons.check_circle_outline,
      ),
      EstadoReserva.pendiente => (
        'Pendiente',
        esOscuro ? AppColores.avisoOscuro : AppColores.aviso,
        Icons.schedule,
      ),
      EstadoReserva.cancelada => (
        'Cancelada',
        tema.colorScheme.error,
        Icons.cancel_outlined,
      ),
    };

    return Semantics(
      container: true,
      button: onTap != null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppEspaciado.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event_available_outlined,
                      color: tema.colorScheme.primary,
                    ),
                    const SizedBox(width: AppEspaciado.sm),
                    Expanded(
                      child: Text(
                        nombreEspacio,
                        style: tema.textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppEspaciado.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppEspaciado.xs),
                    Expanded(
                      child: Text(fecha, style: tema.textTheme.bodyMedium),
                    ),
                  ],
                ),
                const SizedBox(height: AppEspaciado.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppEspaciado.xs),
                    Expanded(
                      child: Text(hora, style: tema.textTheme.bodyMedium),
                    ),
                  ],
                ),
                const SizedBox(height: AppEspaciado.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: Icon(iconoEstado, size: 18, color: colorEstado),
                    label: Text(etiqueta),
                    labelStyle: tema.textTheme.labelMedium?.copyWith(
                      color: colorEstado,
                    ),
                    backgroundColor: tema.colorScheme.surface,
                    side: BorderSide(color: colorEstado),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
