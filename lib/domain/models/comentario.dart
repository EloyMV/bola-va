class Comentario {
  const Comentario({
    required this.autor,
    required this.fecha,
    required this.texto,
    required this.puntuacion,
  }) : assert(puntuacion >= 1 && puntuacion <= 5);

  final String autor;
  final String fecha;
  final String texto;
  final int puntuacion;
}
