import 'package:flutter/material.dart';

import '../../../data/services/datos_demo.dart';
import '../../core/theme/app_espaciado.dart';
import '../../espacios/ui/espacios_screen.dart';
import 'boton_acceso_social.dart';
import 'campo_acceso.dart';
import 'pagina_acceso.dart';
import 'registro_screen.dart';

/// Acceso de demostración: no comprueba credenciales ni conecta cuentas externas.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.contenido});

  final Widget? contenido;

  void _entrar(BuildContext context) {
    final navigator = Navigator.of(context);

    // Las tres formas de acceso abren el mismo usuario ficticio.
    navigator.pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(
        builder: (_) => EspaciosScreen(nombreUsuario: DatosDemo.usuario.nombre),
      ),
      (route) => false,
    );
  }

  void _abrirRegistro(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const RegistroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginaAcceso(
      titulo: 'Iniciar sesión',
      cabecera: 'Bola Va',
      mensaje: '¡Bienvenido! Tu próxima partida empieza aquí.',
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
                    const SizedBox(height: AppEspaciado.lg),
                    FilledButton(
                      onPressed: () => _entrar(context),
                      child: const Text('Entrar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppEspaciado.lg),
              const Text('O continúa con', textAlign: TextAlign.center),
              const SizedBox(height: AppEspaciado.md),
              BotonAccesoSocial(
                proveedor: 'Google',
                icono: Icons.g_mobiledata,
                onPressed: () => _entrar(context),
              ),
              const SizedBox(height: AppEspaciado.sm),
              BotonAccesoSocial(
                proveedor: 'Apple',
                icono: Icons.apple,
                onPressed: () => _entrar(context),
              ),
              const SizedBox(height: AppEspaciado.lg),
              const Text(
                '¿Todavía no tienes cuenta?',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => _abrirRegistro(context),
                child: const Text('Registrarse'),
              ),
            ],
          ),
    );
  }
}
