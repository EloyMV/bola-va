import '../../domain/models/comentario.dart';
import '../../domain/models/espacio.dart';

/// Opiniones compartidas mientras la aplicación está abierta, sin almacenamiento.
abstract final class ComentariosRepository {
  static final Map<String, List<Comentario>> _comentariosPorEspacio = {};

  static List<Comentario> obtener(Espacio espacio) =>
      List.unmodifiable(_opinionesDe(espacio));

  static void agregar(Espacio espacio, Comentario comentario) {
    _opinionesDe(espacio).insert(0, comentario);
  }

  static List<Comentario> _opinionesDe(Espacio espacio) =>
      _comentariosPorEspacio.putIfAbsent(
        espacio.id,
        () => List<Comentario>.of(espacio.opiniones),
      );

  static void restablecer() => _comentariosPorEspacio.clear();
}
