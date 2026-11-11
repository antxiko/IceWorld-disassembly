#!/usr/bin/env python3
"""EL CONTENIDO de la web de esta ROM: lo unico que es de este juego.

jekyll.py y make_web.py son la maquinaria y no llevan dentro el nombre de
ningun juego: lo leen de aqui.

Todas las cifras de aqui estan medidas sobre esta ROM, con las herramientas
de tools/: CODIGO y DATOS los imprime tools/presupuesto.py (make sanity),
INSTRUCCIONES, COMENTARIOS y RUTINAS los da tools/densidad.py (make densidad:
"de N" rutinas, "N instrucciones, M comentarios").
"""

NOMBRE = "Ice World"
EDITOR = "Casio"
ANIO = 1985
REPOSITORIO = "https://github.com/antxiko/IceWorld-disassembly"
SHA1 = "167b226b54cc5b681a69d2c1509116ffaba868e4"

CODIGO = 8645
DATOS = 7739
RUTINAS = 571
INSTRUCCIONES = 4013
COMENTARIOS = 1676


def densidad(idioma):
    """El porcentaje comentado, con la coma o el punto de cada idioma."""
    d = "%.1f" % (100.0 * COMENTARIOS / INSTRUCCIONES)
    return d.replace(".", ",") if idioma == "es" else d


PIE_LEGAL = {
    "es": "<em>Ice World</em> es un juego de Casio para MSX, de 1985, en un cartucho de 16 KB. "
          "Todos los derechos sobre el juego siguen siendo de sus titulares. Este trabajo es de "
          "preservaci&oacute;n, estudio y documentaci&oacute;n, y la imagen de la ROM no se distribuye.",
    "en": "<em>Ice World</em> is a 1985 Casio game for the MSX, on a 16 KB cartridge. All rights in "
          "the game remain with their holders. This is preservation, study and documentation work, and the "
          "ROM image is not distributed.",
}

PORTADA = {
    "es": dict(
        titulo="Ice World - desensamblado comentado",
        claim="Cincuenta laberintos de hielo: el martillo que rompe bloques, las piezas en L que se juntan por "
              "parejas, los huevos que se rompen y los bichos que buscan al protagonista. Las diez contrase&ntilde;as, "
              "la fase de premio cada cinco y el final con sus kanji; el t&iacute;tulo desde los bytes de la ROM, "
              "cotejado con openMSX; la partida en GIF y las cinco m&uacute;sicas de su propio motor, id&eacute;nticas "
              "a openMSX cuadro a cuadro.",
        ficha=["Casio - <b>(c) 1985</b>",
               "Cartucho de <b>16 KB</b> en 0x8000",
               "<b>MSX</b>", "Volcado <b>167b226b...</b>"],
        aviso="<b>Aqu&iacute; no hay capturas del juego.</b> El logotipo y el t&iacute;tulo salen de "
              "ejecutar la ROM (cotejados con openMSX), y los GIF son la ROM <b>funcionando en "
              "openMSX</b>: en cada cuadro se apuntan la VRAM y los registros del VDP, y <b>c&oacute;digo "
              "nuestro los pinta</b>.",
    ),
    "en": dict(
        titulo="Ice World - commented disassembly",
        claim="Fifty mazes of ice: the hammer that breaks blocks, the L-shaped pieces put together in pairs, the "
              "eggs that crack and the creatures that look for the hero. The ten keywords, the bonus stage every "
              "five and the end with its kanji; the title from the ROM's bytes, checked against openMSX; the game "
              "in GIF and the five tunes from its own engine, identical to openMSX frame by frame.",
        ficha=["Casio - <b>(c) 1985</b>",
               "<b>16 KB</b> cartridge at 0x8000",
               "<b>MSX</b>", "Dump <b>167b226b...</b>"],
        aviso="<b>There are no screenshots of the game here.</b> The logo and the title come from running "
              "the ROM (checked against openMSX), and the GIFs are the ROM <b>running in openMSX</b>: on every "
              "frame the VRAM and the VDP registers are logged, and <b>our own code paints them</b>.",
    ),
}

PAGINAS = [
    [("THE-GAME.html", "LA-PARTIDA.html", "The game", "La partida",
      "the title, the KEYWORD, the controls, the hammer, TIME, the lives and the points",
      "el t&iacute;tulo, la KEYWORD, los mandos, el martillo, TIME, las vidas y los puntos"),
     ("THE-STAGES.html", "LAS-FASES.html", "The stages", "Las fases",
      "the maps, the pieces, the eggs and the creatures, the bonus stage and the end, in GIF",
      "los mapas, las piezas, los huevos y los bichos, la fase de premio y el final, en GIF"),
     ("THE-TEXTS.html", "LOS-TEXTOS.html", "The texts", "Los textos",
      "every text in the ROM and the ten keywords",
      "todos los textos de la ROM y las diez contrase&ntilde;as"),
     ("THE-MUSIC.html", "LA-MUSICA.html", "The music", "La m&uacute;sica",
      "the five tunes, from its own sound engine and checked against openMSX",
      "las cinco m&uacute;sicas, de su propio motor de sonido y cotejadas con openMSX")],
    [("CURIOSITIES.html", "CURIOSIDADES.html", "Curiosities", "Curiosidades",
      "stage 00 after stage 9, the keyword of the bonus, maps among the drawings and the code nobody reaches",
      "la fase 00 tras la 9, la contrase&ntilde;a del premio, mapas entre los dibujos y el c&oacute;digo al que no "
      "se llega")],
    [("UNDER-THE-HOOD.html", "POR-DENTRO.html", "Under the hood", "Por dentro",
      "rebuilding the ROM, the BIOS it uses, the interrupt and the loop, the RAM and the tools",
      "rehacer la ROM, la BIOS que usa, la interrupci&oacute;n y el bucle, la RAM y las herramientas")],
]

# Repositorio nuevo: no hay paginas viejas que redirigir.
VIEJAS = {}

LOGOTIPO = "logotipo.png"
