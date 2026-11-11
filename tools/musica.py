#!/usr/bin/env python3
"""Las musicas de Ice World, EJECUTANDO su propio motor de sonido (ver motor_musica.py).

El motor va en el bucle del juego: `sonido` (0xA020) en cada cuadro. El juego pide una musica con `musica_pide`
(0xA007, A el numero: se queda en 0xE1BE) y el motor la empieza en el cuadro siguiente con los tres canales de
la tabla 0xA440 (6 bytes por musica). El motor llega al PSG por la BIOS (WRTPSG), que aqui se atrapa.

Uso:  musica.py registros N [cuadros] | mp3 N f.mp3 | todas docs/audio | cotejo
      (N es el numero de la musica en el juego)
"""
import hashlib
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import motor_musica  # noqa: E402

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# (numero, fichero, quien la pide)
MUSICAS = [
    (1, "musica_fase.mp3", "el principio de cada fase (0x83AD)"),
    (4, "musica_fase_hecha.mp3", "la fase superada (0x84A4) y la cuenta del descanso (0x8E93)"),
    (3, "musica_fase_perdida.mp3", "la fase perdida (0x84A0) o F2 (0x8431)"),
    (2, "musica_game_over.mp3", "GAME OVER (0x857C)"),
    (5, "musica_final.mp3", "el final, despues de la fase 50 (0x8F4C)"),
]

CFG = dict(rom="iceworld.rom", org=0x8000, sp=0xF000, frame=0xA020, pide=0xA007, ram0=((0xE000, 1),),
           ram=(0xE180, 0xE1D7), hz=60, max_s=300)
CANALES = (0xE180, 0xE192, 0xE1A4)        # A, B y C: 18 bytes cada uno, los dos primeros por donde va


def rom():
    return open(os.path.join(RAIZ, CFG["rom"]), "rb").read()


def ejecuta(numero, maximo=None):
    maximo = maximo or CFG["hz"] * CFG["max_s"]
    z = motor_musica.arranca(CFG, rom(), numero)
    a, b = CFG["ram"]
    cuadros, vistos = [], {}
    for k in range(maximo):
        cuadros.append(motor_musica.cuadro(z))
        h = hashlib.sha1(bytes(z.mem[a:b])).digest()
        if h in vistos:
            return cuadros, (None if vistos[h] == k else vistos[h])
        vistos[h] = k + 1
    return cuadros, None


def mp3(numero, ruta):
    hz = CFG["hz"]
    cuadros, vuelta = ejecuta(numero)
    todo, fundido = motor_musica.desarrolla(cuadros, vuelta, hz)
    motor_musica.a_mp3(motor_musica.sintetiza(todo, hz), ruta, fundido, hz)
    print("%-26s %d cuadros (%.1f s), vuelve al %s" % (os.path.basename(ruta), len(cuadros),
                                                      len(cuadros) / hz, vuelta))


def estados(numero, maximo, inicio=None, ram=None):
    """Cada cuadro del motor ejecutado: la RAM de los canales y los registros del PSG. `inicio`: el PSG como
    estaba antes (los registros que la musica no escribe siguen como los dejo lo anterior); `ram`: la RAM del
    sonido (0xE180-0xE1D6) como estaba antes, para la musica que empieza encima de otra (GAME OVER suena encima
    de la de la fase perdida y deja bytes de ella en los canales)."""
    cfg = dict(CFG)
    if ram is not None:
        cfg["ram0"] = CFG["ram0"] + tuple((0xE180 + i, v) for i, v in enumerate(ram))
        cfg["cuadros_previos"] = 0
    z = motor_musica.arranca(cfg, rom(), numero)
    a, b = CFG["ram"]
    regs = list(inicio) if inicio else [0] * 16
    out = [(bytes(z.mem[a:b]), tuple(regs))]
    for _ in range(maximo):
        for r, v in motor_musica.cuadro(z):
            if r < 16:
                regs[r] = v
        out.append((bytes(z.mem[a:b]), tuple(regs)))
    return out


def cotejo():
    """Los tonos y los volumenes del motor ejecutado contra los del PSG que grabo openMSX al entrar en cada
    cuadro del juego (work/partida.bin y las otras, con la RAM 0xE000-0xEFFF). La musica empieza en el
    cuadro en que 0xE1BD (la que suena) pasa a tener su numero, y se mira mientras lo tiene. Cada cuadro grabado
    se empareja con el cuadro del motor que tiene la MISMA RAM en los tres canales (0xE180, 54 bytes); se miran
    el volumen de cada canal (registros 8-10) y, si suena, su tono (0-5); el primer cuadro, antes de que corra
    el motor, no cuenta."""
    import vdp
    out = []
    for grab in ("partida", "gameover", "descanso", "final"):
        ruta = os.path.join(RAIZ, "work", grab + ".bin")
        if not os.path.exists(ruta):
            continue
        cs = list(vdp.cuadros(ruta, 0x1000))
        suena = lambda k: cs[k]["ram"][0x1BD]
        for n, (numero, fichero, _) in enumerate(MUSICAS):
            k0 = next((k for k in range(1, len(cs)) if suena(k) == numero and suena(k - 1) != numero), None)
            if k0 is None or any(o[0] == n for o in out):
                continue
            emu = estados(numero, 60 * 120, cs[k0 - 1]["psg"], bytes(cs[k0 - 1]["ram"][0x180:0x1D7]))
            trozo = lambda ram: bytes(ram[0:54])
            e, malos, mirados, sueltos = 0, [], 0, 0
            for j in range(k0, len(cs)):
                if suena(j) != numero:
                    break
                ram = cs[j]["ram"][0x180:0x1D7]
                hallado = next((x for x in range(e, min(e + 8, len(emu))) if trozo(emu[x][0]) == trozo(ram)), None)
                if hallado is None:
                    sueltos += 1
                    continue
                e = hallado
                if e == 0:
                    continue
                mirados += 1
                regs = emu[e][1]
                p = cs[j]["psg"]

                def distinto(c):
                    if p[8 + c] != regs[8 + c]:
                        return True
                    # callado (volumen 0), el tono no suena: lo que quede de antes no cuenta
                    return bool(p[8 + c] & 0x1F) and any(p[r] != regs[r] for r in (2 * c, 2 * c + 1))
                if any(distinto(c) for c in range(3)):
                    malos.append(j - k0)
            out.append((n, grab, k0, mirados, malos, sueltos))
    return out


def main(argv):
    if argv and argv[0] == "cotejo":
        for n, grab, k0, mirados, malos, sueltos in cotejo():
            print("%-26s %s, empieza en el cuadro %d: %d cuadros mirados, %d distintos %s; %d sin pareja"
                  % (MUSICAS[n][1], grab, k0, mirados, len(malos), malos[:8], sueltos))
        return 0
    if argv and argv[0] == "todas":
        os.makedirs(argv[1], exist_ok=True)
        for numero, fichero, _ in MUSICAS:
            mp3(numero, os.path.join(argv[1], fichero))
        return 0
    if argv and argv[0] == "mp3":
        mp3(int(argv[1]), argv[2])
        return 0
    if argv and argv[0] == "registros":
        cuadros, vuelta = ejecuta(int(argv[1]), int(argv[2]) if len(argv) > 2 else None)
        for i, escr in enumerate(cuadros):
            print("%5d %s" % (i, " ".join("%X=%02X" % rv for rv in escr)))
        print("cuadros: %d, vuelve al %s" % (len(cuadros), vuelta))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
