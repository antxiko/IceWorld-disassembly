# Secrets and bugs

What was searched for in the code and what was found. A bug only goes here if it has been checked: by running the
game's own routine (`tools/bios.py`) or against the openMSX recordings.

## Secrets

- **The ten passwords.** KEYWORD leads to stage 1, 6, 11... up to 46 (`contrasena_busca`, 0x8268): they are in
  [The texts](THE-TEXTS.html). The letters are typed on the keyboard and read from the BIOS buffer (0xFBF0); lower case
  works too. All ten start with different letters, and that matters, because the search only goes on with the
  password whose first letter matches: if another letter failed, it would not look at the rest.
- **F1 and F2**, which no text in the game mentions: F1 pauses and resumes, F2 gives the stage up as lost (`tecla_f1`,
  0x84BD, on row 6 of SNSMAT). Apart from that, the game only reads the stick (the cursor keys and joystick 1), button
  1 of the joystick and the space bar (0x9DA5-0x9DEC).
- **The bonus stage password** is not the next one but the one for the five stages just played: see
  [Curiosities](CURIOSITIES.html).

## Bug: after stage 9, STAGE 00 and one more life

`fase_siguiente` (0x85B8) adds the ten to the lives byte (0xE00B) instead of the tens byte (0xE009). Recorded in
openMSX and told in [Curiosities](CURIOSITIES.html): after stage 9 it shows STAGE **00** and the lives go from four to
**five**; the map is the tenth one, as it should be.

## Bug: the up-left diagonal does not move

The player takes the stick direction like this: `and 7` and then `set 0` (0x885A-0x885E), so that each diagonal
becomes a straight direction. But up-left is 8, and `8 and 7` is 0: no direction. Running the stick and that
calculation of the game here:

| stick | the player goes |
|---|---|
| up-right (2) | right |
| down-right (4) | down |
| down-left (6) | left |
| up-left (8) | **stays still** |

## Bug: the cursor keys and the joystick are added

The interrupt (`interrupcion`) joins the cursor keys and joystick 1 with an **addition** (0x9DCD) of their direction numbers. With both at
once, running it here:

| cursor keys | joystick | the player goes |
|---|---|---|
| up | up | **right** |
| right | right | **left** |
| right | down | **still** |

## Bug: the score goes back to zero

The score is six BCD digits (0xE00C), and `puntos` (0x86C6) loses the carry out of the top byte (0x86E9): there is no
cap. Running it here, 999,950 + 50 gives **000000** and 999,990 + 40 gives **000030**. The game keeps no high score.
