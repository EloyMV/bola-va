/// Información pública del usuario. Las contraseñas no forman parte del modelo.
class Usuario {
  const Usuario({
    required this.nombre,
    required this.correo,
    required this.iniciales,
  });

  final String nombre;
  final String correo;
  final String iniciales;
}
