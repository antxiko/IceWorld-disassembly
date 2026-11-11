"""Las pantallas de Ice World.

  - el titulo: EJECUTANDO la ROM (tools/bios.py: el Z80 con la BIOS que usa) desde INIT (0x8010) hasta la espera
    del boton (0x8162). Las letras las copia el juego de la fuente de la BIOS (0x1D3F y 0x1CBF): aqui salen de la
    VRAM que grabo openMSX con C-BIOS. SETGRP es SCREEN 2;
  - logotipo.png, la cabecera de la web: CASIO e ICE WORLD del titulo;
  - pantallas de los cuadros que grabo openMSX: la fase 1 (work/atraccion.bin), la fase 6 (work/partida.bin) y
    el descanso (work/descanso.bin).

El titulo se coteja con la VRAM grabada (work/atraccion.bin, cuadro 170): la imagen sin sprites punto a punto,
la tabla de nombres y los registros.

Uso: pantallas.py <dir> [cotejo]
"""
import os
import sys

from PIL import Image

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, AQUI)
import vdp                  # noqa: E402
from bios import Msx, SCREEN2        # noqa: E402

RAIZ = os.path.dirname(AQUI)
COTEJO = ("atraccion", 170)
PANTALLAS = {"fase1.png": ("atraccion", 760), "fase6.png": ("partida", 760), "descanso.png": ("descanso", 1700)}


def cuadro(grab, n):
    for i, c in enumerate(vdp.cuadros(os.path.join(RAIZ, "work", grab + ".bin"))):
        if i == n:
            return c


class IceWorld(Msx):
    def _bios(self):
        if self.pc == 0x007E:                             # SETGRP: SCREEN 2
            self.vdp.regs[:] = SCREEN2
            self.pc = self._pop()
            return
        super()._bios()


def titulo():
    rom = open(os.path.join(RAIZ, "iceworld.rom"), "rb").read()
    m = IceWorld(rom, 0x8000)
    v = cuadro(*COTEJO)["vram"]
    m.mem[0x1D3F:0x1D3F + 0x180] = bytes(v[0:0x180])            # la fuente, desde el caracter 0x30
    m.mem[0x1CBF:0x1CBF + 0x80] = bytes(v[0x180:0x200])          # y desde el 0x20
    m.hasta(0x8010, 0x8162)
    return bytes(m.vdp.vram), bytes(m.vdp.regs)


def cotejo(v, regs):
    suya = cuadro(*COTEJO)
    nombres = [a - 0x1800 for a in range(0x1800, 0x1B00) if v[a] != suya["vram"][a]]
    t1, t2 = vdp.tela(v, regs, False), vdp.tela(suya["vram"], suya["regs"], False)
    puntos = [(x, y) for y in range(192) for x in range(256) if t1[y][x] != t2[y][x]]
    print("titulo contra %s/%d: puntos distintos %d de 49152; nombres distintos %d; registros %s"
          % (COTEJO[0], COTEJO[1], len(puntos), len(nombres),
             "iguales" if regs == bytes(suya["regs"]) else "%s / %s" % (regs.hex(), bytes(suya["regs"]).hex())))
    return len(puntos), len(nombres)


def main(argv):
    v, regs = titulo()
    vdp.imagen(v, regs, 2, con_sprites=False).save(os.path.join(argv[0], "titulo.png"))
    vdp.imagen(v, regs, 4, con_sprites=False).crop((96, 64, 960, 448)).save(os.path.join(argv[0], "logotipo.png"))
    for f, (g, n) in PANTALLAS.items():
        c = cuadro(g, n)
        vdp.imagen(c["vram"], c["regs"], 2).save(os.path.join(argv[0], f))
    if len(argv) > 1:
        cotejo(v, regs)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
