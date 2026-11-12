# Secretos y fallos

Lo que se ha buscado en el código y lo que se ha encontrado. Un fallo solo entra aquí si está comprobado:
ejecutando la propia rutina del juego (`tools/bios.py`) o contra las grabaciones de openMSX.

## Secretos

- **Las diez contraseñas.** KEYWORD lleva a la fase 1, 6, 11... hasta la 46 (`contrasena_busca`, 0x8268): están en
  [Los textos](LOS-TEXTOS.html). Las letras se escriben con el teclado y se leen del buffer de la BIOS (0xFBF0); las
  minúsculas valen igual. Las diez empiezan por letras distintas, y hace falta, porque la búsqueda solo sigue con la
  contraseña cuya primera letra coincide: si fallara otra letra, no miraría las demás.
- **F1 y F2**, que ningún texto del juego cuenta: F1 para el juego y lo sigue, F2 da la fase por perdida (`tecla_f1`,
  0x84BD, en la fila 6 de SNSMAT). Fuera de eso, el juego solo lee la palanca (los cursores y el mando 1), el botón 1
  del mando y la barra (0x9DA5-0x9DEC).
- **La contraseña del premio** no es la siguiente, sino la de las cinco fases recién jugadas: se cuenta en
  [Curiosidades](CURIOSIDADES.html).

## Fallo: tras la fase 9, STAGE 00 y una vida más

`fase_siguiente` (0x85B8) suma la decena en el byte de las vidas (0xE00B) en vez de en el de las decenas (0xE009).
Grabado en openMSX y contado en [Curiosidades](CURIOSIDADES.html): tras la fase 9 sale STAGE **00** y las vidas pasan
de cuatro a **cinco**; el mapa sí es el de la décima.

## Fallo: la diagonal arriba-izquierda no mueve

El protagonista toma la dirección de la palanca así: `and 7` y después `set 0` (0x885A-0x885E), para que cada
diagonal se quede en una dirección recta. Pero arriba-izquierda es el 8, y `8 and 7` es 0: sin dirección. Ejecutando
aquí la palanca y esa cuenta del juego:

| palanca | el protagonista va |
|---|---|
| arriba-derecha (2) | derecha |
| abajo-derecha (4) | abajo |
| abajo-izquierda (6) | izquierda |
| arriba-izquierda (8) | **se queda quieto** |

## Fallo: los cursores y el mando se suman

La interrupción (`interrupcion`) junta los cursores y el mando 1 con una **suma** (0x9DCD) de sus números de dirección. Con los dos a la vez,
ejecutándolo aquí:

| cursores | mando | el protagonista va |
|---|---|---|
| arriba | arriba | **derecha** |
| derecha | derecha | **izquierda** |
| derecha | abajo | **quieto** |

## Fallo: los puntos vuelven a cero

Los puntos son seis cifras en BCD (0xE00C), y `puntos` (0x86C6) pierde el acarreo del byte de arriba (0x86E9): no hay
tope. Ejecutándolo aquí, 999.950 + 50 da **000000** y 999.990 + 40 da **000030**. El juego no guarda récord.
