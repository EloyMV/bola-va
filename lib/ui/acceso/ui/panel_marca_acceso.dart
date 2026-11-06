import 'package:flutter/material.dart';

import '../../core/theme/app_colores.dart';
import '../../core/theme/app_espaciado.dart';

/// El icono y el nombre mantienen la identidad en las dos composiciones.
class MarcaAcceso extends StatelessWidget {
  const MarcaAcceso({
    super.key,
    required this.nombre,
    this.sobreOscuro = false,
  });

  final String nombre;
  final bool sobreOscuro;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/bola_va_icono.png',
            width: 44,
            height: 44,
            cacheWidth: 132,
            excludeFromSemantics: true,
          ),
        ),
        const SizedBox(width: AppEspaciado.sm),
        Expanded(
          child: Text(
            nombre,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: sobreOscuro
                  ? AppColores.superficie
                  : AppColores.accesoTinta,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// Panel editorial para pantallas anchas; la pista se dibuja con widgets.
class PanelMarcaAcceso extends StatelessWidget {
  const PanelMarcaAcceso({super.key, required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppEspaciado.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColores.accesoTinta, AppColores.primario],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarcaAcceso(nombre: nombre, sobreOscuro: true),
          const SizedBox(height: AppEspaciado.xxl),
          Text(
            'MENOS ORGANIZAR.\nMÁS JUGAR.',
            style: texto.displaySmall?.copyWith(
              color: AppColores.superficie,
              fontSize: 46,
              height: 1.06,
              fontWeight: FontWeight.w600,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: AppEspaciado.md),
          Text(
            'Encuentra tu pista y vuelve\na lo que importa.',
            style: texto.bodyLarge?.copyWith(
              color: AppColores.superficie.withValues(alpha: 0.72),
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppEspaciado.lg),
          const Expanded(child: Center(child: IlustracionPistaAcceso())),
          const SizedBox(height: AppEspaciado.lg),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColores.acento,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppEspaciado.sm),
              Expanded(
                child: Text(
                  'A UN TOQUE DE TU PRÓXIMA PARTIDA',
                  style: texto.labelSmall?.copyWith(
                    color: AppColores.superficie.withValues(alpha: 0.72),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Líneas de una pista y una bola: sin imágenes remotas ni datos ficticios extra.
class IlustracionPistaAcceso extends StatelessWidget {
  const IlustracionPistaAcceso({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.md),
        child: Transform.rotate(
          angle: -0.12,
          child: LayoutBuilder(
            builder: (context, limites) {
              final ancho = limites.maxWidth;
              final alto = limites.maxHeight;
              final linea = AppColores.superficie.withValues(alpha: 0.27);

              return Container(
                decoration: BoxDecoration(
                  color: AppColores.superficie.withValues(alpha: 0.035),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: linea, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 40,
                      offset: const Offset(0, 24),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: ancho * 0.25,
                      child: Container(width: 1, color: linea),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: ancho * 0.25,
                      child: Container(width: 1, color: linea),
                    ),
                    Positioned(
                      top: alto * 0.5,
                      left: ancho * 0.25,
                      right: ancho * 0.25,
                      child: Container(height: 1, color: linea),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: ancho * 0.5,
                      child: Container(
                        width: 2,
                        color: AppColores.superficie.withValues(alpha: 0.6),
                      ),
                    ),
                    Positioned(
                      top: alto * 0.24,
                      right: ancho * 0.15,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColores.acento,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Stack(
                            children: [
                              Positioned(
                                left: 15,
                                top: -7,
                                bottom: -7,
                                child: Container(
                                  width: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: AppColores.accesoTinta.withValues(
                                        alpha: 0.55,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
