# Curiosities

## After stage 9, stage 00

When a stage is done, `fase_siguiente` (0x85B8) adds one to the units of the stage (0xE00A); when they pass 9 it
sets them to 0 and adds one to the **next byte**, 0xE00B. But the tens are in the byte **before**, 0xE009, and
0xE00B holds the lives. Recorded in openMSX (forced: stage 9 chosen with VANIL and finished at once): after
stage 9, STAGE reads **00** and the lives go from four to **five**. The map is the right one, the tenth: it is
chosen by another counter (0xE007).

## The keyword of the bonus

The bonus stage shows a KEYWORD. It is not the next one: after stages 1-5 it shows CASIO, the keyword of stage
1; after 6-10, VANIL, the one of stage 6 (`descanso_clave`, 0x90F8).

## Maps among the drawings

The tile drawings at 0xA800 are loaded into the VRAM in one go, 0x600 bytes, and in the middle there are the
table of the maps and the maps of stages 1 to 11 (0xA960-0xAB7E); then other tiles are written on top. The
drawings of the sprites (0xB800, 0x800 bytes) carry a routine (0xBBC0) and the maps of stages 29 to 41.

## Data behind the calls

Three routines take a jump table from right after the `call` that reaches them (0x9F53, 0x9F59 and 0x91A5), and
another one (0x9782) a list of pairs, tile and kind, ten bytes behind each of the eight calls at 0x9702-0x9772.
None of them returns to the instruction after the call.

## Code nobody reaches

- 0x8862: `ld a,(0E203h)`, the direction from before. The two jumps just before it land on the next
  instruction.
- 0x8C5F: `call 0B49Ah`, with the same two jumps over it.
- 0x90F2: six bytes, `ld b,a / ld c,0 / jp LDIRVM`, after the texts of the end.
- 0xB4E7: `pop hl / ret`, between a routine and the maps.
