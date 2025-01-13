# ROM file for Quorum ZX Spectrum computer

Current state - original V4.2 ROM for Quorum 256 is reversed and main part is disassembled. Running `make` assembles ROM back and checks the checksum.

# Reverse status

✔️ System menu \
❌ Quorum menu for 48K mode (undisassembled blob) \
✔️ Patches for ZX48 full compatibility mode (Python script compares Quorum 48 ROM against ZX Spectrum 48 ROM and generates binary patch) \
✔️ Fonts (Python script converts font in PNG to binary format) \
✔️ Taper (BASIC snapshot. Python script compresses it to the required format) \
❌ Memtest (ASM code extracted from main.asm, full reverse TBD) \
❔ Foxmon (blob extracted, not sure that disasm needed)

# TODO after initial reverse

Adapt ROM for Quorum-1024+. This is newly developed 74xx-based clone, some early info may be found here - https://zx-pk.ru/threads/35530-novodel-kvoruma-256.html (in Russian).
