; Patch file for original quorum-menu.rom
                DEVICE ZXSPECTRUM48
                ORG 0
                INCBIN "quorum-menu.rom"

                INCLUDE "quorum-menu.sym"

                ORG PATCH_RUN_BASIC_48_MENU
                jp FIX_OUT_0_AND_RUN_BASIC_48_MENU
                ASSERT $ == END_PATCH_RUN_BASIC_48_MENU

                ORG PATCH_NMI48
                JP OUT_0_FROM_NMI48

                INCLUDE "menu.patch.asm"
                INCLUDE "memtest.patch.asm"

                ORG PATCH_RUN_BASIC_128
                JP FIX_OUT_A_RUN_BASIC_128
; --------------------------------------------------------------------------------
; Continious block at the end of the ROM where the majority of new logic is stored

                ORG SYS_ROM_EMPTY_SPACE

                INCLUDE "menu.code.asm"
                INCLUDE "memtest.code.asm"


FIX_OUT_A_RUN_BASIC_128:
                LD C, A
                IN A, (0)
                AND #14
                OR C
                jp      #FFFD ; out (PORT_00), A8 + JP 00

; MENU-48 PATCH
LD_A_POS        DW #C029, #C092, #C0CC, #CC1F, #CC2F, #CC37, #CC5E, #CCA4, #CCEE, #D0AD, #D0D6
XOR_A_POS       DW #CC50, #CC8F, #CCB4, #CCD3, #CCE5
FIX_OUT_0_AND_RUN_BASIC_48_MENU:
                ldir

PROC_OUT_0_FIX_TARGET EQU #C028 - (END_PROC_OUT_0_FIX - PROC_OUT_0_FIX)

                LD HL, PROC_OUT_0_FIX
                LD DE, PROC_OUT_0_FIX_TARGET
                LD BC, END_PROC_OUT_0_FIX - PROC_OUT_0_FIX
                LDIR

                ; Fix A value at PROC_OUT_0_FIX
                LD HL, PROC_OUT_0_FIX_TARGET + 1
                IN A, (0)
                AND #14
                LD (HL), A

                LD HL, LD_A_POS
                LD C, A
                LD B, 11
fix_ld_a_loop:
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                INC E
                LD A, (DE)
                OR C
                LD (DE), A

                DJNZ fix_ld_a_loop

                LD HL, XOR_A_POS
                LD B, 5
fix_xor_a_loop:
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                LD A, #CD
                LD (DE), A
                INC DE
                LD A, PROC_OUT_0_FIX_TARGET % 256
                LD (DE), A
                INC DE
                LD A, PROC_OUT_0_FIX_TARGET / 256
                LD (DE), A
                DJNZ fix_xor_a_loop
                ret

PROC_OUT_0_FIX:
                ld a, 0
                out (0), a
                ret
END_PROC_OUT_0_FIX:

OUT_0_FROM_NMI48:
                IN A, (0)
                AND #14
                OUT (0), A
                JP RETURN_FROM_PATCH_NMI48

                SAVEBIN 'quorum-menu-1024plus.rom', 0, 16384