import 'package:flutter/material.dart';

import '../../../domain/models/reserva.dart';
import '../../core/formatters/formatos.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/dato_etiqueta.dart';
import '../../core/ui/linea_precio.dart';
import '../../core/ui/pagina_base.dart';
import '../../core/ui/seccion_contenido.dart';
import 'mis_reservas_screen.dart';

class ConfirmacionReservaScreen extends StatelessWidget {
  const ConfirmacionReservaScreen({
    super.key,
    required this.reserva,
    this.fechaActual,
  });

  final Reserva reserva;
  final DateTime? fechaActual;

  @override
  Widget build(BuildContext context) => PaginaBase(
    titulo: 'Reserva confirmada',
    subtitulo: 'Todo listo para tu próxima partida.',
    anchoMaximo: AppEspaciado.anchoFormulario,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SeccionContenido(
          titulo: reserva.espacio.nombre,
          icono: Icons.check_circle_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DatoEtiqueta(etiqueta: 'Actividad', valor: 'Pádel'),
              DatoEtiqueta(
                etiqueta: 'Fecha',
                valor: formatearFecha(reserva.inicio),
              ),
              DatoEtiqueta(
                etiqueta: 'Hora de inicio',
                valor: formatearHora(reserva.inicio),
              ),
              DatoEtiqueta(
                etiqueta: 'Hora de fin',
                valor: formatearHora(reserva.fin),
              ),
              DatoEtiqueta(
                etiqueta:
                    'Asistentes (${reserva.asistentes.length}/${reserva.espacio.capacidad})',
                valor: reserva.asistentes.join(', '),
              ),
              DatoEtiqueta(
                etiqueta: 'Extras',
                valor: reserva.extras.isEmpty
                    ? 'Ninguno'
                    : reserva.extras.map((extra) => extra.nombre).join(', '),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        SeccionContenido(
          titulo: 'Desglose del precio',
          icono: Icons.receipt_long_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DatoEtiqueta(
                etiqueta: 'Duración',
                valor: '${formatearPrecio(reserva.duracionHoras)} horas',
              ),
              DatoEtiqueta(
                etiqueta: 'Tarifa por hora',
                valor: '${formatearPrecio(reserva.espacio.tarifaHora)} €/hora',
              ),
              LineaPrecio(
                etiqueta: 'Subtotal alquiler',
                importe: reserva.subtotalAlquiler,
              ),
              LineaPrecio(
                etiqueta: 'Subtotal extras',
                importe: reserva.subtotalExtras,
              ),
              const Divider(height: AppEspaciado.lg),
              LineaPrecio(
                etiqueta: 'Total por reserva',
                importe: reserva.total,
                total: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.md),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil<void>(
            MaterialPageRoute<void>(
              builder: (_) => MisReservasScreen(fechaActual: fechaActual),
            ),
            (_) => false,
          ),
          icon: const Icon(Icons.event_note_outlined),
          label: const Text('Mis reservas'),
        ),
      ],
    ),
  );
}
