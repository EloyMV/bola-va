class ServicioExtra {
  const ServicioExtra({required this.nombre, required this.icono, this.precio});

  final String nombre;

  /// Clave que la pantalla relaciona con un icono Material.
  final String icono;

  /// Nulo si forma parte del espacio; si tiene precio, se cobra por reserva.
  final double? precio;
}
