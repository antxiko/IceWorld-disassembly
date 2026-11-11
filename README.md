# Ice World - commented disassembly

*(También [en castellano](README.es.md).)*

The commented disassembly of **Ice World** (Casio, 1985) for the MSX: a 16 KB cartridge at 0x8000.

- **100%** of the binary explained: 8,645 bytes of code and 7,739 of named data, not one byte unassigned.
- **41.8%** of the listing commented, 571 routines and labels, none below 10% of comments.
- The listing reassembles into the original ROM **byte for byte**.
- The title comes from running the ROM, checked against openMSX; the KEYWORD, the stages, the hammer, the bonus stage and the end, played in GIF; the five tunes, from its own sound engine and identical to openMSX frame by frame.

The site: <https://antxiko.github.io/IceWorld-disassembly/>
(in Spanish: <https://antxiko.github.io/IceWorld-disassembly/es/>).

## Rebuilding it

The ROM image is not distributed. Put yours in the root as `iceworld.rom` (sha256 `56c4333d...`) and run `make`. The details, in [UNDER THE HOOD](docs/UNDER-THE-HOOD.md).

## Legal

The game belongs to Casio and its rights holders. The `LICENSE` covers only the tools, comments, analysis and documentation here. See [LEGAL-NOTICE.md](LEGAL-NOTICE.md).
