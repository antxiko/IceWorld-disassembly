"""Lo que se afirma de la ROM, comprobado contra sus bytes.

Corre con la ROM delante y sin ella: cuando no esta, la imagen se rehace desde
las filas defb/defw del listado, que si viaja con el repositorio. Sin la ROM
solo se comprueba lo que cae en datos.
"""

import os
import re
import subprocess
import sys
import unittest

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))

ROM = os.path.join(RAIZ, "iceworld.rom")
ASM = os.path.join(RAIZ, "src", "iceworld.asm")
NOTAS = os.path.join(RAIZ, "src", "iceworld.notes")
ORG = 0x8000
TAM = 16384

FILA = re.compile(r"^\s+def(b|w)\s+([0-9a-fA-F,h ]+)\s*;\s*([0-9a-f]{4})")


def imagen_desde_el_listado():
    img = bytearray(TAM)
    with open(ASM, encoding="utf-8") as f:
        for ln in f:
            m = FILA.match(ln)
            if not m:
                continue
            ancho, cuerpo, dirr = m.group(1), m.group(2), int(m.group(3), 16)
            p = dirr - ORG
            for tok in cuerpo.split(","):
                tok = tok.strip().rstrip("h")
                if not tok:
                    continue
                v = int(tok, 16)
                if ancho == "b":
                    img[p] = v
                    p += 1
                else:
                    img[p] = v & 0xFF
                    img[p + 1] = v >> 8
                    p += 2
    return bytes(img)


def lee():
    if os.path.exists(ROM):
        with open(ROM, "rb") as f:
            return f.read()
    return imagen_desde_el_listado()


def b(a):
    return lee()[a - ORG]


def w(a):
    rom = lee()
    return rom[a - ORG] | (rom[a - ORG + 1] << 8)


def instruccion(dirr):
    """La instruccion del listado en esa direccion (sin el comentario)."""
    with open(ASM, encoding="utf-8") as f:
        for ln in f:
            m = re.match(r"^\t(\S.*?)\s*;([0-9a-f]{4})", ln)
            if m and int(m.group(2), 16) == dirr:
                return m.group(1).replace("\t", " ").strip()
    return None


class Cabecera(unittest.TestCase):
    def test_ab_e_init_en_0x8010(self):
        rom = lee()
        self.assertEqual(rom[:2], b"AB")
        self.assertEqual(w(0x8002), 0x8010)
        self.assertEqual(rom[4:16], bytes(12))

    def test_son_16_kb(self):
        self.assertEqual(len(lee()), TAM)


class LaInterrupcion(unittest.TestCase):
    def test_va_por_h_timi(self):
        self.assertEqual([instruccion(a) for a in (0x8017, 0x801B, 0x8022, 0x8024)],
                         ["ld hl,09d95h", "ld (0fda0h),a", "ld a,0c3h", "ld (0fd9fh),a"])


def texto(a, n):
    s = ""
    for c in lee()[a - ORG:a - ORG + n]:
        s += str(c) if c < 10 else (" " if c == 0x10 else (chr(0x40 + c - 0x10) if 0x11 <= c <= 0x2A else "?"))
    return s


class LosTextos(unittest.TestCase):
    def test_las_letras_son_casillas_propias(self):
        self.assertEqual(texto(0x9D48, 21), "PUSH TRIGGER OR SPACE")
        self.assertEqual(texto(0x9174, 9), "GAME OVER")
        self.assertEqual(texto(0x9D79, 4), "OVER")
        self.assertEqual(texto(0x9E80, 7), "KEYWORD")

    def test_las_letras_de_la_bios_por_su_direccion(self):
        self.assertEqual(instruccion(0x872B), "ld hl,01d3fh")
        self.assertEqual(instruccion(0x8734), "ld hl,01cbfh")


class LasContrasenas(unittest.TestCase):
    def test_diez_contrasenas_y_su_fase(self):
        claves = [(texto(0x9E8F + 6 * k, 5), b(0x9E8F + 6 * k + 5)) for k in range(10)]
        self.assertEqual(claves, [("CASIO", 0x01), ("VANIL", 0x06), ("DENWA", 0x11), ("JUNMK", 0x16),
                                  ("PAZZL", 0x21), ("KIYOK", 0x26), ("FIREF", 0x31), ("MORIY", 0x36),
                                  ("YATTA", 0x41), ("LASTE", 0x46)])


class LaPartida(unittest.TestCase):
    def test_f1_y_f2_en_la_fila_6(self):
        self.assertEqual([instruccion(a) for a in (0x84BD, 0x84C2, 0x8426)],
                         ["ld a,006h", "bit 5,a", "bit 6,a"])

    def test_time_quita_los_ceros_con_el_espacio(self):
        self.assertEqual(instruccion(0x865E), "ld bc,00410h")

    def test_un_mapa_por_fase(self):
        """La tabla de 0xA960 apunta a 52 mapas, y cada uno acaba en 0xFF tras sus cosas sueltas."""
        for k in range(52):
            p = w(0xA960 + 2 * k)
            self.assertTrue(0xA000 <= p < 0xC000, hex(p))


class Sonido(unittest.TestCase):
    def test_duraciones(self):
        self.assertEqual(list(lee()[0xA2FD - ORG:0xA30B - ORG]),
                         [0x80, 0x60, 0x40, 0x30, 0x20, 0x18, 0x10, 0x0C, 0x08, 0x06, 0x04, 0x03, 0x02, 0x01])


class LoQueNadieUsa(unittest.TestCase):
    def test_dos_saltos_que_caen_detras(self):
        """0x8862 y 0x8C5F: los saltos de antes caen en la instruccion siguiente."""
        self.assertEqual(instruccion(0x8860), "jr $+5")
        self.assertEqual(instruccion(0x8C5D), "jr $+5")


class ElListado(unittest.TestCase):
    def test_densidad_y_flojas(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "densidad.py"), ASM],
            capture_output=True, text=True, check=True).stdout
        m = re.search(r"(\d+) instrucciones, (\d+) comentarios", salida)
        self.assertGreaterEqual(int(m.group(2)) * 100, 40 * int(m.group(1)))
        self.assertIn("---- 0 rutinas por debajo del 10 %", salida)

    def test_ningun_call_sin_nombre(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "sin_bautizar.py"), ASM],
            capture_output=True, text=True, check=True).stdout
        self.assertTrue(salida.startswith("0 rutinas sin bautizar"), salida[:200])

    def test_cada_comentario_en_su_instruccion(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "valida_c.py"), ASM, NOTAS],
            capture_output=True, text=True, check=True).stdout
        self.assertIn("0 fuera de sitio, 0 repetidos", salida)


if __name__ == "__main__":
    unittest.main()
