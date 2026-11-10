/// Formatos compartidos por las pantallas; no necesitan paquetes adicionales.
String formatearPrecio(double importe) =>
    importe.toStringAsFixed(2).replaceAll('.', ',');

String formatearFecha(DateTime fecha) {
  const dias = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];
  const meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  final dia = dias[fecha.weekday - 1];
  return '${dia[0].toUpperCase()}${dia.substring(1)}, '
      '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
}

String formatearHora(DateTime fecha) =>
    '${fecha.hour.toString().padLeft(2, '0')}:'
    '${fecha.minute.toString().padLeft(2, '0')}';

String formatearFechaCorta(DateTime fecha) {
  const meses = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];
  return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
}
