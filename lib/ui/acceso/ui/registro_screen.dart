import 'package:flutter/material.dart';

import '../../../data/services/datos_demo.dart';
import '../../core/theme/app_espaciado.dart';
import 'campo_acceso.dart';
import 'pagina_acceso.dart';

/// Alta ficticia: los campos solo muestran datos y no se guarda ninguna cuenta.
class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key, this.contenido});

  final Widget? contenido;

  Future<void> _mostrarConfirmacion(BuildContext context) async {
    final volverAlLogin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: const Text('Todo listo'),
        content: const Text('Vuelve al inicio de sesión para continuar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Seguir aquí'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Volver al login'),
          ),
        ],
      ),
    );

    // El diálogo devuelve true solo al elegir volver al login.
    if (!context.mounted || volverAlLogin != true) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PaginaAcceso(
      titulo: 'Crear cuenta',
      cabecera: 'Bola Va',
      mensaje: 'Nos vemos en la pista.',
      child:
          contenido ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CampoAcceso(
                      etiqueta: 'Nombre y apellidos',
                      icono: Icons.person_outline,
                      valorInicial: DatosDemo.usuario.nombre,
                      tipoTeclado: TextInputType.name,
                    ),
                    const SizedBox(height: AppEspaciado.md),
                    CampoAcceso(
                      etiqueta: 'Correo electrónico',
                      icono: Icons.mail_outline,
                      valorInicial: DatosDemo.usuario.correo,
                      tipoTeclado: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppEspaciado.md),
                    const CampoAcceso(
                      etiqueta: 'Contraseña',
                      icono: Icons.lock_outline,
                      valorInicial: 'padel1234',
                      esContrasena: true,
                    ),
                    const SizedBox(height: AppEspaciado.md),
                    const CampoAcceso(
                      etiqueta: 'Repetir contraseña',
                      icono: Icons.lock_outline,
                      valorInicial: 'padel1234',
                      esContrasena: true,
                    ),
                    const SizedBox(height: AppEspaciado.lg),
                    FilledButton(
                      onPressed: () => _mostrarConfirmacion(context),
                      child: const Text('Crear cuenta'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppEspaciado.md),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Volver al inicio de sesión'),
              ),
            ],
          ),
    );
  }
}
