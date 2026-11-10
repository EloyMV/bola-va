import 'package:flutter/material.dart';

import '../../../data/repositories/reservas_repository.dart';
import '../../../domain/models/reserva.dart';
import '../../core/formatters/formatos.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/ui/dato_etiqueta.dart';
import '../../core/ui/estado_vacio.dart';
import '../../core/ui/navegacion_principal.dart';
import '../../core/ui/pagina_base.dart';
import '../../core/ui/reserva_tarjeta.dart';

class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key, this.contenido, this.fechaActual});

  final Widget? contenido;
  final DateTime? fechaActual;

  @override
  Widget build(BuildContext context) => PaginaBase(
    titulo: 'Mis reservas',
    subtitulo: 'Tu próxima partida, con todos los detalles a mano.',
    child:
        contenido ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NavegacionPrincipal(seccionActual: SeccionPrincipal.reservas),
            const SizedBox(height: AppEspaciado.md),
            ValueListenableBuilder<List<Reserva>>(
              valueListenable: ReservasRepository.reservas,
              builder: (context, reservas, child) {
                final proximas = ReservasRepository.proximas(
                  fechaActual: fechaActual,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (proximas.isEmpty)
                      const EstadoVacio(
                        icono: Icons.event_note_outlined,
                        titulo: 'No tienes reservas próximas.',
                        mensaje: 'Explora las pistas y prepara tu siguiente partida.',
                      ),
                    for (
                      var indice = 0;
                      indice < proximas.length;
                      indice++
                    ) ...[
                      if (indice > 0) const SizedBox(height: AppEspaciado.sm),
                      _tarjeta(context, proximas[indice]),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
  );

  Widget _tarjeta(BuildContext context, Reserva reserva) => ReservaTarjeta(
    key: ValueKey('reserva-${reserva.id}'),
    nombreEspacio: reserva.espacio.nombre,
    imagenUrl: reserva.espacio.imagenUrl,
    fecha: formatearFecha(reserva.inicio),
    hora: 'De ${formatearHora(reserva.inicio)} a ${formatearHora(reserva.fin)}',
    estado: reserva.estado,
    precioTotal: '${formatearPrecio(reserva.total)} €',
    onDetails: () => _mostrarDetalles(context, reserva),
    onCancel: () => _confirmarCancelacion(context, reserva),
  );

  Future<void> _confirmarCancelacion(
    BuildContext context,
    Reserva reserva,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: Text(
          '¿Quieres cancelar tu reserva en ${reserva.espacio.nombre}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
    if (confirmar == true) ReservasRepository.cancelar(reserva.id);
  }

  void _mostrarDetalles(BuildContext context, Reserva reserva) {
    final contacto = reserva.espacio.contacto;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles · ${reserva.espacio.nombre}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Actividad: ${reserva.espacio.actividades.first}'),
              const SizedBox(height: AppEspaciado.xs),
              Text('Asistentes: ${reserva.asistentes.length}'),
              Text(reserva.asistentes.join(', ')),
              const SizedBox(height: AppEspaciado.xs),
              const Text('Servicios contratados:'),
              if (reserva.extras.isEmpty) const Text('Sin extras'),
              for (final extra in reserva.extras)
                Text(
                  '${extra.nombre} · ${formatearPrecio(extra.precio ?? 0)} €',
                ),
              const SizedBox(height: AppEspaciado.xs),
              Text('Precio total: ${formatearPrecio(reserva.total)} €'),
              if (contacto != null) ...[
                const SizedBox(height: AppEspaciado.sm),
                const Text('Contacto del espacio'),
                DatoEtiqueta(etiqueta: 'Responsable', valor: contacto.nombre),
                DatoEtiqueta(etiqueta: 'Teléfono', valor: contacto.telefono),
                DatoEtiqueta(etiqueta: 'Correo', valor: contacto.correo),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
