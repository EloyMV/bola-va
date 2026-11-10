import 'package:flutter/material.dart';

import '../theme/app_espaciado.dart';
import 'navegacion_principal.dart';

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
    this.fondo,
    this.seccionActual,
  });

  final String titulo;
  final String? subtitulo;
  final Widget child;
  final double anchoMaximo;
  final bool centrarContenido;
  final List<Widget>? acciones;
  final Widget? fondo;
  final SeccionPrincipal? seccionActual;

  @override
  Widget build(BuildContext context) {
    final pagina = Scaffold(
      backgroundColor: fondo == null ? null : Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: seccionActual == null,
        toolbarHeight:
            (MediaQuery.textScalerOf(context).scale(18) + AppEspaciado.lg)
                .clamp(kToolbarHeight, 112),
        backgroundColor: fondo == null ? null : Colors.transparent,
        title: Text(titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          ...?acciones,
          AccesoPerfil(seccionActual: seccionActual),
          const SizedBox(width: AppEspaciado.xs),
        ],
      ),
      bottomNavigationBar: NavegacionPrincipal(seccionActual: seccionActual),
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

    if (fondo == null) return pagina;

    return Stack(
      fit: StackFit.expand,
      children: [
        // El fondo es decorativo: no intercepta gestos ni añade lecturas.
        Positioned.fill(
          child: IgnorePointer(child: ExcludeSemantics(child: fondo!)),
        ),
        pagina,
      ],
    );
  }
}
