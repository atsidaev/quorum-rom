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

                ; copy KEY_SCAN proc from ROM
KEY_SCAN:       INCBIN 'resources/48.rom', #028E, #02BE - #028E + 1
