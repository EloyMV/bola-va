import 'package:flutter/material.dart';

import '../theme/app_bordes.dart';
import '../theme/app_colores.dart';

/// Imagen compartida por catálogo y galería, con alternativa sin conexión.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final ancho = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final pixeles = (ancho * MediaQuery.devicePixelRatioOf(context)).ceil();
        // Agrupar anchos evita descargar otra imagen por cada pequeño cambio.
        final anchoImagen = ((pixeles / 128).ceil() * 128)
            .clamp(128, 1600)
            .toInt();
        return Semantics(
          image: true,
          label: 'Imagen de $etiqueta',
          child: Image.network(
            _urlParaAncho(anchoImagen),
            height: altura,
            width: double.infinity,
            cacheWidth: anchoImagen,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
            frameBuilder: (context, child, frame, cargadaSincrona) {
              if (cargadaSincrona || frame != null) return child;
              return _ImagenAlternativa(altura: altura);
            },
            errorBuilder: (context, error, stackTrace) =>
                _ImagenAlternativa(altura: altura),
          ),
        );
      },
    );
  }

  String _urlParaAncho(int ancho) {
    final uri = Uri.tryParse(imagenUrl);
    if (uri == null || uri.host != 'images.unsplash.com') return imagenUrl;
    final anchoOriginal = int.tryParse(uri.queryParameters['w'] ?? '');
    final anchoPedido = anchoOriginal != null && anchoOriginal < ancho
        ? anchoOriginal
        : ancho;
    return uri
        .replace(queryParameters: {...uri.queryParameters, 'w': '$anchoPedido'})
        .toString();
  }
}

class _ImagenAlternativa extends StatelessWidget {
  const _ImagenAlternativa({required this.altura});

  final double altura;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: altura,
      child: CustomPaint(
        painter: const _PistaPintada(),
        child: const Center(
          child: Icon(Icons.sports_tennis, color: Colors.white, size: 48),
        ),
      ),
    );
  }
}

class _PistaPintada extends CustomPainter {
  const _PistaPintada();

  @override
  void paint(Canvas canvas, Size size) {
    final fondo = Paint()..color = AppColores.primario;
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
