# The music

Five tunes, on the three channels of the PSG. They are not recorded by hand: `tools/musica.py` **runs the ROM's
own sound engine** with `tools/z80run.py` -`musica_pide` (0xA007) with the number of the tune and, every frame,
`sonido` (0xA020)- and logs what it writes to the PSG through the BIOS (WRTPSG).

**Checked against openMSX**: the tone and volume registers match the recorded ones, **0 different** in all
five, for as long as each tune plays. They were recorded in games played in openMSX (`tools/guiones/`): the
start of a stage, a stage lost, GAME OVER, and, forced, the end of a stage, its bonus and the end. Each
recorded frame is paired with the engine frame that has the same RAM in the three channels. GAME OVER starts
while the tune of the lost stage is still playing and leaves part of it in the channels: the engine is started
with the sound RAM as it was.

The sounds of the game are not here: the steps, the hammer, the blocks, the eggs and the rest.

## The engine

The engine does not run in the interrupt but in the game loop, once per frame. A request goes into 0xE1BE,
and on the next frame the engine starts the three channels of the tune from the table 0xA440, three pieces per
tune (`musica_empieza`, 0xA324). The channels are at 0xE180, 0xE192 and 0xE1A4, 18 bytes each; each frame they
are copied in turn to a work block at 0xE1C4, advanced one step and copied back. A note is one byte with the
length (from the table 0xA2FD, from 128 frames down to 1) and the volume, followed by the tone period; from
0xF0 up they are orders: noise, three loop marks with their counts, back to the start, silence and the end.
There are two kinds of sound effect: those of channel A (0xA464, 0xE1C0) and those of channels B and C
(0xA46E, 0xE1C2); a tune is never interrupted by an effect.

| | Who asks for it | Length |
|---|---|---:|
| the stage | the start of every stage (0x83AD) | 3.5 s |
| the stage done | the end of a stage (0x84A4) and the count of the bonus (0x8E93) | 4.3 s |
| the stage lost | TIME runs out, the hero dies or F2 (0x84A0, 0x8431) | 2.4 s |
| GAME OVER | no lives left (0x857C) | 3.8 s |
| the end | after stage 50 (0x8F4C) | 4.3 s |

## The stage

<audio controls src="audio/musica_fase.mp3"></audio>

## The stage done

<audio controls src="audio/musica_fase_hecha.mp3"></audio>

## The stage lost

<audio controls src="audio/musica_fase_perdida.mp3"></audio>

## GAME OVER

<audio controls src="audio/musica_game_over.mp3"></audio>

## The end

<audio controls src="audio/musica_final.mp3"></audio>
