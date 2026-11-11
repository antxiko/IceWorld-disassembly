# Curiosidades

## Tras la fase 9, la fase 00

Al acabar una fase, `fase_siguiente` (0x85B8) suma uno a las unidades de la fase (0xE00A); cuando pasan de 9 las
pone a 0 y suma uno al **byte de detrás**, 0xE00B. Pero las decenas están en el byte **de delante**, 0xE009, y
0xE00B guarda las vidas. Grabado en openMSX (forzado: la fase 9 elegida con VANIL y acabada enseguida): tras la
fase 9, STAGE pone **00** y las vidas pasan de cuatro a **cinco**. El mapa sí es el bueno, el de la décima: lo
elige otra cuenta (0xE007).

## La contraseña del premio

La fase de premio enseña una KEYWORD. No es la siguiente: tras las fases 1-5 enseña CASIO, la de la fase 1; tras
las 6-10, VANIL, la de la fase 6 (`descanso_clave`, 0x90F8).

## Mapas entre los dibujos

Los dibujos de las casillas de 0xA800 se cargan en la VRAM de una vez, 0x600 bytes, y en medio están la tabla de
los mapas y los mapas de las fases 1 a 11 (0xA960-0xAB7E); después se escriben otras casillas encima. Los dibujos
de los sprites (0xB800, 0x800 bytes) llevan dentro una rutina (0xBBC0) y los mapas de las fases 29 a 41.

## Datos detrás de las llamadas

Tres rutinas toman una tabla de saltos de justo detrás del `call` que llega a ellas (0x9F53, 0x9F59 y 0x91A5), y
otra (0x9782) una lista de parejas, casilla y clase, diez bytes detrás de cada una de las ocho llamadas de
0x9702-0x9772. Ninguna vuelve a la instrucción de después de la llamada.

## Código al que no se llega

- 0x8862: `ld a,(0E203h)`, la dirección de antes. Los dos saltos de justo antes caen en la instrucción
  siguiente.
- 0x8C5F: `call 0B49Ah`, con los mismos dos saltos por encima.
- 0x90F2: seis bytes, `ld b,a / ld c,0 / jp LDIRVM`, detrás de los textos del final.
- 0xB4E7: `pop hl / ret`, entre una rutina y los mapas.
