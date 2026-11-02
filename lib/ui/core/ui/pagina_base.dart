import 'package:flutter/material.dart';

import '../theme/app_espaciado.dart';

/// Marco común para que todas las pantallas compartan márgenes y anchura.
class PaginaBase extends StatelessWidget {
  const PaginaBase({
    super.key,
    required this.titulo,
    this.subtitulo,
    required this.child,
    this.anchoMaximo = AppEspaciado.anchoContenido,
    this.centrarContenido = false,
    this.acciones,
  });

  final String titulo;
  final String? subtitulo;
  final Widget child;
  final double anchoMaximo;
  final bool centrarContenido;
  final List<Widget>? acciones;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: acciones,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final margen = constraints.maxWidth < 600
                ? AppEspaciado.md
                : AppEspaciado.lg;
            final alturaMinima = (constraints.maxHeight - margen * 2)
                .clamp(0.0, double.infinity)
                .toDouble();

            return SingleChildScrollView(
              padding: EdgeInsets.all(margen),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: alturaMinima),
                child: Align(
                  alignment: centrarContenido
                      ? Alignment.center
                      : Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: anchoMaximo),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (subtitulo != null) ...[
                          Text(
                            subtitulo!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppEspaciado.lg),
                        ],
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
