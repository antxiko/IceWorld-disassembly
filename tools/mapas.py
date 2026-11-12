"""Los mapas de las fases de Ice World, PINTADOS EJECUTANDO LA ROM: fase_pantalla (0x8D97: el marco y el marcador) y
laberinto (0x9ADB), como hace fase (0x83A8-0x83B0), con la fase jugada en 0xE007 (la tabla de 0xA960 da un mapa a cada una), sobre la RAM y
la VRAM de un cuadro de juego grabado (work/partida.bin: las casillas y sus colores). Sin sprites (el protagonista y
los bichos). En una hoja, diez por fila, a la mitad de tamano.

Cotejo: en las grabaciones (atraccion, partida, fase9, descanso, final), la tabla de nombres de la zona de juego
(filas 2-23) de los cuadros 40 a 100 de cada fase jugada (la espera de 224 cuadros del principio, con el laberinto ya
pintado y quieto) contra la montada aqui: el mejor de ellos.

Uso: mapas.py docs/imagenes
"""
import os
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, AQUI)
import vdp                  # noqa: E402
from bios import Msx        # noqa: E402
from PIL import Image       # noqa: E402

RAIZ = os.path.dirname(AQUI)
ROM = open(os.path.join(RAIZ, "iceworld.rom"), "rb").read()
FASES = 52
NOMBRES = 0x0000            # el juego va en SCREEN 1 (R2 = 0): la tabla de nombres en 0x0000


def monta(c, fase):
    m = Msx(ROM, 0x8000)
    m.mem[0xE000:0xF000] = c["ram"]
    m.vdp.vram[:] = c["vram"]
    m.mem[0xE007] = fase
    m.llama(0x8D97)                     # fase_pantalla: el marco y el marcador
    m.llama(0x9ADB)                     # laberinto: las paredes y las cosas de la fase, como en fase (0x83A8-0x83B0)
    return bytes(m.vdp.vram)


def main(salida):
    base = None
    grabadas = {}
    for g in ("partida", "atraccion", "fase9", "descanso", "final"):
        for c in vdp.cuadros(os.path.join(RAIZ, "work", g + ".bin")):
            r = c["ram"]
            if not (c["regs"][1] & 0x40):
                continue
            if g == "partida" and base is None and r[0x000] and r[0x007] < FASES:
                base = c
            l = grabadas.setdefault(r[0x007], [])     # del cuadro 40 al 100 de cada fase: la espera de 224
            l.append(c["vram"][NOMBRES + 0x40:NOMBRES + 0x300])   # cuadros, con el laberinto ya pintado y quieto
    hoja = Image.new("RGB", (10 * 264 - 8, 6 * 200 - 8), (0, 0, 0))
    notas = []
    for f in range(FASES):
        v = monta(base, f)
        if f in grabadas:
            d = min(sum(1 for a, b in zip(v[NOMBRES + 0x40:NOMBRES + 0x300], x) if a != b) for x in grabadas[f][40:100])
            notas.append("%d:%d" % (f, d))
        hoja.paste(vdp.imagen(v, base["regs"], 1, con_sprites=False), ((f % 10) * 264, (f // 10) * 200))
    print("cotejo (fase jugada: casillas distintas en el mejor cuadro, de 704):", " ".join(notas))
    hoja = hoja.resize((hoja.size[0] // 2, hoja.size[1] // 2), Image.NEAREST)
    ruta = os.path.join(salida, "mapas.png")
    hoja.save(ruta, optimize=True)
    print(ruta, hoja.size)


if __name__ == "__main__":
    main(sys.argv[1])
