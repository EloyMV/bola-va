import 'package:flutter/material.dart';

import '../../core/theme/app_bordes.dart';
import '../../core/theme/app_espaciado.dart';
import '../../core/theme/app_tema.dart';
import '../../core/ui/pagina_base.dart';
import 'fondo_acceso.dart';

/// Login y registro comparten la cabecera, el panel y el tema de core.
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

    return Theme(
      data: tema,
      child: PaginaBase(
        titulo: titulo,
        fondo: const FondoAcceso(),
        anchoMaximo: AppEspaciado.anchoFormulario,
        centrarContenido: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppBordes.grande),
                  child: Image.asset(
                    'assets/images/bola_va_icono.png',
                    width: AppEspaciado.xl * 2,
                    height: AppEspaciado.xl * 2,
                    cacheWidth: 192,
                    excludeFromSemantics: true,
                  ),
                ),
                const SizedBox(width: AppEspaciado.md),
                Expanded(
                  child: Text(
                    cabecera,
                    style: tema.textTheme.headlineLarge?.copyWith(
                      color: tema.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppEspaciado.md),
            Text(
              mensaje,
              style: tema.textTheme.bodyLarge?.copyWith(
                color: tema.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: AppEspaciado.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppEspaciado.md),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
