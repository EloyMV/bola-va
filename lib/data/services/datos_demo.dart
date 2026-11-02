import '../../domain/models/espacio.dart';

abstract final class DatosDemo {
  static const List<Espacio> espacios = [
    Espacio(
      id: 'central',
      nombre: 'Pista Central',
      ubicacion: 'Club Bola Va · Zona centro',
      capacidad: 4,
      actividades: ['Pádel', 'Clases'],
      imagenUrl: 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1200&q=80',
      descripcion:
          'Una pista panorámica con iluminación LED y espacio para disfrutar '
          'de partidos y clases durante todo el día.',
    ),
    Espacio(
      id: 'panoramica',
      nombre: 'Pista Panorámica',
      ubicacion: 'Club Bola Va · Terraza norte',
      capacidad: 4,
      actividades: ['Pádel', 'Torneos'],
      imagenUrl: 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
      descripcion:
          'Juega con vistas despejadas en esta pista de cristal preparada '
          'para partidos y torneos.',
    ),
    Espacio(
      id: 'indoor',
      nombre: 'Pista Indoor',
      ubicacion: 'Club Bola Va · Pabellón cubierto',
      capacidad: 4,
      actividades: ['Pádel', 'Clases'],
      imagenUrl: 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&w=1200&q=80',
      descripcion: 'Un espacio cubierto para jugar con comodidad haga el tiempo que haga.',
    ),
    Espacio(
      id: 'escuela',
      nombre: 'Pista Escuela',
      ubicacion: 'Club Bola Va · Zona de iniciación',
      capacidad: 4,
      actividades: ['Pádel', 'Formación'],
      imagenUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=1200&q=80',
      descripcion:
          'Ideal para aprender y perfeccionar tu técnica con sesiones guiadas.',
    ),
    Espacio(
      id: 'multiusos',
      nombre: 'Pista Multiusos',
      ubicacion: 'Club Bola Va · Patio este',
      capacidad: 4,
      actividades: ['Pádel', 'Partidos'],
      imagenUrl: 'https://images.unsplash.com/photo-1599586120429-48281b6f0b5b?auto=format&fit=crop&w=1200&q=80',
      descripcion:
          'Una pista versátil para organizar partidas amistosas y encuentros '
          'entre jugadores.',
    ),
    Espacio(
      id: 'pro',
      nombre: 'Pista Pro',
      ubicacion: 'Club Bola Va · Zona competición',
      capacidad: 4,
      actividades: ['Pádel', 'Competición'],
      imagenUrl: 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
      descripcion:
          'Un espacio amplio para entrenamientos intensivos y partidos '
          'de alto nivel.',
    ),
  ];
}
