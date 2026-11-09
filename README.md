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

Login y registro utilizan la variante `AppTema.acceso`, definida en ese mismo
archivo: fondo marfil, texto verde tinta, campos blancos de borde discreto y
botones principales oscuros. La lima se reserva para pequeños acentos de marca.
`PaginaAcceso`, en `lib/ui/acceso/ui/`, comparte esta composición entre las dos
pantallas con un formulario de ancho limitado y desplazamiento propio.
En escritorio añade un panel editorial con una pista de pádel dibujada con
widgets. En móvil, o al ampliar mucho el texto, prioriza el formulario.

La variante usa `claro.copyWith(...)`: parte del tema común y cambia solamente
algunos estilos. El widget `Theme` la aplica a sus descendientes. Así, el acceso
tiene su propio aspecto y las demás pantallas mantienen `AppTema.claro`.
Este uso de temas amplía la parte de decoración de los apuntes; la referencia
es la [documentación oficial de Theme](https://api.flutter.dev/flutter/material/Theme-class.html).

`FondoAcceso` añade luces radiales suaves detrás de la interfaz; `PanelMarcaAcceso`
compone la pista con bordes, filas y capas, siguiendo las
[capas de los apuntes](https://jovisal1.github.io/ApuntesPMDM/widgets/contenedores/capas-con-stack/).
`TweenAnimationBuilder` introduce el contenido con una transición breve de
opacidad y desplazamiento. La animación termina, respeta la preferencia de reducir
movimiento y no se repite mientras se escribe. Los botones responden al foco, al
ratón y a las pulsaciones mediante los estados de Material.

La animación amplía los ejemplos básicos del curso: `Tween` define el valor
inicial y final, `duration` su duración y el constructor reconstruye el efecto
durante la transición. Referencia: [TweenAnimationBuilder](https://api.flutter.dev/flutter/widgets/TweenAnimationBuilder-class.html).

## Icono de Bola Va

El original está en `assets/images/bola_va_icono.png` y su descripción de generación
en `assets/images/bola_va_icono.prompt.txt`. Se ha creado con la herramienta integrada
de imágenes: monograma geométrico BV verde tinta, punto lima y fondo marfil,
pensado para reconocerse a tamaño pequeño. La cabecera lo muestra con `Image.asset`,
registrado en `pubspec.yaml`.

El mismo diseño está preparado en los tamaños de los iconos existentes de Android,
iOS, macOS, Windows y web, incluido el favicon. Los tamaños son exportaciones del
original; no se han añadido paquetes de Flutter. Para ver el nuevo icono del lanzador
hay que recompilar e instalar la app; Hot Reload actualiza la interfaz.

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

El login y el registro incluyen sus campos y acciones simuladas. El catálogo
muestra las pistas de demostración y el perfil incluye sus datos y preferencias.
Las pantallas pendientes conservan su base visual con título, descripción y estado vacío.
Cada una acepta un widget `contenido` para añadir su formulario, lista o detalle
sin reconstruir el diseño exterior. El formulario de acceso ocupa hasta 460
píxeles lógicos en escritorio; la composición compacta llega a 480 y el contenido
general de otras pantallas, a 1100 píxeles
lógicos. La base adapta los márgenes al ancho disponible y permite desplazarse
cuando el contenido crece o se abre el teclado.

`PaginaBase` ya controla el desplazamiento. Dentro de `contenido`, usad `Column`
para contenido pequeño. Si añadís un `ListView` o `GridView`, configurad
`shrinkWrap: true` y `physics: const NeverScrollableScrollPhysics()` para que
desplace la página exterior. Evitad `Expanded` y `Spacer` verticales dentro de
ese contenido, porque el área desplazable no tiene una altura máxima.

Para probar un contenido alternativo en la base del login, por ejemplo desde un
archivo que esté en `lib/ui/acceso/ui/`:

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

Los campos ya usan los bordes, colores y textos del tema.

## Login simulado

Al arrancar se muestra `LoginScreen`. Los campos están rellenados con
`demo@bolava.es` y `demopadel`; la contraseña se muestra oculta. Se puede cambiar
o borrar cualquier dato: Entrar siempre abre la cuenta ficticia «Usuario demo».
Google y Apple hacen lo mismo y están identificados como simulados. No se
comprueban credenciales ni se conectan cuentas externas.

Los componentes específicos están en `lib/ui/acceso/ui/`:

- `CampoAcceso`: recibe etiqueta, icono, valor inicial, tipo de teclado y la
  variante `esContrasena`. Se reutiliza para nombre, correo y contraseñas.
- `BotonAccesoSocial`: recibe proveedor, icono y acción. Se reutiliza para Google
  y Apple con el mismo aspecto.
- `AvisoAccesoSimulado`: recibe título y mensaje. Login y registro reutilizan
  esta tarjeta para explicar su funcionamiento de demostración.

`TextFormField` dibuja cada campo y `initialValue` aporta su texto inicial. En
esta demostración no hace falta guardar ni validar lo escrito. `Form` agrupa
los campos para poder ampliar el formulario más adelante.

Registrarse abre el registro con `Navigator.push` y
`MaterialPageRoute`. La flecha superior permite regresar al login conservando
lo escrito.

Entrar abre la pantalla principal actual. Su botón superior Cerrar sesión
(icono de salida) vuelve a un login nuevo. Ambos cambios utilizan
`pushAndRemoveUntil` con una condición que siempre devuelve `false`: se retiran
todas las pantallas anteriores, para que Atrás no vuelva al acceso tras entrar
ni a la sesión después de cerrarla. El nombre y correo de la cuenta se obtienen
de `DatosDemo.usuario`. Espacios y Perfil comparten la función `cerrarSesion`,
definida en `lib/ui/acceso/ui/cerrar_sesion.dart`.

Referencias del curso: [TextFormField](https://jovisal1.github.io/ApuntesPMDM/formularis-i-navegacio/controles-de-entrada/texto-y-edicion/),
[Navigator](https://jovisal1.github.io/ApuntesPMDM/formularis-i-navegacio/navegacion/entre-pantallas/)
y [componentes del catálogo](https://jovisal1.github.io/ApuntesPMDM/widgets/configuracion-de-un-asistente-de-ia/el-proyecto-del-catalogo/).

## Registro simulado

`RegistroScreen` reutiliza `CampoAcceso` para nombre y apellidos, correo,
contraseña y repetición de contraseña. Los cuatro campos llevan etiquetas
visibles y datos fijos precargados; las dos contraseñas están ocultas. Cambiar
los textos no crea una cuenta ni modifica el usuario de demostración.

Crear cuenta de prueba abre una confirmación con `showDialog` y `AlertDialog`,
como en el apartado de [diálogos del curso](https://jovisal1.github.io/ApuntesPMDM/formularis-i-navegacio/navegacion/dialogos/).
El diálogo permite seguir en el registro o volver al login. `await` espera la
respuesta: el botón Volver al login devuelve `true` al cerrar el diálogo y
después se retira la pantalla de registro. `context.mounted` comprueba que la
pantalla siga existiendo antes de utilizar su contexto tras esa espera.

También se puede regresar con Volver al inicio de sesión, la flecha superior o
Atrás. Entrar en la aplicación se hace siempre desde el login. No hay validación,
base de datos ni guardado de campos; tampoco se añaden contraseñas a `Usuario`
ni a su DTO. Al abrir de nuevo el registro reaparecen los valores de demostración.

## Perfil y ajustes

`PerfilScreen`, en `lib/ui/perfil/ui/`, muestra el usuario ficticio compartido
con el login y el registro: «Usuario demo», `demo@bolava.es` e iniciales UD.
`Usuario`, en `domain/models/`, contiene solo información pública, y su instancia
fija está en `DatosDemo`. Escribir otros datos en el acceso o registro no modifica
ese usuario ni crea una cuenta.

`TarjetaUsuario` muestra la identidad con `CircleAvatar`. `SeccionPerfil` agrupa
las preferencias y la información del proyecto con el tema común. Las preferencias
son ejemplos fijos: tema claro, avisos desactivados y horario de tarde. Se identifican
como ejemplos y no se modifican ni guardan. La versión mostrada es `1.0.0`,
compilación `1`, igual que `pubspec.yaml`; si cambia la versión del proyecto,
hay que actualizar también ese texto fijo.

Espacios, Mis reservas y Perfil utilizan los mismos botones y
`Navigator.pushReplacement`: al elegir otra sección se sustituye la actual,
sin acumular copias. Los detalles de una pista siguen abriéndose con `push`
para poder regresar al catálogo. Cerrar sesión utiliza `pushAndRemoveUntil`
con una condición siempre falsa; elimina todas las rutas anteriores, incluso
si existía alguna debajo del perfil. Atrás deja de poder abrir esa sesión.

El perfil se organiza en dos columnas en escritorio y una en móvil o con texto
grande, usando `LayoutBuilder` y `MediaQuery`, dentro del desplazamiento de
`PaginaBase`. Referencias consultadas del curso:
[Card, ListTile y CircleAvatar](https://jovisal1.github.io/ApuntesPMDM/widgets/otros/tarjetas-y-elementos-material/)
y [operaciones de Navigator](https://jovisal1.github.io/ApuntesPMDM/formularis-i-navegacio/navegacion/entre-pantallas/).

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

## Preparar una publicación

La app actual es una demo: no guarda reservas ni datos de usuario. La PWA guarda
en caché los recursos estáticos para poder arrancar sin conexión, pero esa caché
no es una copia de datos ni sincroniza dispositivos.

Para generar los artefactos desde la raíz del proyecto:

```sh
flutter build apk --release
flutter build web --base-href /app/ --no-web-resources-cdn --no-wasm-dry-run
node tool/package_pwa.mjs
node publicacion/scripts/prepare-apk.mjs <apk> --version <x.y.z> --build-number <n> --min-android <versión> --application-id <id> --certificate-sha256 <hash> --architectures <lista>
node publicacion/scripts/build.mjs
```

La carpeta `publicacion/dist/` es la raíz del sitio estático. Para GitHub Pages
de este repositorio, compila con `--base-href /bola-va/app/` y ejecuta el
empaquetador con `BOLA_PWA_SCOPE=/bola-va/app/`; en un dominio raíz se usa
`/app/`. Los metadatos de `release.json` deben salir del APK verificado con
`apksigner` y `aapt`, no de valores estimados.

### Actualizar el enlace de GitHub Pages

El sitio se mantiene en https://eloymv.github.io/bola-va/ y la aplicación se abre
en https://eloymv.github.io/bola-va/app/.

Al subir a `main` cambios de `lib/`, `assets/`, `web/`, `pubspec`, el empaquetador
o los archivos de publicación, GitHub Actions compila de nuevo la web con Flutter
3.47.5 y publica el resultado. Ya no depende de actualizar a mano la copia
compilada de `publicacion/public/app/`. También se puede ejecutar **Publish Bola
Va → Run workflow** desde la pestaña Actions del repositorio. Hay que esperar a
que termine correctamente el trabajo `deploy` para dar la página por actualizada.

La descarga de Android sigue utilizando el APK preparado en `publicacion/public/apk/`;
publicar la web no recompila ni cambia la firma de Android.

La firma release y su contraseña viven en `.private/android/`, excluida de Git.
Conserva una copia privada y segura de toda esa carpeta: las versiones futuras
deben usar el mismo certificado y keystore para poder actualizar la instalación.
`node tool/setup_android_signing.mjs` solo genera una clave cuando no existe una;
se niega a sobrescribir una firma previa.
