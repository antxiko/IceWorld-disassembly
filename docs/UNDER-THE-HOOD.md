# Under the hood

## Rebuilding the ROM

`make verify` assembles `src/iceworld.asm` with pasmo and the 16 KB ROM comes out **byte for byte**. `make
sanity` checks what reassembling does not cover: that no byte declared as data is read as code, that no entry
point falls in data and that all 16,384 bytes are explained. `make test` runs the tests. The ROM is not in the
repository: it has to be placed in the root as `iceworld.rom` (the GoodMSX dump, `[!]`, sha1 `167b226b...`).

| | bytes |
|---|---|
| traced code | 8,645 |
| named data | 7,739 |
| unexplained | 0 |

The listing has 1,676 comments on 4,013 instructions (41.8%), 571 routines and labels, none below 10%
commented, and no called routine without a name.

## The cartridge

16 KB in **page 2** (0x8000-0xBFFF), with INIT at 0x8010. Almost half is data: the maps of the 52 stages in six
places, the tile drawings and their colours (in runs of length and colour), the sprites, the big letters of
the title, the ten keywords, the controls of the two demonstrations and the music.

## The BIOS it uses

SETGRP, CHGCLR, DISSCR, ENASCR and WRTVDP to set the screen; FILVRM, LDIRVM, WRTVRM and RDVRM to fill it and
read it (RDVRM is how the game knows what is around the hero, the hammer and the creatures); GTSTCK, GTTRIG and
SNSMAT for the controls, and WRTPSG for the sound. It reads the BIOS font at its fixed addresses (0x1D3F and
0x1CBF), and the keyboard buffer (0xFBF0) for the KEYWORD.

## The interrupt and the loop

INIT puts a jump to 0x9D95 in the H.TIMI hook (0xFD9F). The interrupt only advances sixteen frame counters
(0xE010-0xE01F) and reads the controls; in the demonstrations it takes them from the stored list instead
(`interrupcion`, 0x9D95). Everything else runs in the loop of the stage, one step per counted frame (`paso`,
0x83F5): the hero, the blocks that break, the hammer, the creatures every 24 frames, TIME and the sound engine.

## How it was done

The trace follows the code from INIT and the interrupt, plus the destinations of the jump tables behind the
calls, declared in `src/iceworld.entries` and `src/iceworld.nocode`. The rest has been **measured in openMSX**
(`tools/omsx_cobertura.tcl`: a condition on every instruction logs every new ROM address), playing and waiting
for the demonstration on a Philips VG 8020: nothing that ran was left outside the trace.

## The RAM

| | |
|---|---|
| 0xE000 | the game running (0 in the demonstration) |
| 0xE001-0xE006, 0xE00C-0xE00E | the score: six digits and in BCD |
| 0xE007 | the stage - 1, in binary: the one that chooses the map |
| 0xE009 / 0xE00A | the stage: tens and units |
| 0xE00B | the lives |
| 0xE010-0xE01F | sixteen frame counters |
| 0xE040-0xE046 | the buttons |
| 0xE080-0xE087 | TIME, digit by digit, and its copy for the screen |
| 0xE100 | the sprite table, sent to 0x1B00 |
| 0xE180-0xE1C3 | the sound engine |
| 0xE1F0-0xE1FF | the KEYWORD being typed and the stick |
| 0xE200 | the hero |
| 0xE210-0xE2FF | the fifteen eggs and creatures (16 bytes each) |
| 0xE300 | the three blocks breaking |
| 0xE3C0 | the kind of stage: 0 normal, 1 bonus, 2 the end, 3 the title |
| 0xE3C1-0xE3C9 | the hammer |
| 0xE3CA | what is left to do in the stage |
| 0xE3D3 | the four point numbers on the screen |
