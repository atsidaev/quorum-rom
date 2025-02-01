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