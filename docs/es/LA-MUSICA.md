# La música

Cinco músicas, en los tres canales del PSG. No están grabadas a mano: `tools/musica.py` **ejecuta el propio
motor de sonido de la ROM** con `tools/z80run.py` -`musica_pide` (0xA007) con el número de la música y, en cada
cuadro, `sonido` (0xA020)- y apunta lo que escribe en el PSG por la BIOS (WRTPSG).

**Cotejadas con openMSX**: los registros de tono y de volumen coinciden con los grabados, **0 distintos** en las
cinco, mientras suena cada música. Se grabaron en partidas jugadas en openMSX (`tools/guiones/`): el principio de
una fase, una fase perdida, GAME OVER y, forzados, el final de una fase, su fase de premio y el final. Cada cuadro
grabado se empareja con el cuadro del motor que tiene la misma RAM en los tres canales. GAME OVER empieza cuando
aún suena la música de la fase perdida y deja parte de ella en los canales: el motor arranca con la RAM del
sonido como estaba.

Los sonidos del juego no están aquí: los pasos, el martillo, los bloques, los huevos y los demás.

## El motor

El motor no va en la interrupción sino en el bucle del juego, una vez por cuadro. La petición va a 0xE1BE, y en
el cuadro siguiente el motor empieza los tres canales de la música de la tabla 0xA440, tres piezas por música
(`musica_empieza`, 0xA324). Los canales están en 0xE180, 0xE192 y 0xE1A4, 18 bytes cada uno; en cada cuadro se
copian por turno a un bloque de trabajo en 0xE1C4, avanzan un paso y vuelven a su sitio. Una nota es un byte con
la duración (de la tabla 0xA2FD, de 128 cuadros a 1) y el volumen, y detrás el periodo del tono; desde 0xF0 son
órdenes: ruido, tres marcas de repetición con sus cuentas, vuelta al principio, silencio y el final. Hay dos
clases de efecto de sonido: los del canal A (0xA464, 0xE1C0) y los de los canales B y C (0xA46E, 0xE1C2); un
efecto nunca corta una música.

| | Quién la pide | Duración |
|---|---|---:|
| la fase | el principio de cada fase (0x83AD) | 3,5 s |
| la fase hecha | el final de una fase (0x84A4) y la cuenta del premio (0x8E93) | 4,3 s |
| la fase perdida | se acaba TIME, muere el protagonista o F2 (0x84A0, 0x8431) | 2,4 s |
| GAME OVER | sin vidas (0x857C) | 3,8 s |
| el final | tras la fase 50 (0x8F4C) | 4,3 s |

## La fase

<audio controls src="../audio/musica_fase.mp3"></audio>

## La fase hecha

<audio controls src="../audio/musica_fase_hecha.mp3"></audio>

## La fase perdida

<audio controls src="../audio/musica_fase_perdida.mp3"></audio>

## GAME OVER

<audio controls src="../audio/musica_game_over.mp3"></audio>

## El final

<audio controls src="../audio/musica_final.mp3"></audio>
