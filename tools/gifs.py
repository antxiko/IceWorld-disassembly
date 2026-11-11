#!/usr/bin/env python3
"""Los GIF de la web: tramos de las grabaciones de openMSX (tools/guiones/*.tcl, grabados con
tools/lanza_graba.ps1 en C-BIOS_MSX1_JP, -ram "0xE000 0x1000"), pintados con tools/vdp.py.

Los tramos salen de la RAM grabada: 0xE00A la fase, 0xE00B las vidas, 0xE1F3 la fase perdida, 0xE3C0 la clase
de fase (1 el descanso, 2 el final, 3 el titulo), 0xE3CA lo que queda por hacer y 0xE3C3 el martillo.

  atraccion  sin tocar nada: el titulo y la demostracion (la fase 1 con sus mandos grabados)
  partida    la contrasena VANIL, la fase 6 y una vida perdida
  gameover   la fase 1 y F2 cada 700 cuadros, hasta GAME OVER
  descanso   FORZADA: la fase 5 acabada a la fuerza (0xE3CA a 0), y el descanso
  final      FORZADA: la fase 50 acabada a la fuerza, su descanso y el final

Uso: gifs.py docs/imagenes
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vdp          # noqa: E402

# (fichero, grabacion, desde, hasta, cada)
TRAMOS = [
    ("titulo.gif", "atraccion", 165, 560, 2),          # el protagonista rompe la fila de hielo del titulo
    ("contrasena.gif", "partida", 300, 770, 2),         # KEYWORD: VANIL y la fase 6
    ("demostracion.gif", "atraccion", 745, 1420, 2),    # la demostracion: el martillo, los bloques y una vida
    ("vida.gif", "partida", 6380, 6700, 2),             # la fase 6: una vida perdida
    ("game_over.gif", "gameover", 4150, 4600, 2),       # F2 con la ultima vida: GAME OVER
    ("descanso.gif", "descanso", 1300, 1900, 2),        # tras la fase 5: KEYWORD y el campo de bloques
    ("final.gif", "final", 4880, 5430, 2),              # tras la fase 50: el final
]


def main(salida):
    raiz = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    for fichero, grab, desde, hasta, cada in TRAMOS:
        n, s = vdp.gif(os.path.join(raiz, "work", grab + ".bin"),
                       os.path.join(salida, fichero), desde, hasta, cada=cada, tope_ms=4000)
        print("%-20s %4d imagenes, %5.1f s, %8d bytes" % (
            fichero, n, s, os.path.getsize(os.path.join(salida, fichero))))


if __name__ == "__main__":
    main(sys.argv[1])
