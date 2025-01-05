                DEVICE ZXSPECTRUM48

; Ensure 0xFF in all gaps
                ORG 0
                DUP 16384
                DB 0xFF
                EDUP

                ORG 0

SCREEN_4000     EQU #4000
OUT_0_A_JP_3D2F EQU #5D15
TEST_RAM        EQU #5D1A
TEST_ROM        EQU #5D02

MENU_BEGIN_SCREEN_ADDR  EQU #4808
VER_BEGIN_SCREEN_ADDR   EQU #50E0

sub_0:                                  ; DATA XREF: ROM:0303↓w
                di
                ld      hl, 0
                ld      sp, hl
                exx
                jr      loc_30
; End of function sub_0


; =============== S U B R O U T I N E =======================================


PRINT:                                  ; CODE XREF: PRINT+3↓j
                                        ; DRAW_MENU+16↓p ...
                ld      a, (de)
                rst     10h
                inc     de
                djnz    PRINT
                ret
; End of function PRINT

                ORG #0010

PRINT_CHAR_A:                           ; CODE XREF: PRINT+1↑p
                                        ; sub_18+2↓j ...
                jp      _PRINT_CHAR

                out     (0), a
                jr      loc_4C

                ORG #0018

sub_18:                                 ; CODE XREF: ROM:05C0↓p
                                        ; sub_605+9F↓p ...
                ld      a, 20h ; ' '
                jr      PRINT_CHAR_A

                ORG #0020

sub_20:                                 ; CODE XREF: sub_20+6↓j
                                        ; ROM:01B8↓p
                ld      (hl), b
                ld      a, (hl)
                ld      (hl), a
                xor     a
                out     (0FEh), a
                jr      sub_20

sub_28:                                 ; CODE XREF: sub_605+F6↓p
                                        ; sub_605+F9↓p ...
                jp      loc_799

; Unreferenced
                out     (0), a
                jr      loc_6D
                db 0DAh     ; ?????

loc_30:                                 ; CODE XREF: sub_0+6↑j
                ld      a, 7Eh ; '~'
                in      a, (0FEh)
                rra
                jr      loc_73
; ---------------------------------------------------------------------------
                rst     38h
                ret
                dw 0AA55h
byte_3B:        db 0FFh, 0, 80h, 0FFh, 0FFh
                                        ; DATA XREF: ROM:0165↓o
; ---------------------------------------------------------------------------
                jp      loc_2EB
; ---------------------------------------------------------------------------
                jp      sub_41F
; ---------------------------------------------------------------------------
                jp      loc_3F5
; ---------------------------------------------------------------------------
                jp      attempt_to_boot
; ---------------------------------------------------------------------------

loc_4C:                                 ; CODE XREF: ROM:0015↑j
                or      20h ; ' '
; START OF FUNCTION CHUNK FOR PATCH_ROM

loc_4E:                                 ; CODE XREF: PATCH_ROM+62↓j
                out     (0), a
                pop     af

_chunk1:
                ei
                ret
; END OF FUNCTION CHUNK FOR PATCH_ROM
; ---------------------------------------------------------------------------
                call    attempt_to_boot
                jp      COPY_IMG_TO_RAM
; ---------------------------------------------------------------------------
                db 0FFh, 0FFh, 0, 5Dh, 0D9h, 0CAh, 0F3h, 18h, 0F1h
; ---------------------------------------------------------------------------

loc_62:                                 ; CODE XREF: ROM:0064↓j
                                        ; ROM:010F↓j
                out     (0), a
                jr      loc_62
; ---------------------------------------------------------------------------
                push    af
                push    bc
                push    de
                push    hl

loc_6A:
                jp      loc_A7
; ---------------------------------------------------------------------------

loc_6D:                                 ; CODE XREF: ROM:002D↑j
                or      20h ; ' '

loc_6F:                                 ; CODE XREF: ROM:loc_A5↓j
                                        ; PATCH_ROM:loc_3EF↓j
                out     (0), a
                pop     af
                ret
; ---------------------------------------------------------------------------

loc_73:                                 ; CODE XREF: ROM:0035↑j
                ex      af, af'
                ld      bc, 4000h

loc_77:                                 ; CODE XREF: ROM:007A↓j
                dec     bc
                ld      a, c
                or      b
                jr      nz, loc_77
                ex      af, af'
                jr      nc, loc_97
                rra
                jp      c, loc_12E

RUN_BASIC128:                           ; CODE XREF: ROM:01FA↓j
                xor     a
                ld      bc, 7FFDh
                out     (c), a
                ld      (#FFFF), a
                ld      a, 0A8h
                ld      hl, 0D3h
                ld      (#FFFD), hl

loc_94:                                 ; out (0), A8 + JP 00
                jp      #FFFD
; ---------------------------------------------------------------------------

loc_97:                                 ; CODE XREF: ROM:007D↑j
                                        ; ROM:00AF↓j
                ld      a, 17h

loc_99:
                ld      bc, 7FFDh
                out     (c), a

loc_9E:
                ld      hl, 0
                push    hl

loc_A2:
                ld      a, 0E0h
                push    af

loc_A5:
                jr      loc_6F
; ---------------------------------------------------------------------------

loc_A7:                                 ; CODE XREF: ROM:loc_6A↑j
                ld      a, 7Eh ; '~'

loc_A9:
                in      a, (0FEh)
                rra

loc_AC:
                jr      nc, loc_116
                rra
                jr      nc, loc_97
                ld      a, (#F000)
                ld      e, a
                ld      a, r
                or      a
                jr      nz, loc_BC
                ld      a, 7Bh ; '{'

loc_BC:                                 ; CODE XREF: ROM:00B8↑j
                ld      (#F000), a
                ld      d, a
                ld      l, 8
                ld      bc, 7FFDh

loc_C5:                                 ; CODE XREF: ROM:00D0↓j
                dec     l
                out     (c), l
                ld      a, (#F000)
                cp      d

loc_CC:
                jr      z, loc_D4
                ld      a, l
                or      a
                jr      nz, loc_C5
                ld      l, 7

loc_D4:                                 ; CODE XREF: ROM:loc_CC↑j
                ld      a, 40h ; '@'
                out     (c), a
                ld      a, (#C066)

UNK_BLOB2:
                cp      0C3h
                jr      nz, loc_F2
                ld      a, l
                or      10h
                ld      hl, 0F1C1h
                ld      (#C064), hl
                out     (c), a
                ld      a, e
                ld      (#F000), a
                ld      a, 9
                jr      loc_10D
; ---------------------------------------------------------------------------

loc_F2:                                 ; CODE XREF: ROM:00DD↑j
                xor     a

loc_F3:
                out     (c), a
                ld      a, (#C066)
                cp      0C3h
                jr      nz, loc_112
                ld      a, l
                or      10h
                ld      hl, 0F1C1h
                ld      (#C064), hl
                out     (c), a
                ld      a, e
                ld      (#F000), a
                ld      a, 1

loc_10D:                                ; CODE XREF: ROM:00F0↑j
                pop     hl
                pop     de
                jp      loc_62
; ---------------------------------------------------------------------------

loc_112:                                ; CODE XREF: ROM:00FA↑j
                ld      a, 17h
                out     (c), a

loc_116:                                ; CODE XREF: ROM:loc_AC↑j
                push    ix
                push    iy
                exx
                push    bc
                push    de
                push    hl
                ex      af, af'
                push    af
                ld      a, i
                push    af
                ld      a, r
                push    af
                ld      hl, 0
                add     hl, sp
                exx
                jp      loc_219
; ---------------------------------------------------------------------------

loc_12E:                                ; CODE XREF: ROM:0080↑j
                ld      a, 0F7h
                in      a, (7Eh)
                rrca
                jp      nc, COPY_IMG_TO_RAM
                xor     a
                out     (0FEh), a
                ld      hl, 4000h
                ld      (hl), a
                ld      de, 4001h
                ld      bc, 4000h
                ldir
                ld      hl, 0
                ld      c, 40h ; '@'

crc_loop:                               ; CODE XREF: ROM:014C↓j
                                        ; ROM:014F↓j
                add     a, (hl)
                inc     hl
                djnz    crc_loop
                dec     c
                jr      nz, crc_loop
                or      a
                jr      z, crc_ok
                xor     a
                ld      de, 8000h

bad_crc_warn:                           ; CODE XREF: ROM:0160↓j
                xor     12h
                out     (0FEh), a
                ld      b, d

loc_15D:                                ; CODE XREF: ROM:loc_15D↓j
                djnz    $
                dec     e
                jr      nz, bad_crc_warn

crc_ok:                                 ; CODE XREF: ROM:0152↑j
                xor     a
                out     (0FEh), a
                ld      de, byte_3B

loc_168:                                ; CODE XREF: ROM:0187↓j
                ld      a, (de)
                cp      80h
                jr      z, RUN_BOOT_DOS_AND_REDRAW
                ld      h, a
                ld      bc, 40h ; '@'
                ld      ix, 4000h

cls_loop:                               ; CODE XREF: ROM:0181↓j
                                        ; ROM:0184↓j
                ld      (ix+0), h
                ld      l, (ix+0)
                ld      a, h
                cp      l
                jr      nz, loc_189
                inc     ix
                djnz    cls_loop
                dec     c
                jr      nz, cls_loop
                inc     de
                jr      loc_168
; ---------------------------------------------------------------------------

loc_189:                                ; CODE XREF: ROM:017D↑j
                ex      af, af'
                ld      a, l
                ld      hl, 5800h
                ld      (hl), 0
                ld      de, 5801h
                ld      bc, 2FFh
                ldir
                ld      hl, 5800h
                ld      c, 18h
                ld      de, 18h

loc_1A0:                                ; CODE XREF: ROM:01AF↓j
                ld      b, 8

loc_1A2:                                ; CODE XREF: ROM:01A8↓j
                rlca
                jr      nc, loc_1A7
                ld      (hl), 3Fh ; '?'

loc_1A7:                                ; CODE XREF: ROM:01A3↑j
                inc     hl
                djnz    loc_1A2
                ld      (hl), 64h ; 'd'
                ex      af, af'
                add     hl, de
                dec     c
                jr      nz, loc_1A0
                ld      sp, ix
                ld      hl, 0
                add     hl, sp
                ld      b, a
                rst     20h

RUN_BOOT_DOS_AND_REDRAW:                ; CODE XREF: ROM:016B↑j
                                        ; ROM:0201↓j
                ld      a, 7
                out     (0FEh), a
                call    attempt_to_boot
                xor     a
                out     (0FEh), a
                ld      hl, 5800h
                ld      de, 5801h
                ld      bc, 2FFh
                ld      (hl), 7
                ldir
                call    DRAW_MENU
                ld      c, 0

loop_kbd1:                              ; CODE XREF: ROM:01E7↓j
                ld      b, 0

loop_kbd2:                              ; CODE XREF: ROM:01E1↓j
                ld      a, 0F7h
                in      a, (0FEh)
                cpl
                and     0Fh
                cp      c
                jr      nz, loc_1E6
                djnz    loop_kbd2
                or      a
                jr      nz, loc_1E9

loc_1E6:                                ; CODE XREF: ROM:01DF↑j
                ld      c, a
                jr      loop_kbd1
; ---------------------------------------------------------------------------

loc_1E9:                                ; CODE XREF: ROM:01E4↑j
                ex      af, af'
                xor     a
                ld      de, 8080h

loc_1EE:                                ; CODE XREF: ROM:01F6↓j
                xor     10h
                out     (0FEh), a       ; black border + click
                ld      b, d

loc_1F3:                                ; CODE XREF: ROM:loc_1F3↓j
                djnz    $
                dec     e
                jr      nz, loc_1EE
                ex      af, af'
                rrca
                jp      c, RUN_BASIC128
                rrca
                jr      c, COPY_IMG_TO_RAM
                rrca
                jr      c, RUN_BOOT_DOS_AND_REDRAW
                jp      RUN_TEST_MEM
; ---------------------------------------------------------------------------

COPY_IMG_TO_RAM:                        ; CODE XREF: ROM:0056↑j
                                        ; ROM:0133↑j ...
                xor     a
                ld      bc, 7FFDh
                out     (c), a
                ld      (#C066), a
                ld      hl, 51FFh
                ld      (#C026), hl
                ld      a, l
                ld      (#C025), a

loc_219:                                ; CODE XREF: ROM:012B↑j
                ld      bc, 7FFDh
                ld      a, 16h          ; Basic-48 menu is in PAGE 6
                out     (c), a
                ld      sp, 0
                ld      hl, IMG
                ld      de, 0C028h
                push    de
                ld      bc, 10C0h
                ldir
                ret

; =============== S U B R O U T I N E =======================================


DRAW_MENU:                              ; CODE XREF: ROM:01D0↑p
                xor     a
                ld      de, menu_border_top

draw_menu_loop:                         ; CODE XREF: DRAW_MENU+1B↓j
                ld      hl, MENU_BEGIN_SCREEN_ADDR
                push    af
                sla     a
                sla     a
                sla     a
                sla     a
                sla     a
                add     a, l
                ld      l, a
                ld      b, 0Eh
                rst     8
                pop     af
                inc     a
                cp      6
                jr      nz, draw_menu_loop
                ld      hl, VER_BEGIN_SCREEN_ADDR
                ld      de, aRomMenuQuorumV ; "ROM-MENU QUORUM V.4.2 27.06.1997"
                ld      b, 20h ; ' '
                rst     8
                ret
; End of function DRAW_MENU

; ---------------------------------------------------------------------------
menu_border_top:DEFB 10h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 11h, 12h
menu_line1:     DEFB 0x13, '1 - Basic128', 0x14
menu_line2:     DEFB 0x13, '2 - Basic 48', 0x14
menu_line3:     DEFB 0x13, '3 - Boot DOS', 0x14
menu_line4:     DEFB 0x13, '4 - Test MEM', 0x14
menu_border_bot:DEFB 15h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 16h, 17h

FONT_PSEUDOGRAPH:db 0FFh,0FFh, 80h, 80h, 80h, 80h, 80h, 80h
                db 0FFh,0FFh,   0,   0,   0,   0,   0,   0
                db 0FFh,0FFh,   2,   2,   2,   2,   2,   2
                db  80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h
                db    2,   2,   2,   2,   2,   2,   2,   2
                db  80h, 80h, 80h, 80h, 80h, 80h,0FFh,0FFh
                db    0,   0,   0,   0,   0,   0,0FFh,0FFh
                db    2,   2,   2,   2,   2,   2,0FFh,0FFh
; ---------------------------------------------------------------------------

loc_2EB:                                ; CODE XREF: ROM:0040↑j
                                        ; ROM:041C↓j
                ld      bc, 2000h

loc_2EE:                                ; CODE XREF: ROM:02F1↓j
                dec     bc
                ld      a, c
                or      b
                jr      nz, loc_2EE
                ld      bc, 7FFDh
                ld      a, 10h
                out     (c), a
                xor     a
                out     (0), a
                ld      hl, 0C000h
                ld      e, (hl)
                dec     a
                xor     e
                ld      (sub_0), a
                cp      (hl)
                ld      (hl), e
                ld      hl, 4000h
                res     7, (hl)
                jp      nz, loc_3A6
                ld      a, (#C026+1)
                cp      0FFh
                jr      z, loc_326
                ld      a, 51h ; 'Q'
                ld      (#C026+1), a
                ld      a, (#C026)
                cp      54h ; 'T'
                jr      z, loc_326
                jp      SWITC_TO_48
; ---------------------------------------------------------------------------

loc_326:                                ; CODE XREF: ROM:0315↑j
                                        ; ROM:0321↑j
                set     7, (hl)
                ld      hl, 336h
                ld      de, 0C003h
                ld      bc, 15h
                ldir
                jp      #C003
; ---------------------------------------------------------------------------
                ld      a, 20h ; ' '
                out     (0), a
                ld      hl, 28h ; '('
                ld      de, 0C028h
                ld      bc, 3FD8h
                ldir
                xor     a
                out     (0), a
                jp      loc_34B
; ---------------------------------------------------------------------------

loc_34B:                                ; CODE XREF: ROM:0348↑j
                ld      de, 0C000h
                ld      bc, 25h ; '%'
                ld      hl, CODE_BLOCK_1
                ldir
                ld      a, (#C026+1)
                cp      0FFh
                jr      nz, loc_389
                ld      hl, 386Eh
                ld      bc, 492h

loc_363:                                ; CODE XREF: ROM:0369↓j
                ld      (hl), 0FFh
                inc     hl
                dec     bc
                ld      a, c
                or      b
                jr      nz, loc_363
                ld      hl, FONT_8x8    ; move font to Quorum ROM
                ld      de, 3D00h
                ld      bc, 300h
                ldir
                ld      hl, ORIG_48_ROM_PATCH ; db - size
                                        ; dw - address
                                        ; array bytes [size] - data
                ld      b, 0

_PATCH_ORIG_LOOP:                       ; CODE XREF: ROM:0387↓j
                ld      a, (hl)
                or      a
                jr      z, loc_389
                ld      c, a
                inc     hl
                ld      e, (hl)
                inc     hl
                ld      d, (hl)
                inc     hl
                ldir
                jr      _PATCH_ORIG_LOOP
; ---------------------------------------------------------------------------

loc_389:                                ; CODE XREF: ROM:035B↑j
                                        ; ROM:037D↑j
                ld      a, (#C026)
                cp      54h ; 'T'
                jr      nz, SWITC_TO_48

; =============== S U B R O U T I N E =======================================


PATCH_ROM:

; FUNCTION CHUNK AT 004E SIZE 00000005 BYTES

                ld      hl, TURBO_LOADER_PATCH

_PATCH_TURBO_LOOP:                      ; CODE XREF: PATCH_ROM+D↓j
                ld      a, (hl)         ; amount of bytes to patch
                or      a
                jr      z, SWITC_TO_48
                inc     hl
                ld      e, (hl)         ; DE will be address to patch
                inc     hl
                ld      d, (hl)
                inc     hl
                ld      (de), a
                jr      _PATCH_TURBO_LOOP ; repeat while patch data exists
; ---------------------------------------------------------------------------

SWITC_TO_48:                            ; CODE XREF: ROM:0323↑j
                                        ; ROM:038E↑j ...
                ld      bc, 7FFDh
                ld      a, 17h
                out     (c), a

loc_3A6:                                ; CODE XREF: ROM:030D↑j
                exx
                ld      a, h
                cp      40h ; '@'
                jr      nc, loc_3B6
                ld      hl, 0
                ld      sp, 4008h
                push    hl
                push    hl
                jr      loc_3DE
; ---------------------------------------------------------------------------

loc_3B6:                                ; CODE XREF: PATCH_ROM+1A↑j
                ld      sp, hl
                pop     af
                ld      r, a
                pop     af
                ld      i, a
                ld      hl, 4000h
                set     0, (hl)
                jp      po, loc_3C7
                res     0, (hl)

loc_3C7:                                ; CODE XREF: PATCH_ROM+32↑j
                pop     af
                pop     hl
                pop     de
                pop     bc
                exx
                ex      af, af'
                pop     iy
                pop     ix
                pop     hl
                pop     de
                pop     bc
                ld      a, (#5C48)
                and     38h ; '8'
                rrca
                rrca
                rrca
                out     (0FEh), a

loc_3DE:                                ; CODE XREF: PATCH_ROM+24↑j
                ld      a, (SCREEN_4000)
                bit     7, a
                jr      nz, loc_3EB
                bit     0, a
                ld      a, 60h ; '`'
                jr      loc_3EF
; ---------------------------------------------------------------------------

loc_3EB:                                ; CODE XREF: PATCH_ROM+53↑j
                bit     0, a
                ld      a, 41h ; 'A'

loc_3EF:                                ; CODE XREF: PATCH_ROM+59↑j
                jp      nz, loc_6F
                jp      loc_4E
; End of function PATCH_ROM

; ---------------------------------------------------------------------------

loc_3F5:                                ; CODE XREF: ROM:0046↑j
                ld      bc, 7FFDh
                ld      a, 17h
                out     (c), a
                ex      de, hl
                ld      hl, 5C00h
                ld      sp, hl
                ex      de, hl
                push    hl
                pop     ix
                ld      c, (hl)
                inc     hl
                ld      b, (hl)
                inc     hl
                inc     hl
                inc     hl
                push    hl
                add     hl, bc
                ld      c, l
                ld      b, h
                pop     hl
                call    sub_41F
                ld      l, (ix+2)
                ld      h, (ix+3)
                exx
                im      1
                jp      loc_2EB

; =============== S U B R O U T I N E =======================================


sub_41F:                                ; CODE XREF: ROM:0043↑j
                                        ; ROM:0410↑p
                push    bc

loc_420:                                ; CODE XREF: sub_41F+16↓j
                                        ; sub_41F+25↓j ...
                xor     a
                pop     bc
                push    hl
                sbc     hl, bc
                pop     hl
                ret     nc
                push    bc
                ld      a, (hl)
                inc     hl
                ld      b, a
                rlca
                jr      c, loc_437
                inc     b

loc_42F:                                ; CODE XREF: sub_41F+14↓j
                ld      a, (hl)
                inc     hl
                ld      (de), a
                inc     de
                djnz    loc_42F
                jr      loc_420
; ---------------------------------------------------------------------------

loc_437:                                ; CODE XREF: sub_41F+D↑j
                ld      a, (hl)
                inc     hl
                inc     b
                jr      z, loc_446
                res     7, b
                ld      c, a

loc_43F:                                ; CODE XREF: sub_41F+23↓j
                ld      a, c
                ld      (de), a
                inc     de
                djnz    loc_43F
                jr      loc_420
; ---------------------------------------------------------------------------

loc_446:                                ; CODE XREF: sub_41F+1B↑j
                push    af
                ld      a, (hl)
                inc     hl
                ld      b, a
                ld      a, (hl)
                inc     hl
                ld      c, a
                inc     c
                inc     b

loc_44F:                                ; CODE XREF: sub_41F+34↓j
                                        ; sub_41F+37↓j
                pop     af
                ld      (de), a
                push    af
                inc     de
                djnz    loc_44F
                dec     c
                jr      nz, loc_44F
                pop     af
                jr      loc_420
; End of function sub_41F

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR attempt_to_boot

loc_45B:                                ; CODE XREF: attempt_to_boot+A↓j
                                        ; attempt_to_boot+16↓j ...
                xor     a
                out     (85h), a
                ret
; END OF FUNCTION CHUNK FOR attempt_to_boot

; =============== S U B R O U T I N E =======================================


attempt_to_boot:                        ; CODE XREF: ROM:0049↑j
                                        ; ROM:0053↑p ...

; FUNCTION CHUNK AT 045B SIZE 00000004 BYTES
; FUNCTION CHUNK AT 04C1 SIZE 00000036 BYTES

                ld      hl, 8800h
                xor     a
                out     (85h), a
                in      a, (80h)
                bit     7, a
                jr      z, loc_45B
                ld      a, 21h ; '!'
                out     (85h), a
                call    pause_256
                in      a, (80h)
                rla
                jr      c, loc_45B
                call    sub_507
                xor     a
                call    sub_509
                ld      de, 0
                in      a, (80h)
                and     2
                ld      c, a

loc_486:                                ; CODE XREF: attempt_to_boot+31↓j
                in      a, (80h)
                and     2
                cp      c
                jr      nz, loc_494
                dec     de
                ld      a, d
                or      e
                jr      nz, loc_486
                jr      loc_45B
; ---------------------------------------------------------------------------

loc_494:                                ; CODE XREF: attempt_to_boot+2C↑j
                ld      e, 1

loc_496:                                ; CODE XREF: attempt_to_boot+71↓j
                ld      b, 3

loc_498:                                ; CODE XREF: attempt_to_boot+41↓j
                ld      a, e
                push    hl
                call    sub_4A4
                pop     hl
                jr      z, loc_4C1
                djnz    loc_498
                jr      loc_45B
; End of function attempt_to_boot


; =============== S U B R O U T I N E =======================================


sub_4A4:                                ; CODE XREF: attempt_to_boot+3B↑p
                out     (82h), a
                call    sub_507
                ld      a, 0Bh
                call    sub_509
                ld      a, 80h
                out     (80h), a
                call    pause_256
                ld      c, 83h
                push    hl
                call    sub_4F7
                pop     hl
                in      a, (80h)
                and     1Dh
                ret
; End of function sub_4A4

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR attempt_to_boot

loc_4C1:                                ; CODE XREF: attempt_to_boot+3F↑j
                ld      a, e
                dec     a
                jr      nz, loc_4D2
                ld      de, 20h ; ' '
                add     hl, de
                ld      a, (hl)
                cp      0C3h
                jr      z, loc_4ED
                ld      e, 9
                jr      loc_496
; ---------------------------------------------------------------------------

loc_4D2:                                ; CODE XREF: attempt_to_boot+64↑j
                xor     a
                out     (85h), a
                ld      bc, 7FFDh
                ld      a, 17h
                out     (c), a
                ld      hl, 527h
                ld      de, OUT_0_A_JP_3D2F ; PREPARE HELPER IN RAM
                ld      bc, 5
                ldir
                push    bc
                ld      a, 0E0h
                jp      OUT_0_A_JP_3D2F
; ---------------------------------------------------------------------------

loc_4ED:                                ; CODE XREF: attempt_to_boot+6D↑j
                ld      bc, 7FFDh
                ld      a, 1Fh
                out     (c), a
                ld      e, 21h ; '!'
                jp      (hl)
; END OF FUNCTION CHUNK FOR attempt_to_boot

; =============== S U B R O U T I N E =======================================


sub_4F7:                                ; CODE XREF: sub_4A4+14↑p
                                        ; sub_4F7+5↓j ...
                in      a, (80h)
                rrca
                ret     nc
                rrca
                jr      nc, sub_4F7
                ini
                jr      sub_4F7
; End of function sub_4F7


; =============== S U B R O U T I N E =======================================


pause_256:                              ; CODE XREF: attempt_to_boot+10↑p
                                        ; sub_4A4+E↑p ...
                xor     a

loc_503:                                ; CODE XREF: pause_256+3↓j
                dec     a
                ret     z
                jr      loc_503
; End of function pause_256


; =============== S U B R O U T I N E =======================================


sub_507:                                ; CODE XREF: attempt_to_boot+18↑p
                                        ; sub_4A4+2↑p
                ld      a, 0D8h
; End of function sub_507


; =============== S U B R O U T I N E =======================================


sub_509:                                ; CODE XREF: attempt_to_boot+1C↑p
                                        ; sub_4A4+7↑p
                out     (80h), a
                call    pause_256

loc_50E:                                ; CODE XREF: sub_509+8↓j
                in      a, (80h)
                rrca
                jr      c, loc_50E
                ret
; End of function sub_509

; ---------------------------------------------------------------------------

TEST_ROM_PROC_BODY:                     ; DATA XREF: ROM:0539↓o
                out     (0), a

loc_516:                                ; CODE XREF: ROM:0521↓j
                ld      a, (hl)
                add     a, e
                ld      e, a
                ld      a, 0
                adc     a, d
                ld      d, a
                inc     hl
                ld      a, 40h ; '@'
                cp      h
                jr      nz, loc_516
                xor     a
                out     (0), a
                ret
; ---------------------------------------------------------------------------

OUT_0_A_JP_3D2F_PROC_BODY:              ; DATA XREF: ROM:0544↓o
                out     (0), a
                jp      #3D2F           ; TR-DOS
; ---------------------------------------------------------------------------

RUN_TEST_MEM:                           ; CODE XREF: ROM:0203↑j
                ld      a, 7
                out     (0FEh), a
                ld      (#5CFF), a
                ld      hl, 0
                ld      (#5D00), hl
                ld      hl, TEST_ROM_PROC_BODY
                ld      de, TEST_ROM
                ld      bc, 13h
                ldir
                ld      hl, OUT_0_A_JP_3D2F_PROC_BODY ; PREPARE TR-DOS JUMPER IN RAM
                ld      de, OUT_0_A_JP_3D2F
                ld      bc, 5
                ldir

loc_54F:                                ; CODE XREF: sub_605+E8↓j
                ld      sp, 6000h
                ld      a, 10h
                ld      bc, 7FFDh
                out     (c), a
                ld      hl, 4000h       ; cls
                ld      de, 4001h
                ld      bc, 17FFh
                ld      (hl), 0
                ldir
                inc     hl              ; cls attr
                inc     de
                ld      (hl), 38h ; '8'
                ld      bc, 2FFh
                ldir
                ld      hl, 4000h
                ld      de, aRomMenuQuorumV ; "ROM-MENU QUORUM V.4.2 27.06.1997"
                ld      b, 20h ; ' '
                rst     8
                ld      hl, 50E4h
                ld      de, aPressResForBre ; "Press <RES> for break"
                ld      b, 15h
                rst     8
                ld      hl, 50C5h
                ld      de, aTestRomRamN ; "Test ROM/RAM N "
                ld      b, 0Fh
                rst     8
                ld      de, (#5D00)
                inc     de

loc_58F:
                ld      (#5D00), de
                call    sub_796

loc_596:
                ld      hl, 4040h
                ld      de, aRom64Kbyte ; "ROM  64 Kbyte"
                ld      b, 0Dh
                rst     8
                ld      ix, 5Bh ; '['
                xor     a

loc_5A4:                                ; CODE XREF: sub_605+4C↓j
                ld      hl, 4064h
                push    af
                push    af
                push    af
                sla     a
                sla     a
                sla     a
                sla     a
                sla     a
                add     a, l
                ld      l, a
                ld      de, aPageN      ; "Page N "
                ld      b, 7
                rst     8
                pop     af
                add     a, 30h ; '0'
                rst     10h
                rst     18h
                pop     af
                push    hl
                or      a
                jr      z, loc_611
                dec     a
                jr      nz, loc_601
                in      a, (80h)
                cp      0FFh
                jr      z, loc_5F8
                ld      hl, 5E9h
                push    hl
                ld      hl, 5D11h
                push    hl
                ld      hl, 180Dh
                push    hl
                ld      hl, 0
                ld      de, 0C000h
                ld      bc, 4000h
                ld      a, 0A0h         ; BASIC + TRDOS
                jp      OUT_0_A_JP_3D2F
; ---------------------------------------------------------------------------
                ld      hl, 0C000h
                ld      de, 0
                ld      bc, 4000h
                ldir
                ld      a, 1
                jr      loc_611
; ---------------------------------------------------------------------------

loc_5F8:                                ; CODE XREF: ROM:05CD↑j
                pop     hl
                ld      de, aNoTrdos    ; "no TRDOS"
                ld      b, 8
                rst     8
                jr      loc_64B
; ---------------------------------------------------------------------------

loc_601:                                ; CODE XREF: ROM:05C7↑j
                dec     a
                ld      bc, 7FFDh

; =============== S U B R O U T I N E =======================================


sub_605:
                jr      nz, loc_60B
                ld      a, 0
                jr      loc_60D
; ---------------------------------------------------------------------------

loc_60B:                                ; CODE XREF: sub_605↑j
                ld      a, 10h

loc_60D:                                ; CODE XREF: sub_605+4↑j
                out     (c), a
                ld      a, 20h ; ' '

loc_611:                                ; CODE XREF: ROM:05C4↑j
                                        ; ROM:05F6↑j
                ld      hl, 0
                ld      d, h
                ld      e, l
                call    TEST_ROM
                pop     hl
                ld      a, 7Fh
                in      a, (0FEh)
                rrca
                jr      nc, loc_648
                ld      a, (ix+0)
                cp      e
                jr      nz, loc_62F
                ld      de, aOk         ; "OK"
                ld      b, 2
                rst     8
                jr      loc_64B
; ---------------------------------------------------------------------------

loc_62F:                                ; CODE XREF: sub_605+20↑j
                ld      a, (#5CFF)
                or      18h
                ld      (#5CFF), a
                xor     18h
                push    de
                ld      de, 8000h

loc_63D:                                ; CODE XREF: sub_605+40↓j
                xor     10h
                out     (0FEh), a
                ld      b, d

loc_642:                                ; CODE XREF: sub_605:loc_642↓j
                djnz    $
                dec     e
                jr      nz, loc_63D
                pop     de

loc_648:                                ; CODE XREF: sub_605+1A↑j
                call    sub_796

loc_64B:                                ; CODE XREF: ROM:05FF↑j
                                        ; sub_605+28↑j
                pop     af
                inc     ix
                inc     a
                cp      4
                jp      nz, loc_5A4
                ld      hl, TEST_RAM_PROC_BODY
                ld      de, TEST_RAM
                ld      bc, 1Ah
                ldir
                ld      bc, 7FFDh
                ld      hl, 0C000h
                ld      hl, 40E0h
                ld      de, aRam256Kbyte ; "RAM 256 Kbyte"
                ld      b, 0Dh
                rst     8
                ld      e, 0

loc_670:                                ; CODE XREF: sub_605+DC↓j
                ld      a, e
                cp      8
                jr      c, loc_677
                add     a, 38h ; '8'

loc_677:                                ; CODE XREF: sub_605+6E↑j
                ld      bc, 7FFDh
                out     (c), a
                push    de
                ld      hl, 4804h
                ld      a, e
                push    af
                and     7
                sla     a
                sla     a
                sla     a
                sla     a
                sla     a
                add     a, l
                ld      l, a
                ld      de, aPageN      ; "Page N "
                ld      b, 0Bh
                rst     8
                dec     hl
                dec     hl
                dec     hl
                dec     hl
                pop     af
                add     a, 30h ; '0'
                cp      3Ah ; ':'
                jr      c, loc_6A3
                add     a, 7

loc_6A3:                                ; CODE XREF: sub_605+9A↑j
                rst     10h
                rst     18h
                ld      iy, 39h ; '9'

loc_6A9:                                ; CODE XREF: sub_605+CE↓j
                ld      a, (iy+0)
                cp      0C3h
                jr      z, loc_6D5
                pop     de
                push    de
                ld      a, e
                cp      5
                jr      nz, loc_6C0
                ld      bc, 20h ; ' '
                ld      ix, 0E000h
                jr      loc_6C7
; ---------------------------------------------------------------------------

loc_6C0:                                ; CODE XREF: sub_605+B0↑j
                ld      bc, 40h ; '@'
                ld      ix, 0C000h

loc_6C7:                                ; CODE XREF: sub_605+B9↑j
                push    hl
                ld      h, (iy+0)
                call    TEST_RAM
                jr      nz, loc_6F0
                pop     hl
                inc     iy
                jr      loc_6A9
; ---------------------------------------------------------------------------

loc_6D5:                                ; CODE XREF: sub_605+A9↑j
                ld      de, aOk         ; "OK"
                ld      b, 2
                rst     8

loc_6DB:                                ; CODE XREF: sub_605+100↓j
                pop     de
                ld      a, e
                inc     a
                cp      10h
                ld      e, a
                jr      nz, loc_670
                ld      a, (#5CFF)
                xor     18h
                ld      (#5CFF), a
                out     (0FEh), a
                jp      loc_54F
; ---------------------------------------------------------------------------

loc_6F0:                                ; CODE XREF: sub_605+C9↑j
                ld      c, l
                pop     hl
                push    ix
                pop     de
                push    af
                call    sub_796
                rst     18h
                ld      a, c
                rst     28h
                rst     18h
                pop     af
                rst     28h
                call    sub_782
                call    sub_777
                jr      loc_6DB
; End of function sub_605

; ---------------------------------------------------------------------------

TEST_RAM_PROC_BODY:                     ; DATA XREF: sub_605+4F↑o
                ld      a, 1
                out     (0), a

loc_70B:                                ; CODE XREF: ROM:0717↓j
                                        ; ROM:071A↓j
                ld      (ix+0), h
                ld      l, (ix+0)
                ld      a, h
                cp      l
                jr      nz, loc_71C
                inc     ix
                djnz    loc_70B
                dec     c
                jr      nz, loc_70B

loc_71C:                                ; CODE XREF: ROM:0713↑j
                ld      a, 0
                out     (0), a
                ret
; ---------------------------------------------------------------------------
aTestRomRamN:   DEFB 'Test ROM/RAM N ' ; DATA XREF: ROM:0584↑o
aNoTrdos:       DEFB 'no TRDOS'       ; DATA XREF: ROM:05F9↑o
aRom64Kbyte:    DEFB 'ROM  64 Kbyte'  ; DATA XREF: ROM:0599↑o
aRam256Kbyte:   DEFB 'RAM 256 Kbyte'  ; DATA XREF: sub_605+63↑o
                db  32h ; 2
                db  35h ; 5
                db  36h ; 6
aPressResForBre:DEFB 'Press <RES> for break'
                                        ; DATA XREF: ROM:057B↑o
aPageN:         DEFB 'Page N '        ; DATA XREF: ROM:05B6↑o
                                        ; sub_605+8B↑o
                db  20h
                db  20h
                db  20h
                db  20h
aOk:            DEFB 'OK'             ; DATA XREF: sub_605+22↑o
                                        ; sub_605:loc_6D5↑o

; =============== S U B R O U T I N E =======================================


sub_777:                                ; CODE XREF: sub_605+FD↑p
                                        ; sub_777+7↓j
                ld      b, 28h ; '('

loc_779:                                ; CODE XREF: sub_777+9↓j
                ld      a, 0F7h
                in      a, (7Eh)
                rrca
                jr      c, sub_777
                djnz    loc_779
; End of function sub_777


; =============== S U B R O U T I N E =======================================


sub_782:                                ; CODE XREF: sub_605+FA↑p
                ld      a, 2
                ld      de, 8000h

loc_787:                                ; CODE XREF: sub_782+D↓j
                xor     17h
                out     (0FEh), a
                ld      b, d

loc_78C:                                ; CODE XREF: sub_782:loc_78C↓j
                djnz    $
                dec     e
                jr      nz, loc_787
                ld      a, 7
                out     (0FEh), a
                ret
; End of function sub_782


; =============== S U B R O U T I N E =======================================


sub_796:                                ; CODE XREF: ROM:0593↑p
                                        ; sub_605:loc_648↑p ...
                ld      a, d
                rst     28h
                ld      a, e

loc_799:                                ; CODE XREF: sub_28↑j
                push    af
                rrca
                rrca
                rrca
                rrca
                call    _PRINT_HEX_NUM
                pop     af
; End of function sub_796


; =============== S U B R O U T I N E =======================================


_PRINT_HEX_NUM:                         ; CODE XREF: sub_796+8↑p
                and     0Fh
                cp      0Ah
                jr      c, _PRINT_DEC_NUM
                add     a, 7

_PRINT_DEC_NUM:                         ; CODE XREF: _PRINT_HEX_NUM+4↑j
                add     a, 30h ; '0'

_PRINT_CHAR:                            ; CODE XREF: PRINT_CHAR_A↑j
                push    bc
                push    de
                push    hl
                sub     20h ; ' '
                jr      nc, loc_7BA
                add     a, 10h
                ld      de, FONT_PSEUDOGRAPH
                jr      loc_7BD
; ---------------------------------------------------------------------------

loc_7BA:                                ; CODE XREF: _PRINT_HEX_NUM+F↑j
                ld      de, FONT_8x8

loc_7BD:                                ; CODE XREF: _PRINT_HEX_NUM+16↑j
                ld      l, a
                ld      h, 0
                add     hl, hl          ; DE = FONT + 8 * A
                add     hl, hl
                add     hl, hl
                add     hl, de
                ex      de, hl
                pop     hl
                push    hl
                ld      b, 8

loc_7C9:                                ; CODE XREF: _PRINT_HEX_NUM+2E↓j
                ld      a, (de)
                ld      (hl), a
                rra
                or      (hl)
                ld      (hl), a
                inc     h
                inc     de
                djnz    loc_7C9
                pop     hl
                inc     hl
                pop     de
                pop     bc
                ret
; End of function _PRINT_HEX_NUM

                ORG #07F0

aKarimovKamill: DEFB 'Karimov Kamill  '
aRomMenuQuorumV:DEFB 'ROM-MENU QUORUM V.4.2 27.06.1997'
IMG             INCBIN "bins/menu48.bin"

TURBO_LOADER_PATCH:
                INCBIN "generated/48_turbo_vs_48_patch.bin"
                db    0                 ; patch end
CODE_BLOCK_1:   db 0F3h,0AFh, 11h,0FFh,0FFh,0C3h,0CBh, 11h
                                        ; DATA XREF: ROM:0351↑o
                db  2Ah, 5Dh, 5Ch, 22h, 5Fh, 5Ch, 18h, 43h
                db 0C3h,0F2h, 15h,0FFh,0FFh,0FFh,0FFh,0FFh
                db  2Ah, 5Dh, 5Ch, 7Eh,0CDh, 7Dh,   0,0D0h
                db 0CDh, 74h,   0, 18h,0F7h
                
                ORG #1942
ORIG_48_ROM_PATCH
                INCBIN "generated/q48_vs_orig48_patch.bin"
                db    0                 ; patch end

                ORG #1B60
UNK_BLOB:       INCBIN "bins/unk.bin"
                
                ORG #1D00
FONT_8x8:       INCBIN "bins/font8x8.bin"
FOXMON:         INCBIN "bins/foxmon.bin"
COPY128_IMG:    INCBIN "bins/copy128.bin"
UNK_BLOB2_0:    INCBIN "bins/unk2.bin"

                SAVEBIN 'quorum-menu.rom', 0, 16384