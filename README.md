# Bola Va

App de reservas de pistas de pádel en Flutter, con una base visual compartida para desarrollar entre dos personas.
En Flutter, los estilos se definen en Dart mediante temas y widgets.

## Estilos compartidos

El tema se aplica a toda la aplicación desde `lib/main.dart`. Se utiliza un tema
claro fijo, con verde oscuro, azul de pista y lima, sin descargar fuentes ni añadir
dependencias. Botones, campos, tarjetas, navegación y selectores de fecha y hora
reciben sus estilos automáticamente.

| Archivo en `lib/ui/core/theme/` | Qué se define aquí |
| --- | --- |
| `app_colores.dart` | Paleta y colores para estados y errores. |
| `app_espaciado.dart` | Separaciones, márgenes y anchos máximos. |
| `app_bordes.dart` | Radios de esquinas. |
| `app_tema.dart` | Tipografía y apariencia de los componentes Material. |

Para mantener el diseño común:

1. Usad `Theme.of(context).textTheme` para los textos y
   `Theme.of(context).colorScheme` para los colores del tema.
2. Usad `AppEspaciado` y `AppBordes` para márgenes y esquinas. Evitad repetir
   valores de diseño dentro de las pantallas.
3. Reutilizad `PaginaBase`, `EspacioTarjeta`, `ReservaTarjeta` y `EstadoVacio`,
   que están en `lib/ui/core/ui/`.
4. Para cambiar un estilo general, modificad su archivo compartido; así el
   cambio se aplica en todas las pantallas que lo utilizan.

## Pantallas preparadas

Las siete pantallas son plantillas visuales con título, descripción y estado
vacío. Cada una acepta un widget `contenido` para añadir más adelante su
formulario, lista o detalle sin reconstruir el diseño exterior. Los formularios
de acceso tienen un ancho máximo de 440 y el contenido general, de 1100 píxeles
lógicos. La base adapta los márgenes al ancho disponible y permite desplazarse
cuando el contenido crece o se abre el teclado.

`PaginaBase` ya controla el desplazamiento. Dentro de `contenido`, usad `Column`
para contenido pequeño. Si añadís un `ListView` o `GridView`, configurad
`shrinkWrap: true` y `physics: const NeverScrollableScrollPhysics()` para que
desplace la página exterior. Evitad `Expanded` y `Spacer` verticales dentro de
ese contenido, porque el área desplazable no tiene una altura máxima.

Por ejemplo, en un archivo que esté en `lib/ui/acceso/ui/`:

```dart
import 'package:flutter/material.dart';

import '../../core/theme/app_espaciado.dart';
import 'login_screen.dart';

Widget ejemploAcceso() {
  return LoginScreen(
    contenido: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TextField(
          decoration: InputDecoration(labelText: 'Correo electrónico'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppEspaciado.md),
        const TextField(
          decoration: InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
      ],
    ),
  );
}
```

Los campos ya usan los bordes, colores y textos del tema. La autenticación,
la navegación y la lógica de reservas se añadirán después. Los modelos y la
capa de datos siguen disponibles para desarrollar esa funcionalidad.

## Trabajar entre dos personas

Repartíos las pantallas y trabajad cada uno en su rama. Acordad los cambios de
`lib/ui/core/`, porque afectan al diseño común. Compartir el tema mantiene los
estilos al integrar los commits; Git todavía puede pedir resolver conflictos si
ambos editáis las mismas líneas. Sincronizad las ramas antes de empezar una tarea
y antes de integrarla.

Antes de integrar cambios:

```sh
dart format lib test
flutter analyze
flutter test
```
