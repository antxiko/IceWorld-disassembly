# Los textos

Los textos están en inglés, escritos con las letras de la BIOS: al arrancar, el juego copia los caracteres 0x30
a 0x5F de la fuente de la BIOS (desde su dirección fija 0x1D3F) a las casillas 0 a 0x2F, y los caracteres 0x20
a 0x2F (0x1CBF) a las casillas 0x30 a 0x3F, en los tres tercios de la pantalla (`letras`, 0x872B). Así, la
casilla 0 es el 0, la 0x11 la A, la 0x2E el cursor (^) y la 0x38 y la 0x39 los paréntesis; la casilla 0x10 es
el espacio.

| Dónde | Texto | Qué dice |
|---|---|---|
| el título (0x9D30) | CASIO | en letras grandes propias, dos filas |
| el título (0x9152) | ICE WORLD | "mundo de hielo", en letras grandes propias, tres filas |
| el título (0x9D48) | PUSH TRIGGER OR SPACE | pulsa el botón o la barra |
| el título (0x9D5D) | COPYRIGHT 1985 © CASIO | el © es la casilla 0xC0 |
| el título (0x9E80) | KEYWORD (     ) | la contraseña |
| arriba (0x9D7D, 0x9D89) | SCORE:000000, STAGE: | los puntos y la fase |
| arriba (0x9D73) | TIME : | el tiempo que queda |
| sin tiempo (0x9D79) | OVER | encima de las cifras de TIME |
| sin vidas (0x9174) | GAME OVER | se acabó la partida |
| el final (0x909E) | 神技 | *kamiwaza*, "una habilidad divina", en casillas grandes propias |

## Las contraseñas

Diez contraseñas de cinco letras, cada una con la fase que abre (0x9E8F):

| La contraseña | Fase |
|---|---:|
| CASIO | 1 |
| VANIL | 6 |
| DENWA | 11 |
| JUNMK | 16 |
| PAZZL | 21 |
| KIYOK | 26 |
| FIREF | 31 |
| MORIY | 36 |
| YATTA | 41 |
| LASTE | 46 |

Algunas son palabras: *denwa* es "teléfono" y *yatta* "¡lo hice!" en japonés; PAZZL y LASTE se leen como
"puzzle" y "last" (último). Desde la fase de la contraseña se puede elegir también cualquiera de las cuatro
siguientes.
