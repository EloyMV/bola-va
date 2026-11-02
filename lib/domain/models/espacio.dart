class Espacio {
  const Espacio({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.capacidad,
    required this.actividades,
    required this.imagenUrl,
    required this.descripcion,
    this.disponible = true,
  });

  final String id;
  final String nombre;
  final String ubicacion;
  final int capacidad;
  final List<String> actividades;
  final String imagenUrl;
  final String descripcion;
  final bool disponible;
}
