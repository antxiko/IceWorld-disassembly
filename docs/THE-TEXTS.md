# The texts

The texts are in English, written with the letters of the BIOS: at the start the game copies the characters
0x30 to 0x5F of the BIOS font (from its fixed address 0x1D3F) to tiles 0 to 0x2F, and the characters 0x20 to
0x2F (0x1CBF) to tiles 0x30 to 0x3F, in the three thirds of the screen (`letras`, 0x872B). So tile 0 is the 0,
0x11 the A, 0x2E the cursor (^) and 0x38 and 0x39 the brackets; tile 0x10 is the space.

| Where | Text | Meaning |
|---|---|---|
| the title (0x9D30) | CASIO | in big letters of its own, two rows |
| the title (0x9152) | ICE WORLD | in big letters of its own, three rows |
| the title (0x9D48) | PUSH TRIGGER OR SPACE | press the button or the space bar |
| the title (0x9D5D) | COPYRIGHT 1985 © CASIO | the © is tile 0xC0 |
| the title (0x9E80) | KEYWORD (     ) | the keyword |
| the top (0x9D7D, 0x9D89) | SCORE:000000, STAGE: | the score and the stage |
| the top (0x9D73) | TIME : | the time left |
| no time left (0x9D79) | OVER | over the digits of TIME |
| no lives left (0x9174) | GAME OVER | |
| the end (0x909E) | 神技 | *kamiwaza*, "a divine skill", in big tiles of its own |

## The keywords

Ten keywords of five letters, each with the stage it opens (0x9E8F):

| Keyword | Stage |
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

Some of them are words: *denwa* is "telephone" and *yatta* "I did it!" in Japanese; PAZZL and LASTE read as
"puzzle" and "last". From the stage of the keyword, any of the next four can be chosen too.
