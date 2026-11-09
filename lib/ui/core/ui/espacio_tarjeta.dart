import 'package:flutter/material.dart';

import '../../../domain/models/espacio.dart';
import '../theme/app_bordes.dart';
import '../theme/app_colores.dart';
import '../theme/app_espaciado.dart';

/// Tarjeta visual de una pista. Recibe textos y una acción desde la pantalla.
class EspacioTarjeta extends StatelessWidget {
  const EspacioTarjeta({
    super.key,
    this.espacio,
    this.nombre,
    this.ubicacion,
    this.precio,
    this.capacidad,
    this.actividades = const [],
    this.imagenUrl,
    this.detalle,
    this.disponible = true,
    this.onTap,
  }) : assert(espacio != null || nombre != null),
       assert(espacio != null || ubicacion != null);

  final Espacio? espacio;
  final String? nombre;
  final String? ubicacion;
  final String? precio;
  final String? capacidad;
  final List<String> actividades;
  final String? imagenUrl;
  final String? detalle;
  final bool disponible;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esOscuro = tema.brightness == Brightness.dark;
    final nombreVisible = espacio?.nombre ?? nombre!;
    final ubicacionVisible = espacio?.ubicacion ?? ubicacion!;
    final capacidadVisible =
        capacidad ?? espacio?.capacidad.toString() ?? precio;
    final actividadesVisibles = espacio?.actividades ?? actividades;
    final imagenVisible = espacio?.imagenUrl ?? imagenUrl;
    final detalleVisible = detalle ?? espacio?.descripcion;
    final disponibleVisible = espacio?.disponible ?? disponible;
    final colorEstado = disponibleVisible
        ? (esOscuro ? AppColores.exitoOscuro : AppColores.exito)
        : (esOscuro ? tema.colorScheme.onSurfaceVariant : AppColores.ocupado);

    return Semantics(
      container: true,
      button: onTap != null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imagenVisible != null)
                EspacioImagen(
                  imagenUrl: imagenVisible,
                  etiqueta: nombreVisible,
                ),
              Padding(
                padding: const EdgeInsets.all(AppEspaciado.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(nombreVisible, style: tema.textTheme.titleLarge),
                    const SizedBox(height: AppEspaciado.xs),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: tema.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppEspaciado.xs),
                        Expanded(
                          child: Text(
                            ubicacionVisible,
                            style: tema.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    if (detalleVisible != null) ...[
                      const SizedBox(height: AppEspaciado.sm),
                      Text(
                        detalleVisible,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tema.textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: AppEspaciado.md),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppEspaciado.md,
                      runSpacing: AppEspaciado.xs,
                      children: [
                        if (capacidadVisible != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.groups_outlined,
                                size: 20,
                                color: tema.colorScheme.primary,
                              ),
                              const SizedBox(width: AppEspaciado.xs),
                              Flexible(
                                child: Text(
                                  capacidad != null || espacio != null
                                      ? 'Hasta $capacidadVisible jugadores'
                                      : capacidadVisible,
                                  style: tema.textTheme.titleMedium?.copyWith(
                                    color: tema.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Chip(
                          avatar: Icon(
                            disponibleVisible
                                ? Icons.check_circle_outline
                                : Icons.block,
                            size: 18,
                            color: colorEstado,
                          ),
                          label: Text(
                            disponibleVisible ? 'Disponible' : 'Ocupado',
                          ),
                          labelStyle: tema.textTheme.labelMedium?.copyWith(
                            color: colorEstado,
                          ),
                          backgroundColor: tema.colorScheme.surface,
                          side: BorderSide(color: colorEstado),
                        ),
                      ],
                    ),
                    if (actividadesVisibles.isNotEmpty) ...[
                      const SizedBox(height: AppEspaciado.sm),
                      Wrap(
                        spacing: AppEspaciado.xs,
                        runSpacing: AppEspaciado.xs,
                        children: [
                          for (final actividad in actividadesVisibles)
                            Chip(
                              label: Text(actividad),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide(
                                color: tema.colorScheme.outlineVariant,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EspacioImagen extends StatelessWidget {
  const EspacioImagen({
    super.key,
    required this.imagenUrl,
    required this.etiqueta,
    this.altura = 176,
  });

  final String imagenUrl;
  final String etiqueta;
  final double altura;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Imagen de $etiqueta',
      child: Image.network(
        imagenUrl,
        height: altura,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _imagenAlternativa(altura);
        },
        errorBuilder: (context, error, stackTrace) =>
            _imagenAlternativa(altura),
      ),
    );
  }

  Widget _imagenAlternativa(double altura) {
    return SizedBox(
      height: altura,
      child: CustomPaint(
        painter: _PistaPintada(),
        child: const Center(
          child: Icon(Icons.sports_tennis, color: Colors.white, size: 48),
        ),
      ),
    );
  }
}

class _PistaPintada extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fondo = Paint()..color = const Color(0xFF317B55);
    final lineas = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Offset.zero & size, fondo);
    final rectangulo = Rect.fromLTWH(
      size.width * 0.14,
      size.height * 0.14,
      size.width * 0.72,
      size.height * 0.72,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rectangulo,
        const Radius.circular(AppBordes.medio),
      ),
      lineas,
    );
    canvas.drawLine(
      Offset(size.width / 2, rectangulo.top),
      Offset(size.width / 2, rectangulo.bottom),
      lineas,
    );
    canvas.drawLine(
      Offset(rectangulo.left, size.height / 2),
      Offset(rectangulo.right, size.height / 2),
      lineas,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
