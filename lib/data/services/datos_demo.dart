import '../../domain/models/comentario.dart';
import '../../domain/models/contacto_local.dart';
import '../../domain/models/disponibilidad_dia.dart';
import '../../domain/models/espacio.dart';
import '../../domain/models/franja_disponibilidad.dart';
import '../../domain/models/servicio_extra.dart';

abstract final class DatosDemo {
  static const List<Comentario> _opinionesDemo = [
    Comentario(
      autor: 'Lucía M.',
      fecha: '24 oct 2026',
      texto: 'La pista estaba muy cuidada y la iluminación fue perfecta.',
      puntuacion: 5,
    ),
    Comentario(
      autor: 'David R.',
      fecha: '18 oct 2026',
      texto: 'Buena atención y un horario cómodo para jugar.',
      puntuacion: 4,
    ),
  ];

  static const List<Espacio> espacios = [
    Espacio(
      id: 'central',
      nombre: 'Pista Central',
      ubicacion: 'Club Bola Va · Zona centro',
      capacidad: 4,
      actividades: ['Pádel', 'Clases'],
      imagenUrl: 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1200&q=80',
      imagenesUrl: [
        'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&w=1200&q=80',
      ],
      descripcion:
          'Una pista panorámica con iluminación LED y espacio para disfrutar '
          'de partidos y clases durante todo el día.',
      servicios: [
        ServicioExtra(nombre: 'Iluminación LED', icono: 'luz'),
        ServicioExtra(nombre: 'Vestuarios y duchas', icono: 'ducha'),
        ServicioExtra(nombre: 'Aparcamiento gratuito', icono: 'parking'),
      ],
      tarifaHora: 24,
      contacto: ContactoLocal(
        nombre: 'Marta Soler',
        telefono: '600 111 222',
        correo: 'marta@bolava.example',
      ),
      condicionesUso:
          'Es obligatorio usar calzado deportivo. La reserva incluye '
          'iluminación; no está permitido fumar en la pista.',
      horarioUso: 'Lunes a domingo · 08:00–22:00',
      sitioWeb: 'www.bolava.example',
      opiniones: _opinionesDemo,
    ),
    Espacio(
      id: 'panoramica',
      nombre: 'Pista Panorámica',
      ubicacion: 'Club Bola Va · Terraza norte',
      capacidad: 4,
      actividades: ['Pádel', 'Torneos'],
      imagenUrl: 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
      imagenesUrl: [
        'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1599586120429-48281b6f0b5b?auto=format&fit=crop&w=1200&q=80',
      ],
      descripcion:
          'Juega con vistas despejadas en esta pista de cristal preparada '
          'para partidos y torneos.',
      servicios: [
        ServicioExtra(nombre: 'Zona de descanso', icono: 'descanso'),
        ServicioExtra(nombre: 'Alquiler de raquetas', icono: 'raqueta'),
        ServicioExtra(nombre: 'Vestuarios', icono: 'vestuario'),
      ],
      tarifaHora: 28,
      contacto: ContactoLocal(
        nombre: 'Pau Ferrer',
        telefono: '600 222 333',
        correo: 'pau@bolava.example',
      ),
      condicionesUso:
          'Respeta el turno reservado y devuelve el material alquilado '
          'en recepción al terminar.',
      horarioUso:
          'Lunes a viernes · 09:00–22:00 · Fines de semana · 09:00–21:00',
      sitioWeb: null,
      opiniones: _opinionesDemo,
    ),
    Espacio(
      id: 'indoor',
      nombre: 'Pista Indoor',
      ubicacion: 'Club Bola Va · Pabellón cubierto',
      capacidad: 4,
      actividades: ['Pádel', 'Clases'],
      imagenUrl: 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&w=1200&q=80',
      imagenesUrl: [
        'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=1200&q=80',
      ],
      descripcion: 'Un espacio cubierto para jugar con comodidad haga el tiempo que haga.',
      servicios: [
        ServicioExtra(nombre: 'Pista cubierta', icono: 'cubierta'),
        ServicioExtra(nombre: 'Vestuarios y duchas', icono: 'ducha'),
        ServicioExtra(nombre: 'Alquiler de raquetas', icono: 'raqueta'),
      ],
      tarifaHora: 26,
      contacto: ContactoLocal(
        nombre: 'Núria Vidal',
        telefono: '600 333 444',
        correo: 'nuria@bolava.example',
      ),
      condicionesUso:
          'Deja la pista limpia y sigue las indicaciones del personal del '
          'pabellón.',
      horarioUso: 'Todos los días · 08:00–23:00',
      sitioWeb: 'www.bolava.example/indoor',
      opiniones: _opinionesDemo,
    ),
    Espacio(
      id: 'escuela',
      nombre: 'Pista Escuela',
      ubicacion: 'Club Bola Va · Zona de iniciación',
      capacidad: 4,
      actividades: ['Pádel', 'Formación'],
      imagenUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=1200&q=80',
      imagenesUrl: [
        'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1599586120429-48281b6f0b5b?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1200&q=80',
      ],
      descripcion:
          'Ideal para aprender y perfeccionar tu técnica con sesiones guiadas.',
      servicios: [
        ServicioExtra(nombre: 'Clases con monitor', icono: 'monitor'),
        ServicioExtra(nombre: 'Material de iniciación', icono: 'raqueta'),
        ServicioExtra(nombre: 'Taquillas', icono: 'taquilla'),
      ],
      tarifaHora: 22,
      contacto: ContactoLocal(
        nombre: 'Joan Martí',
        telefono: '600 444 555',
        correo: 'joan@bolava.example',
      ),
      condicionesUso:
          'Las clases deben reservarse con antelación. Se recomienda llegar '
          'diez minutos antes.',
      horarioUso: 'Lunes a sábado · 09:00–21:00',
      sitioWeb: 'www.bolava.example/escuela',
      opiniones: _opinionesDemo,
    ),
    Espacio(
      id: 'multiusos',
      nombre: 'Pista Multiusos',
      ubicacion: 'Club Bola Va · Patio este',
      capacidad: 4,
      actividades: ['Pádel', 'Partidos'],
      imagenUrl: 'https://images.unsplash.com/photo-1599586120429-48281b6f0b5b?auto=format&fit=crop&w=1200&q=80',
      imagenesUrl: [
        'https://images.unsplash.com/photo-1599586120429-48281b6f0b5b?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&w=1200&q=80',
      ],
      descripcion:
          'Una pista versátil para organizar partidas amistosas y encuentros '
          'entre jugadores.',
      servicios: [
        ServicioExtra(nombre: 'Aparcamiento', icono: 'parking'),
        ServicioExtra(nombre: 'Zona de descanso', icono: 'descanso'),
        ServicioExtra(nombre: 'Iluminación LED', icono: 'luz'),
      ],
      tarifaHora: 20,
      contacto: ContactoLocal(
        nombre: 'Aina Costa',
        telefono: '600 555 666',
        correo: 'aina@bolava.example',
      ),
      condicionesUso:
          'No se permite consumir comida dentro de la pista. Hay papeleras '
          'en la zona de descanso.',
      horarioUso: 'Todos los días · 08:00–22:00',
      sitioWeb: null,
      opiniones: _opinionesDemo,
    ),
    Espacio(
      id: 'pro',
      nombre: 'Pista Pro',
      ubicacion: 'Club Bola Va · Zona competición',
      capacidad: 4,
      actividades: ['Pádel', 'Competición'],
      imagenUrl: 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
      imagenesUrl: [
        'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1599586120429-48281b6f0b5b?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1200&q=80',
      ],
      descripcion:
          'Un espacio amplio para entrenamientos intensivos y partidos '
          'de alto nivel.',
      servicios: [
        ServicioExtra(nombre: 'Iluminación de competición', icono: 'luz'),
        ServicioExtra(nombre: 'Marcador manual', icono: 'marcador'),
        ServicioExtra(nombre: 'Vestuarios', icono: 'vestuario'),
      ],
      tarifaHora: 32,
      contacto: ContactoLocal(
        nombre: 'Marc Soler',
        telefono: '600 666 777',
        correo: 'marc@bolava.example',
      ),
      condicionesUso:
          'El uso del marcador y el material de competición debe solicitarse '
          'en recepción.',
      horarioUso: 'Lunes a domingo · 08:00–22:00',
      sitioWeb: 'www.bolava.example/competicion',
      opiniones: _opinionesDemo,
    ),
  ];

  static const List<List<bool>> _patronesDisponibilidad = [
    [true, false, true],
    [false, true, false],
    [true, true, false],
    [false, false, true],
  ];

  static List<DisponibilidadDia> disponibilidadSemana(
    String espacioId, {
    DateTime? referencia,
  }) {
    final fecha = referencia ?? DateTime.now();
    final hoy = DateTime(fecha.year, fecha.month, fecha.day);
    final indiceEncontrado = espacios.indexWhere(
      (espacio) => espacio.id == espacioId,
    );
    final indiceEspacio = indiceEncontrado < 0 ? 0 : indiceEncontrado;

    return List.generate(7, (indiceDia) {
      final estados =
          _patronesDisponibilidad[(indiceDia + indiceEspacio) %
              _patronesDisponibilidad.length];
      return DisponibilidadDia(
        fecha: DateTime(hoy.year, hoy.month, hoy.day + indiceDia),
        franjas: [
          FranjaDisponibilidad(
            horaInicio: '09:00',
            horaFin: '10:00',
            libre: estados[0],
          ),
          FranjaDisponibilidad(
            horaInicio: '17:00',
            horaFin: '18:00',
            libre: estados[1],
          ),
          FranjaDisponibilidad(
            horaInicio: '18:00',
            horaFin: '19:00',
            libre: estados[2],
          ),
        ],
      );
    });
  }
}
