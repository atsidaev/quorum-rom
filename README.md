# ROM file for Quorum ZX Spectrum computer

Current state - original V4.2 ROM for Quorum 256 is reversed and main part is disassembled. Running `make` assembles ROM back and checks the checksum.

Also it applies Quorum-1024+ patches (see below) and builds ROM for it also.

# Reverse status

✔️ System menu \
✔️ Quorum menu for 48K mode (all port #00 logic is fixed to keep new configuration bits active. In other it's undisassembled and that's ok at this stage) \
✔️ Patches for ZX48 full compatibility mode (Python script compares Quorum 48 ROM against ZX Spectrum 48 ROM and generates binary patch) \
✔️ Fonts (Python script converts font in PNG to binary format) \
✔️ Taper (BASIC snapshot. Python script compresses it to the required format) \
✔️ Memtest (ASM code extracted from main.asm, patch done to support testing of all 1024 Kbytes of RAM) \
❔ Foxmon (blob extracted, need to check if there is logic related to port #00)

# Quorum-1024+ ROM status

All above was started to make ROM for Quorum-1024+. This is newly developed 74xx-based clone, some early info may be found here - https://zx-pk.ru/threads/35530-novodel-kvoruma-256.html (in Russian).

New features implemented:

1. Support for new port #00 bits (Pentagon on/off and 1024 RAM on/off) is added to startup screen
2. Keyboard read rewritten
3. In startup menu all port #00 usages are fixed and include Pentagon+1024 bits in all OUT
4. In 48K menu all port #00 usages are identified and patched in runtime
5. Memtest fixed to support 1024K of RAM now. Check added and if started with less RAM it marks duplicated pages with `!`.
