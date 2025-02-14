; Patch file for original quorum-menu.rom
                DEVICE ZXSPECTRUM48
                ORG 0
                INCBIN "quorum-menu.rom"

                ; use all symbols from original ROM
                INCLUDE "quorum-menu.sym"

                ; patch existing code
                INCLUDE "patches-1024plus/menu.patch.asm"
                INCLUDE "patches-1024plus/memtest.patch.asm"
                INCLUDE "patches-1024plus/out0.patch.asm"

; --------------------------------------------------------------------------------
; Continious block at the end of the ROM where the majority of new logic is stored

                ORG SYS_ROM_EMPTY_SPACE

                ; add new code to the empty space
                INCLUDE "patches-1024plus/menu.code.asm"
                INCLUDE "patches-1024plus/memtest.code.asm"
                INCLUDE "patches-1024plus/out0.code.asm"
                INCLUDE "patches-1024plus/out0.menu48.asm"

                SAVEBIN 'quorum-menu-1024plus.rom', 0, 16384