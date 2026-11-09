import 'package:flutter/material.dart';

import '../../../domain/models/usuario.dart';
import '../../core/theme/app_espaciado.dart';

class TarjetaUsuario extends StatelessWidget {
  const TarjetaUsuario({super.key, required this.usuario});

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final texto = Theme.of(context).textTheme;

    return Card(
      color: colores.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppEspaciado.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TU CUENTA EN BOLA VA',
              style: texto.labelLarge?.copyWith(color: colores.onPrimary),
            ),
            const SizedBox(height: AppEspaciado.lg),
            CircleAvatar(
              radius: AppEspaciado.xl,
              backgroundColor: colores.primaryContainer,
              foregroundColor: colores.onPrimaryContainer,
              child: Text(usuario.iniciales, style: texto.titleLarge),
            ),
            const SizedBox(height: AppEspaciado.md),
            Text(
              usuario.nombre,
              style: texto.headlineMedium?.copyWith(color: colores.onPrimary),
            ),
            const SizedBox(height: AppEspaciado.xs),
            Text(
              usuario.correo,
              style: texto.bodyLarge?.copyWith(color: colores.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
