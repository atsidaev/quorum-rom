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

                ORG PATCH_DRAW_MENU1
                JP ON_DRAW_MENU

                ; New keyboard read logic
                ORG PATCH_READ_KBD1:
                ld      c, 0
READ_MENU_KEYBORD_NEW:
                ld      b, 0
_loop_kbd_new:
                push bc
                call KEY_SCAN
                pop bc
                ld      a, e
                cp      c
                jr      nz, loc_1E6_new ; stabilize reading
                djnz    _loop_kbd_new
                CP #FF ; nothing pressed
                JP NZ, ON_KEYPRESS_NEW
loc_1E6_new:
                ld      c, a
                jr      READ_MENU_KEYBORD_NEW
CLICK_AND_JP_HL:
                ld de, #1010
                jr _play_sound
BEEP_AND_JP_HL:
                ld      de, 8080h
_play_sound:
                ex      af, af'
                xor     a
_play_click_new:
                xor     10h             ; generate square waveform
                out     (PORT_FE), a       ; black border + click
                ld      b, d
                djnz    $               ; pause a little
                dec     e
                jr      nz, _play_click_new
                ex      af, af'
                JP (HL)

                ASSERT $ <= END_ON_KEYPRESS

                ORG PATCH_DRAW_MENU2
                jp END_MENU_DRAWING
                nop
PRINT_MENU_VER:

                ORG aRomMenuQuorumV
                DEFB 'ROM-MENU QUORUM V.5.0 19.01.2025'

; MEMTEST
                ORG PATCH_MEMTEST0
                CALL PATCH_TEST_RAM_PROC

                ORG PATCH_MEMTEST1
                ld      b, 0Eh      ; String for 1024 is 1 byte longer than for 256
                jp      PREPARE_RAM_PAGE_NUMBERS

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
                PUSH AF
                call    PRINT_HEX_NUMBER    ; Reuse existing HEX number print function
                POP AF
                JP TEST_PAGE_NUMBER
                ASSERT $ == BEGIN_PATTERNS_TEST

                ORG PATCH_MEMTEST4
                cp      40h             ; 64 pages - for 1024 Kb

                ORG aRam256Kbyte
                DEFB 'RAM 1024 Kbyte'

                ORG PATCH_RUN_BASIC_128
                JP FIX_OUT_A_RUN_BASIC_128
; --------------------------------------------------------------------------------
; Continious block at the end of the ROM where the majority of new logic is stored

                ORG SYS_ROM_EMPTY_SPACE
ON_KEYPRESS_NEW:
                CP #24 ; '1'
                JR Z, BEEP_AND_RUN_BASIC_128
                CP #1C ; '2'
                JR Z, BEEP_AND_RUN_BASIC_48_MENU
                CP #14 ; '3'
                JR Z, BEEP_AND_RUN_BOOT_DOS_AND_REDRAW
                CP #0C
                JR Z, BEEP_AND_RUN_TEST_MEM
                CP #26 ; 'A'
                JR Z, TOGGLE_PENT
                CP #00 ; 'B'
                JR Z, TOGGLE_128K
                JP READ_MENU_KEYBORD_NEW
TOGGLE_PENT
                IN A, (0)
                XOR #4
                OUT (0), A
                JR CLICK_AND_RUN_BOOT_DOS_AND_REDRAW

TOGGLE_128K:
                IN A, (0)
                XOR #10
                OUT (0), A
                JR CLICK_AND_RUN_BOOT_DOS_AND_REDRAW

BEEP_AND_RUN_BASIC_128:
                LD HL, RUN_BASIC_128
                JR GO_TO_BEEP
BEEP_AND_RUN_BASIC_48_MENU:
                LD HL, RUN_BASIC_48_MENU
                JR GO_TO_BEEP
BEEP_AND_RUN_BOOT_DOS_AND_REDRAW:
                LD HL, RUN_BOOT_DOS_AND_REDRAW
                JR GO_TO_BEEP
BEEP_AND_RUN_TEST_MEM:
                LD HL, RUN_TEST_MEM
GO_TO_BEEP:
                JP BEEP_AND_JP_HL

CLICK_AND_RUN_BOOT_DOS_AND_REDRAW:
                LD BC, #4000
_loop_before_click:
                DEC BC
                LD A, B
                OR C
                JR NZ, _loop_before_click
                LD HL, RUN_BOOT_DOS_AND_REDRAW
                JP CLICK_AND_JP_HL

END_MENU_DRAWING:
                cp      6   ; 7 lines of menu
                jp      nz, draw_menu_loop

                ld      hl, #5020 + 4
                ld      de, PENTAGON_MODE_TEXT
                ld      b, ZX128_MODE_TEXT - PENTAGON_MODE_TEXT
                rst     8

                IN A, (0)
                PUSH AF
                AND #04     ; Pentagon bit
                CALL PRINT_ON_OFF

                ld      hl, #5040 + 4
                ld      de, ZX128_MODE_TEXT
                ld      b, MODE_TEXT_END - ZX128_MODE_TEXT
                rst     8

                POP AF
                XOR #FF
                AND #10     ; ZX128 bit
                CALL PRINT_ON_OFF

                jp PRINT_MENU_VER

; Z flag contains value to print
PRINT_ON_OFF:
                JR Z, PRINT_OFF
                LD DE, TEXT_ON
                JR _PRINT_DE_LEN_3
PRINT_OFF:      LD DE, TEXT_OFF
_PRINT_DE_LEN_3:
                LD B, 3
                RST 8
                RET

PENTAGON_MODE_TEXT:
                DEFB 'A - PENTAGON MODE:  '
ZX128_MODE_TEXT:
                DEFB 'B - 128K-ONLY MODE: '
MODE_TEXT_END:
TEXT_ON:        DEFB 'ON '
TEXT_OFF:       DEFB 'OFF'

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

; -------------------
PATCH_TEST_RAM_PROC:
                ; FIX OUT (0) arguments in TEST_RAM
                ; Fix OUT (0), 1 at the beginning
                IN A, (0)
                AND #14 ; D2=QUORUM/PENT | D4=128/1024
                LD L, A
                OR #01
                LD DE, TEST_RAM + 1
                LD (DE), A

                ; Fix OUT (0), 0 at the end
                LD A, L
                LD DE, TEST_RAM + (TEST_RAM_PROC_BODY_END - TEST_RAM_PROC_BODY) - 4
                LD (DE), A
                
                RET
; -------------------

PREPARE_RAM_PAGE_NUMBERS:
                rst     8
                
                LD DE, RAM_BANK_EXRAM_BIT + 7
                LD L, 64 ; pages count

_loop_prepare_ram1:
                LD A, L
                OR A
                JR Z, END_PREPARE_RAM_PAGE_NUMBERS

                LD B, 8
_loop_prepare_ram2:
                DEC B
                LD A, (DE)
                OR B
                INC B
                PUSH BC
                LD BC, #7ffd
                OUT (C), A
                POP BC
                LD A, L
                LD (#C000 + #1B00), A
                DEC L
                DJNZ _loop_prepare_ram2
                DEC DE
                JR _loop_prepare_ram1
END_PREPARE_RAM_PAGE_NUMBERS:
                ld      e, 0
                JP ITERATE_OVER_RAM_PAGES

                ; A - page number
                ; HL - screen print position
TEST_PAGE_NUMBER:
                LD C, A
                LD A, (#C000 + #1B00)
                DEC A
                CP C
                LD A, C
                JR Z, GOOD_PAGE
                LD A, '!'
                RST #10
                JR END_TEST_PAGE_NUMBER
GOOD_PAGE:
                rst     18h             ; print space before 'OK'/error
END_TEST_PAGE_NUMBER:
                JP BEGIN_PATTERNS_TEST

                ; copy KEY_SCAN proc from ROM
KEY_SCAN:       INCBIN 'resources/48.rom', #028E, #02BE - #028E + 1

; remove?
ON_DRAW_MENU:
                call    DRAW_MENU
                JP PATCH_READ_KBD1

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