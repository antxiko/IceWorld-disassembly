# Por dentro

## Rehacer la ROM

`make verify` ensambla `src/iceworld.asm` con pasmo y sale la ROM de 16 KB **byte a byte**. `make sanity`
comprueba lo que el reensamblado no cubre: que ningún byte declarado como dato se lea como código, que ningún
punto de entrada caiga en datos y que los 16.384 bytes estén explicados. `make test` pasa las pruebas. La ROM no
está en el repositorio: hay que ponerla en la raíz como `iceworld.rom` (el volcado de GoodMSX, `[!]`, sha1
`167b226b...`).

| | bytes |
|---|---|
| código trazado | 8.645 |
| datos con nombre | 7.739 |
| sin explicar | 0 |

El listado tiene 1.676 comentarios en 4.013 instrucciones (41,8 %), 571 rutinas y etiquetas, ninguna por debajo
del 10 % comentado, y ninguna rutina llamada sin nombre.

## El cartucho

16 KB en la **página 2** (0x8000-0xBFFF), con INIT en 0x8010. Casi la mitad son datos: los mapas de las 52 fases
en seis sitios, los dibujos de las casillas y sus colores (en tramos de cuántos y color), los sprites, las letras
grandes del título, las diez contraseñas, los mandos de las dos demostraciones y la música.

## La BIOS que usa

SETGRP, CHGCLR, DISSCR, ENASCR y WRTVDP para poner la pantalla; FILVRM, LDIRVM, WRTVRM y RDVRM para llenarla y
leerla (con RDVRM sabe el juego qué hay alrededor del protagonista, del martillo y de los bichos); GTSTCK, GTTRIG
y SNSMAT para los mandos, y WRTPSG para el sonido. Lee la fuente de la BIOS en sus direcciones fijas (0x1D3F y
0x1CBF), y el buffer del teclado (0xFBF0) para la KEYWORD.

## La interrupción y el bucle

INIT pone un salto a 0x9D95 en el gancho H.TIMI (0xFD9F). La interrupción solo avanza dieciséis cuentas de
cuadros (0xE010-0xE01F) y lee los mandos; en las demostraciones los toma de la lista guardada (`interrupcion`,
0x9D95). Todo lo demás va en el bucle de la fase, un paso por cuadro contado (`paso`, 0x83F5): el protagonista,
los bloques que se rompen, el martillo, los bichos cada 24 cuadros, TIME y el motor de sonido.

## Cómo se ha hecho

El trazado sigue el código desde INIT y la interrupción, más los destinos de las tablas de saltos de detrás de
las llamadas, declarados en `src/iceworld.entries` y `src/iceworld.nocode`. Lo demás se ha **medido en openMSX**
(`tools/omsx_cobertura.tcl`: una condición en cada instrucción apunta cada dirección nueva de la ROM), jugando y
esperando la demostración en un Philips VG 8020: nada de lo que corrió quedó fuera del trazado.

## La RAM

| | |
|---|---|
| 0xE000 | la partida en marcha (0 en la demostración) |
| 0xE001-0xE006, 0xE00C-0xE00E | los puntos: seis cifras y en BCD |
| 0xE007 | la fase - 1, en binario: la que elige el mapa |
| 0xE009 / 0xE00A | la fase: decenas y unidades |
| 0xE00B | las vidas |
| 0xE010-0xE01F | dieciséis cuentas de cuadros |
| 0xE040-0xE046 | los botones |
| 0xE080-0xE087 | TIME, cifra a cifra, y su copia para la pantalla |
| 0xE100 | la tabla de sprites, que va a 0x1B00 |
| 0xE180-0xE1C3 | el motor de sonido |
| 0xE1F0-0xE1FF | la KEYWORD que se escribe y la palanca |
| 0xE200 | el protagonista |
| 0xE210-0xE2FF | los quince huevos y bichos (16 bytes cada uno) |
| 0xE300 | los tres bloques que se rompen |
| 0xE3C0 | la clase de fase: 0 normal, 1 premio, 2 el final, 3 el título |
| 0xE3C1-0xE3C9 | el martillo |
| 0xE3CA | lo que queda por hacer en la fase |
| 0xE3D3 | los cuatro números de puntos de la pantalla |
