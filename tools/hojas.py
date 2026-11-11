#!/usr/bin/env python3
"""El protagonista, el martillo y los bichos de Ice World MONTADOS DESDE LA ROM (ninguna imagen es una captura).

Los dibujos de los sprites son los 0x800 bytes de 0xB800 que `sprites_dibujos` (0x876B) pone en 0x3800. Los bichos
y los huevos NO son sprites: son piezas de 2 x 2 casillas (`pieza`, 0x9C09: C y C + 1 arriba, C + 2 y C + 3 abajo)
de las casillas que `casillas_juego` (0x84C5) carga en cada tercio: 0x600 bytes de 0xA800 desde la casilla 0x40, los
tramos de 0xB34C desde la 0x78 y los colores en tramos de 0xB000.

  protagonista.png   tres sprites encima (`prota_sprites`, 0x8C82: el dibujo, + 4 y + 8, en blanco, gris y rojo,
                     0x8CC8) con la pareja de dibujos de cada direccion (0x8CBE) y el martillo (el sprite 0, en
                     color 9, `golpe_sprite` 0x9914) donde lo pone la tabla 0x99BD; el martillo pegando (la entrada
                     siguiente de la tabla, 0x98B2); los dos dibujos de cuando pierde (0x60 y 0x6C, 0x880D); el
                     martillo lanzado (0xB8, 0xBC, 0xC0 y 0xC4, `golpe_sale` 0x99F1) y los puntos (0xCC, 0xD0 o 0xD4
                     con 0xC8 a la derecha, `numero_sale` 0x9F69)
  andar_cuadros.gif  andando hacia cada lado: el primero de la pareja del paso 1 al 3 y el segundo del 4 al 7, un paso
                     por cuadro (`prota_dibujo`, 0x8C62); y perdiendo, los dos dibujos cada 4 cuadros
  bichos.png         los dos bichos (+3 = 0xB0 o 0xD8, uno si y otro no, `cosas_pon` 0x9CA3) andando hacia cada lado
                     con sus dos dibujos (`iy_pieza` 0xB4AD: (direccion - 1) x 4 + 0xB0 o 0xD8 + 0 o 4), golpeados o
                     aplastados (+ 0x20, `enemigo_dibujo` 0x92DC); el huevo (0x48, 0x4C y 0x50, 0x93B8), abriendose
                     (+ 0x10) y roto (0x58, 0x5C y 0x60, `enemigo_rompe` 0x92F2)
  bichos_cuadros.gif los bichos andando hacia cada lado y aplastados: cambian de dibujo cada vez que se mueven, cada
                     24 cuadros (`enemigos`, 0x9227)

Uso: hojas.py docs/imagenes | hojas.py cotejo
"""
import os
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))
import vdp          # noqa: E402

ORG = 0x8000
ROM = open(os.path.join(RAIZ, "iceworld.rom"), "rb").read()
FONDO = (0, 0, 0)               # el color 0 de las casillas deja ver el fondo, negro (registro 7 = 0xF0)
DIRECCIONES = [(1, "arriba"), (3, "derecha"), (5, "abajo"), (7, "izquierda")]
BICHOS = (0xB0, 0xD8)


def b(a):
    return ROM[a - ORG]


def patrones():
    return ROM[0xB800 - ORG:0xB800 - ORG + 0x800]


def tramos(buf, dest, a):
    """`tramos` (0x8755): cuantos y el byte, hasta 0xFF."""
    while b(a) != 0xFF:
        n, v = b(a), b(a + 1)
        buf[dest:dest + n] = bytes([v]) * n
        dest += n
        a += 2


def casillas():
    """Los dibujos y los colores de las casillas 0x40-0xFF de un tercio, como los carga casillas_juego (0x84C5)."""
    pat, col = bytearray(0x800), bytearray(0x800)
    pat[0x200:0x800] = ROM[0xA800 - ORG:0xA800 - ORG + 0x600]
    tramos(pat, 0x3C0, 0xB34C)
    tramos(col, 0x200, 0xB000)
    return bytes(pat), bytes(col)


def pinta(im, pat, n, x, y, color, escala=1):
    if color == 0:
        return
    n &= 0xFC
    d = pat[n * 8:n * 8 + 32]
    c = vdp.PALETA[color]
    for fila in range(16):
        for col in range(16):
            if (d[fila + (16 if col >= 8 else 0)] >> (7 - (col & 7))) & 1:
                for ey in range(escala):
                    for ex in range(escala):
                        px, py = (x + col) * escala + ex, (y + fila) * escala + ey
                        if 0 <= px < im.width and 0 <= py < im.height:
                            im.putpixel((px, py), c)


def casilla(im, cas, n, x, y, escala):
    pat, col = cas
    for fila in range(8):
        p, c = pat[n * 8 + fila], col[n * 8 + fila]
        for k in range(8):
            color = (c >> 4) if (p >> (7 - k)) & 1 else (c & 15)
            if color == 0:
                continue
            for ey in range(escala):
                for ex in range(escala):
                    im.putpixel(((x + k) * escala + ex, (y + fila) * escala + ey), vdp.PALETA[color])


def pieza(c):
    """Las cuatro casillas de `pieza` (0x9C09): C, C + 1 / C + 2, C + 3 (arriba izquierda, arriba derecha, abajo
    izquierda, abajo derecha); las esquinas de 0x9BED (arriba izq., arriba der., abajo der., abajo izq.), el espacio."""
    e = [b(0x9BED + k) for k in range(4)]
    return [0x10 if c + k == e[(0, 1, 3, 2)[k]] else c + k for k in range(4)]


def dibuja_pieza(im, cas, c, x, y, escala):
    for k, n in enumerate(pieza(c)):
        casilla(im, cas, n, x + 8 * (k & 1), y + 8 * (k >> 1), escala)


COLORES = [b(0x8CC8 + k) for k in range(3)]          # 15, 14, 8
COLOR_GOLPE = 9                                      # golpe_sprite, 0x9914


def dibujo(direccion, paso):
    """prota_dibujo: la pareja de la direccion (0x8CBE + direccion - 1); el segundo con el bit 2 del paso."""
    return b(0x8CBE + direccion - 1 + (1 if paso & 4 else 0))


def protagonista(d):
    """Los tres sprites (dibujo, color) del dibujo d."""
    return [((d + 4 * k) & 0xFF, COLORES[k]) for k in range(3)]


def golpe(direccion, pegando=False):
    """(dy, dx, dibujo) del martillo junto al protagonista: 0x99BD + (direccion - 1) x 4, + 4 pegando."""
    a = 0x99BD + (direccion - 1) * 4 + (4 if pegando else 0)
    return tuple(b(a + k) for k in range(3))


def s8(v):
    return v - 256 if v > 127 else v


def capa(im, pat, d, x, y, E, martillo=None):
    for n, c in reversed(protagonista(d)):
        pinta(im, pat, n, x, y, c, E)
    if martillo:
        dy, dx, n = martillo
        pinta(im, pat, n, x + s8(dx), y + s8(dy), COLOR_GOLPE, E)


def bicho(base, direccion, otro):
    """iy_pieza (0xB4AD): (direccion - 1) x 4 + el dibujo (+3) + el bit 2 de +0x0D."""
    return (direccion - 1) * 4 + base + (4 if otro else 0)


def hoja(Image):
    pat, E = patrones(), 4
    im = Image.new("RGB", (9 * 24 * E, 3 * 28 * E), FONDO)
    for k, (direccion, _) in enumerate(DIRECCIONES):
        for j, paso in enumerate((0, 4)):
            capa(im, pat, dibujo(direccion, paso), 6 + 24 * (2 * k + j), 6, E, golpe(direccion))
        capa(im, pat, dibujo(direccion, 0), 6 + 24 * k, 34, E, golpe(direccion, True))
    for k, d in enumerate((0x60, 0x6C)):
        capa(im, pat, d, 6 + 24 * (4 + k), 34, E)
    for k in range(4):
        pinta(im, pat, 0xB8 + 4 * k, 6 + 24 * k, 62, COLOR_GOLPE, E)
    for k, n in enumerate((0xD4, 0xCC, 0xD0)):          # 100, 1000 y 500
        x = 4 * 24 + 8 + 32 * k
        pinta(im, pat, n, x, 62, 15, E)
        pinta(im, pat, 0xC8, x + 16, 62, 15, E)
    return im


def hoja_bichos(Image):
    cas, E = casillas(), 4
    im = Image.new("RGB", (10 * 20 * E, 3 * 20 * E), FONDO)
    for fila, base in enumerate(BICHOS):
        k = 0
        for direccion, _ in DIRECCIONES:
            for otro in (0, 1):
                dibuja_pieza(im, cas, bicho(base, direccion, otro), 2 + 20 * k, 2 + 20 * fila, E)
                k += 1
        for otro in (0, 1):
            dibuja_pieza(im, cas, base + 0x20 + 4 * otro, 2 + 20 * k, 2 + 20 * fila, E)
            k += 1
    huevo = [b(0x93B8 + k) for k in range(3)]
    for k, c in enumerate(huevo + [0xB0 + 0x10, 0xD8 + 0x10, 0x58, 0x5C, 0x60]):
        dibuja_pieza(im, cas, c, 2 + 20 * k, 42, E)
    return im


def anima(Image):
    pat, E, cuadros = patrones(), 4, []
    for direccion, _ in DIRECCIONES:
        for paso in range(16):
            im = Image.new("RGB", (24 * E, 24 * E), FONDO)
            capa(im, pat, dibujo(direccion, (paso % 8) or 8), 6, 6, E, golpe(direccion))
            cuadros.append(im)
    for n in range(32):
        im = Image.new("RGB", (24 * E, 24 * E), FONDO)
        capa(im, pat, 0x6C if n & 4 else 0x60, 6, 6, E)
        cuadros.append(im)
    return cuadros


def anima_bichos(Image):
    """Cada 24 cuadros el bicho se mueve y cambia de dibujo (el bit 2 de +0x0D); aplastado, 8 veces su dibujo + 0x20
    y despues 0x58, 0x5C y 0x60."""
    cas, E, cuadros = casillas(), 4, []
    for direccion, _ in DIRECCIONES:
        for n in range(4):
            im = Image.new("RGB", (2 * 20 * E, 20 * E), FONDO)
            for k, base in enumerate(BICHOS):
                dibuja_pieza(im, cas, bicho(base, direccion, n & 1), 2 + 20 * k, 2, E)
            cuadros += [im] * 24
    for n in range(11):
        im = Image.new("RGB", (2 * 20 * E, 20 * E), FONDO)
        for k, base in enumerate(BICHOS):
            c = base + 0x20 + 4 * (n & 1) if n < 8 else (0x58, 0x5C, 0x60)[n - 8]
            dibuja_pieza(im, cas, c, 2 + 20 * k, 2, E)
        cuadros += [im] * 24
    return cuadros


def guarda_gif(cuadros, ruta, ms=1000 / 60):
    imgs, durs = [], []
    for im in cuadros:
        if imgs and list(im.getdata()) == list(imgs[-1].getdata()):
            durs[-1] += ms
        else:
            imgs.append(im)
            durs.append(ms)
    imgs[0].save(ruta, save_all=True, append_images=imgs[1:], duration=[max(20, int(round(d))) for d in durs],
                 loop=0, disposal=1)


def cotejo():
    """Contra las grabaciones de openMSX (work/*.bin, la RAM 0xE000-0xEFFF):
    1) la tabla de dibujos de los sprites (VRAM 0x3800-0x3FFF) contra los 0x800 bytes de 0xB800;
    2) las casillas 0x40-0xFF de los tres tercios (dibujos y colores) contra `casillas()`; los colores de 0x68-0x6B
       y 0x70-0x73 los cambia `agua` (0x8C19) cada 4 cuadros y no cuentan;
    3) los tres sprites del protagonista en la copia de la tabla (0xE104-0xE10F): el dibujo, + 4 y + 8 con los
       colores de 0x8CC8, y el dibujo el que toca a la direccion (0xE203) y al paso (0xE202);
    4) el martillo suelto (0xE3C3 = 1): el sprite 0 (0xE100) donde lo pone la tabla 0x99BD;
    5) cada bicho andando (0xE210, 16 bytes; el estado +4 = 1): las cuatro casillas de su sitio (+0, +1) en la tabla
       de nombres, contra `pieza(bicho(...))` con su dibujo (+3), su direccion (+2) y el bit 2 de +0x0D."""
    pat = patrones()
    cas = casillas()
    validos = {b(0x8CBE + k) for k in range(8)} | {0x60, 0x6C}
    agua = set(range(0x68 * 8, 0x6C * 8)) | set(range(0x70 * 8, 0x74 * 8))
    tot = dict(patrones=0, pat_mal=0, cargando=0, casillas=0, cas_titulo=0, cas_carga=0, cas_mal=0, sin_poner=0, prota=0, prota_mal=0,
               prota_dir=0, prota_giro=0, prota_dir_mal=0, golpe=0, golpe_empieza=0, golpe_giro=0, golpe_vuelve=0, golpe_mal=0, bichos=0,
               bichos_otra=0, bichos_huevo=0, bichos_0f=0, bichos_borrados=0, bichos_mal=0)

    def posibles(r):
        d, p = r[0x203], r[0x202]
        if d not in (1, 3, 5, 7):
            return set()
        if 1 <= p <= 7:
            return {dibujo(d, p)}                   # el paso ya sumado (inc antes del bit 2)
        return {dibujo(d, 0), dibujo(d, 4)}         # 0 u 8: el dibujo no cambia ese cuadro

    def martillo(r):
        """Junto a los sprites del protagonista (0xE104): la copia de la tabla va un cuadro por detras de 0xE200."""
        dy, dx, n = golpe(r[0x203])
        return [(r[0x104] + dy) & 0xFF, (r[0x105] + dx) & 0xFF, n, COLOR_GOLPE]

    for grab in ("atraccion", "partida", "descanso", "fase9", "final", "gameover"):
        ruta = os.path.join(RAIZ, "work", grab + ".bin")
        if not os.path.exists(ruta):
            continue
        antes = None
        estados = []
        for c in vdp.cuadros(ruta):
            v, ram = c["vram"], c["ram"]
            t = v[0x3800:0x4000]
            if any(t):
                n = len(t.rstrip(bytes(1)))
                if t != pat and t[:n] == pat[:n]:
                    tot["cargando"] += 1            # la copia a medias (el cuadro en que se carga)
                else:
                    tot["patrones"] += t == pat
                    tot["pat_mal"] += t != pat
            if v[0x0200:0x0800] == cas[0][0x200:0x800]:          # con las casillas del juego
                ok, distintos = True, set()
                for tercio in range(3):
                    ok &= v[0x800 * tercio + 0x200:0x800 * tercio + 0x800] == cas[0][0x200:0x800]
                    col = v[0x2000 + 0x800 * tercio:0x2800 + 0x800 * tercio]
                    distintos |= {col[k] for k in range(0x200, 0x800) if k not in agua and col[k] != cas[1][k]}
                if ok and not distintos:
                    tot["casillas"] += 1
                    estados.append("ok")
                elif ok and distintos == {0xF0}:
                    tot["cas_titulo"] += 1          # aun los colores del titulo (todo 0xF0, `init` 0x806F)
                    estados.append("titulo")
                else:
                    estados.append("mal")
            else:
                estados.append("otra")
            spr = ram[0x104:0x110]
            if spr[0] < 0xC0 and spr[2] in validos:
                hay = [(spr[4 * k + 2], spr[4 * k + 3] & 15) for k in range(3)]
                if hay == [(0, 0)] * 3:
                    tot["sin_poner"] += 1           # los tres sprites aun borrados
                else:
                    tot["prota"] += 1
                    tot["prota_mal"] += hay != protagonista(spr[2])
                    if spr[2] not in (0x60, 0x6C) and posibles(ram):
                        tot["prota_dir"] += 1
                        if spr[2] not in posibles(ram):
                            if antes is not None and spr[2] in posibles(antes) | {dibujo(antes[0x203], 0),
                                                                                  dibujo(antes[0x203], 4)}:
                                tot["prota_giro"] += 1      # el dibujo del cuadro anterior (acaba de girar)
                            else:
                                tot["prota_dir_mal"] += 1
            if ram[0x3C3] == 1 and ram[0x203] in (1, 3, 5, 7):
                hay = [ram[0x100], ram[0x101], ram[0x102], ram[0x103] & 15]
                if hay == martillo(ram):
                    tot["golpe"] += 1
                elif hay[:2] == [ram[0x104], ram[0x105]] or hay == [0, 0, 0, 0]:
                    tot["golpe_empieza"] += 1       # al empezar la fase: aun en el sitio del protagonista (0x84F4)
                elif antes is not None and antes[0x203] in (1, 3, 5, 7) and hay[:3] == martillo(antes)[:3]:
                    tot["golpe_giro"] += 1          # con la direccion del cuadro anterior (acaba de girar)
                elif antes is not None and hay[3] == COLOR_GOLPE and any(
                        hay[:2] == [(r[y] + s8(dy)) & 0xFF, (r[y + 1] + s8(dx)) & 0xFF]
                        for r in (ram, antes) for y in (0x104, 0x200) for d in {ram[0x203], antes[0x203]} & {1, 3, 5, 7}
                        for peg in (False, True) for dy, dx, _ in [golpe(d, peg)]):
                    tot["golpe_vuelve"] += 1        # al dejar de pegar o girar: el sitio de un cuadro y el dibujo de otro
                else:
                    tot["golpe_mal"] += 1
            for k in range(15):
                e = ram[0x210 + 16 * k:0x220 + 16 * k]
                if e[4] != 1 or e[3] not in BICHOS or e[2] not in (1, 3, 5, 7):
                    continue
                sitio = e[0] | e[1] << 8
                if not 0x1800 <= sitio < 0x1AE0:
                    continue
                hay = [v[sitio], v[sitio + 1], v[sitio + 32], v[sitio + 33]]
                tot["bichos"] += 1
                if hay == pieza(bicho(e[3], e[2], e[0x0D] & 4)):
                    continue
                if any(hay == pieza(bicho(e[3], d, o)) for d in (1, 3, 5, 7) for o in (0, 1)):
                    tot["bichos_otra"] += 1         # otra direccion: la nueva apuntada, aun sin pintar
                elif hay == pieza(b(0x93BA)):
                    tot["bichos_huevo"] += 1        # recien salido (huevo_sale): aun el huevo 0x50 hasta que anda
                elif 0x0F in hay:
                    tot["bichos_0f"] += 1           # la 0x0F que deja el martillo en su pieza
                elif hay == [0x10] * 4:
                    tot["bichos_borrados"] += 1     # la pantalla ya borrada
                else:
                    tot["bichos_mal"] += 1
            antes = ram
        for i, e in enumerate(estados):             # las casillas o sus colores a medio cargar, entre pantallas
            if e == "mal":
                cerca = estados[max(0, i - 20):i + 21]
                if "titulo" in cerca or "otra" in cerca:
                    tot["cas_carga"] += 1
                else:
                    tot["cas_mal"] += 1
    return tot


def main(argv):
    if argv and argv[0] == "cotejo":
        print(cotejo())
        return 0
    from PIL import Image
    salida = argv[0]
    os.makedirs(salida, exist_ok=True)
    hoja(Image).save(os.path.join(salida, "protagonista.png"))
    hoja_bichos(Image).save(os.path.join(salida, "bichos.png"))
    guarda_gif(anima(Image), os.path.join(salida, "andar_cuadros.gif"))
    guarda_gif(anima_bichos(Image), os.path.join(salida, "bichos_cuadros.gif"))
    for f in ("protagonista.png", "bichos.png", "andar_cuadros.gif", "bichos_cuadros.gif"):
        print(f, os.path.getsize(os.path.join(salida, f)))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
