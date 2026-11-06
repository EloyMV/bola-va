import 'package:flutter/material.dart';

import '../../core/theme/app_colores.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/theme/app_tema.dart';
import 'fondo_acceso.dart';
import 'panel_marca_acceso.dart';

/// Composición compartida: marca compacta en móvil y dos columnas en escritorio.
class PaginaAcceso extends StatelessWidget {
  const PaginaAcceso({
    super.key,
    required this.titulo,
    required this.cabecera,
    required this.mensaje,
    required this.child,
  });

  final String titulo;
  final String cabecera;
  final String mensaje;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tema = AppTema.acceso;
    final puedeVolver = ModalRoute.of(context)?.canPop ?? false;
    final reducirMovimiento = MediaQuery.disableAnimationsOf(context);

    return Theme(
      data: tema,
      child: Scaffold(
        backgroundColor: AppColores.accesoFondo,
        body: Stack(
          children: [
            const Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(child: FondoAcceso()),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, limites) {
                  final escritorio =
                      limites.maxWidth >= 1000 &&
                      MediaQuery.textScalerOf(context).scale(1) <= 1.3;
                  final margen = limites.maxWidth >= 600
                      ? AppEspaciado.xl
                      : AppEspaciado.md;
                  final alturaMinima = (limites.maxHeight - margen * 2)
                      .clamp(0.0, double.infinity)
                      .toDouble();
                  final formulario = _formulario(tema, puedeVolver, escritorio);

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(margen),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: alturaMinima),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: escritorio ? 1180 : 480,
                          ),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: reducirMovimiento
                                ? Duration.zero
                                : const Duration(milliseconds: 380),
                            curve: Curves.easeOutCubic,
                            builder: (context, progreso, contenido) => Opacity(
                              opacity: progreso,
                              child: Transform.translate(
                                offset: Offset(0, 12 * (1 - progreso)),
                                child: contenido,
                              ),
                            ),
                            child: escritorio
                                ? Row(
                                    children: [
                                      Expanded(
                                        flex: 11,
                                        child: SizedBox(
                                          height:
                                              (limites.maxHeight - margen * 2)
                                                  .clamp(680.0, 820.0)
                                                  .toDouble(),
                                          child: PanelMarcaAcceso(
                                            nombre: cabecera,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppEspaciado.xxl),
                                      Expanded(
                                        flex: 10,
                                        child: Align(
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxWidth: 460,
                                            ),
                                            child: formulario,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          if (puedeVolver) ...[
                                            const BackButton(),
                                            const SizedBox(
                                              width: AppEspaciado.xxs,
                                            ),
                                          ],
                                          Expanded(
                                            child: MarcaAcceso(
                                              nombre: cabecera,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppEspaciado.lg),
                                      formulario,
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formulario(ThemeData tema, bool puedeVolver, bool escritorio) {
    return Container(
      padding: const EdgeInsets.all(AppEspaciado.lg),
      decoration: BoxDecoration(
        color: AppColores.superficie,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColores.accesoBorde),
        boxShadow: [
          BoxShadow(
            color: AppColores.accesoTinta.withValues(alpha: 0.045),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (puedeVolver && escritorio) ...[
            const Align(alignment: Alignment.centerLeft, child: BackButton()),
            const SizedBox(height: AppEspaciado.sm),
          ],
          Text(
            'TU ESPACIO EN EL CLUB',
            style: tema.textTheme.labelSmall?.copyWith(
              color: AppColores.accesoTextoSecundario,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: AppEspaciado.sm),
          Text(
            titulo,
            style: tema.textTheme.headlineMedium?.copyWith(
              color: AppColores.accesoTinta,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.8,
              height: 1.15,
            ),
          ),
          const SizedBox(height: AppEspaciado.sm),
          Text(
            mensaje,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: AppColores.accesoTextoSecundario,
            ),
          ),
          const SizedBox(height: AppEspaciado.lg),
          child,
        ],
      ),
    );
  }
}
