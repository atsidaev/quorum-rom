; Patch file for original quorum-menu.rom

                DEVICE ZXSPECTRUM48
                ORG 0
                INCBIN "quorum-menu.rom"

                INCLUDE "quorum-menu.sym"

                ORG PATCH_READ_KBD1:
                and     #1F         ; 5 keys instead of 4

                ORG PATCH_READ_KBD2
                jp      CONTINUE_KEYPRESS_CHECK

                ORG     DRAW_MENU
                xor     a
                ld      de, new_menu_border_top

                ORG PATCH_DRAW_MENU1
                cp      7   ; 7 lines of menu

                ORG aRomMenuQuorumV
                DEFB 'ROM-MENU QUORUM V.5.0 19.01.2025'

; MEMTEST
                ORG PATCH_MEMTEST1
                ld      b, 0Eh      ; String for 1024 is 1 byte longer than for 256

                ORG PATCH_MEMTEST2
                jp      nc, MEMTEST_INC_BANK    ; we need more complex logic to select the next RAM page
                nop

                ORG PATCH_MEMTEST3
                rst     #18     ; wipe additional char 
                dec     hl      ; and 
                dec     hl      ;     go
                dec     hl      ;        back 
                dec     hl      ;             5
                dec     hl      ;               pos
                pop     af
                call    PRINT_HEX_NUMBER    ; Reuse existing HEX number print function
                nop             ; wipe
                nop             ; remaining
                nop             ; code of old char 
                nop             ; printing procedure

                ORG PATCH_MEMTEST4
                cp      40h             ; 64 pages - for 1024 Kb

                ORG aRam256Kbyte
                DEFB 'RAM 1024 Kbyte'

; Continious block at the end of the ROM where the majority of new logic is stored

                ORG SYS_ROM_EMPTY_SPACE
CONTINUE_KEYPRESS_CHECK:
                rrca
                jp      c, RUN_TEST_MEM
                
                ; Run Pentagon mode
RUN_PENT_128:                           ; CODE XREF: ROM:01FA↓j
                xor     a
                ld      bc, PORT_7FFD
                out     (c), a
                ld      (#FFFF), a
                ld      a, #AC
                ld      hl, #D3
                ld      (#FFFD), hl
                jp      #FFFD ; out (PORT_00), A8 + JP 00

RAM_BANK_EXRAM_BIT:
                ; Since EXRAM is D6, E2RAM is D7 and E3RAM is D5 it seems easier to use the table rather
                ; than reorder bits in runtime
                db 0b00000000 ; bank set 0
                db 0b01000000 ; bank set 1
                db 0b10000000 ; bank set 2
                db 0b11000000 ; bank set 3
                db 0b00100000 ; bank set 4
                db 0b01100000 ; bank set 5
                db 0b10100000 ; bank set 6
                db 0b11100000 ; bank set 7
MEMTEST_INC_BANK:
                ; input:  E - sequential page number
                ; output: A - 7ffd value for the page
                PUSH HL
                PUSH DE
                AND #07
                LD HL, RAM_BANK_EXRAM_BIT
                LD D, 0
                SRA E
                SRA E
                SRA E
                ADD HL, DE
                ADD A, (HL)
                POP DE
                POP HL
                jp TEST_RAM_PAGE
new_menu_border_top:
                DEFB 10h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 12h
                DEFB 0x13, '1 - Basic128', 0x14
                DEFB 0x13, '2 - Basic 48', 0x14
                DEFB 0x13, '3 - Boot DOS', 0x14
                DEFB 0x13, '4 - Test MEM', 0x14
                DEFB 0x13, '5 - Pent 128', 0x14
                DEFB 15h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 17h

                SAVEBIN 'quorum-menu-1024plus.rom', 0, 16384