import 'comentario.dart';
import 'contacto_local.dart';
import 'servicio_extra.dart';

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
    this.imagenesUrl = const [],
    this.servicios = const [],
    this.tarifaHora = 0,
    this.contacto,
    this.condicionesUso = '',
    this.horarioUso = '',
    this.sitioWeb,
    this.opiniones = const [],
  });

  final String id;
  final String nombre;
  final String ubicacion;
  final int capacidad;
  final List<String> actividades;
  final String imagenUrl;
  final String descripcion;
  final bool disponible;
  final List<String> imagenesUrl;
  final List<ServicioExtra> servicios;
  final double tarifaHora;
  final ContactoLocal? contacto;
  final String condicionesUso;
  final String horarioUso;
  final String? sitioWeb;
  final List<Comentario> opiniones;

  List<String> get galeriaImagenes =>
      imagenesUrl.isEmpty ? [imagenUrl] : imagenesUrl;
}
