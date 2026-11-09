import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import '../../core/ui/pagina_base.dart';
import '../../core/ui/reserva_tarjeta.dart';

/// Añade las reservas en [contenido] y usa Theme.of(context).textTheme.
class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key, this.contenido});

  final Widget? contenido;

  @override
  Widget build(BuildContext context) {
    return PaginaBase(
      titulo: 'Mis reservas',
      subtitulo: 'Ejemplos precargados para esta demostración.',
      child:
          contenido ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'La reserva de prueba no se ha guardado. Esta lista no cambia '
                'y solo contiene reservas de ejemplo.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppEspaciado.md),
              const ReservaTarjeta(
                nombreEspacio: 'Pista Panorámica',
                fecha: 'Sábado, 14 de noviembre de 2026',
                hora: 'De 10:00 a 11:30',
              ),
              const SizedBox(height: AppEspaciado.sm),
              const ReservaTarjeta(
                nombreEspacio: 'Pista Indoor',
                fecha: 'Domingo, 15 de noviembre de 2026',
                hora: 'De 16:00 a 17:00',
                estado: EstadoReserva.pendiente,
              ),
            ],
          ),
    );
  }
}
