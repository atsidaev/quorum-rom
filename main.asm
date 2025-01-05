                DEVICE ZXSPECTRUM48

; Ensure 0xFF in all gaps
                ORG 0
                DUP 16384
                DB 0xFF
                EDUP

SCREEN_4000     EQU #4000
OUT_0_A_JP_3D2F EQU #5D15
TEST_RAM        EQU #5D1A
TEST_ROM        EQU #5D02

                INCLUDE "quorum_ports.inc"

MENU_BEGIN_SCREEN_ADDR  EQU #4808
VER_BEGIN_SCREEN_ADDR   EQU #50E0

; RST 0
                ORG 0
sub_0:                                  ; DATA XREF: ROM:0303↓w
                di
                ld      hl, 0
                ld      sp, hl
                exx
                jr      loc_30


; RST 8
                ORG #0008
PRINT:                                  ; CODE XREF: PRINT+3↓j
                                        ; DRAW_MENU+16↓p ...
                ld      a, (de)
                rst     10h
                inc     de
                djnz    PRINT
                ret

; RST 10
                ORG #0010

PRINT_CHAR_A:                           ; CODE XREF: PRINT+1↑p
                                        ; sub_18+2↓j ...
                jp      _PRINT_CHAR

                out     (PORT_00), a
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
                jp      PRINT_HEX_NUMBER

; Unreferenced
                out     (PORT_00), a
                jr      loc_6D
                db 0DAh     ; ?????

loc_30:
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
                out     (PORT_00), a
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
                out     (PORT_00), a
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
                out     (PORT_00), a
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

loc_94:                                 ; out (PORT_00), A8 + JP 00
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
                out     (PORT_00), a
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
                jp      SWITCH_TO_48
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
                out     (PORT_00), a
                ld      hl, 28h ; '('
                ld      de, 0C028h
                ld      bc, 3FD8h
                ldir
                xor     a
                out     (PORT_00), a
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
                jr      nz, SWITCH_TO_48

; =============== S U B R O U T I N E =======================================


PATCH_ROM:

; FUNCTION CHUNK AT 004E SIZE 00000005 BYTES

                ld      hl, TURBO_LOADER_PATCH

_PATCH_TURBO_LOOP:                      ; CODE XREF: PATCH_ROM+D↓j
                ld      a, (hl)         ; amount of bytes to patch
                or      a
                jr      z, SWITCH_TO_48
                inc     hl
                ld      e, (hl)         ; DE will be address to patch
                inc     hl
                ld      d, (hl)
                inc     hl
                ld      (de), a
                jr      _PATCH_TURBO_LOOP ; repeat while patch data exists
; ---------------------------------------------------------------------------

SWITCH_TO_48:                            ; CODE XREF: ROM:0323↑j
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

INIT_FDD_CONTROLLER_AND_EXIT:
                xor     a ; NO DRIVE SELECTED AND NO MOTOR
                out     (PORT_85), a
                ret

attempt_to_boot:
                ld      hl, 8800h
                xor     a ; NO DRIVE SELECTED AND NO MOTOR
                out     (PORT_85), a
                in      a, (PORT_80)
                bit     7, a ; NOT READY?
                jr      z, INIT_FDD_CONTROLLER_AND_EXIT
                ld      a, FDD_DRIVE1 | FDD_MOTOR_ON
                out     (PORT_85), a
                call    pause_256
                in      a, (PORT_80)
                rla     ; C = NOT READY
                jr      c, INIT_FDD_CONTROLLER_AND_EXIT
                call    TERMINATE_VG93
                xor     a ; 0 - RESTORE CMD
                call    RUN_VG93_COMMAND
                ld      de, 0
                in      a, (PORT_80)
                and     2 ; bit 2 is INDEX
                ld      c, a

; Check if disk present

_WAIT_INDEX_CHANGE:
                in      a, (PORT_80)
                and     2 ; bit 2 is INDEX
                cp      c ; INDEX changed?
                jr      nz, _TRY_LOAD_SECTOR_1
                dec     de
                ld      a, d
                or      e
                jr      nz, _WAIT_INDEX_CHANGE
                jr      INIT_FDD_CONTROLLER_AND_EXIT
; ---------------------------------------------------------------------------

_TRY_LOAD_SECTOR_1:
                ld      e, 1 ; Sector #1

_TRY_LOAD_SECTOR:
                ld      b, 3 ; 3 attempts to boot

_TRY_LOAD_SECTOR_LOOP:
                ld      a, e
                push    hl
                call    _LOAD_SECTOR
                pop     hl
                jr      z, RUN_DISK ; if no errors reported, run disk
                djnz    _TRY_LOAD_SECTOR_LOOP
                jr      INIT_FDD_CONTROLLER_AND_EXIT

_LOAD_SECTOR:
                out     (PORT_82), a
                call    TERMINATE_VG93
                ld      a, #0B ; RESTORE, no VERIFY
                call    RUN_VG93_COMMAND
                ld      a, #80 ; READ SECTOR command
                out     (PORT_80), a
                call    pause_256
                ld      c, PORT_83
                push    hl
                call    READ_VG93_DATA
                pop     hl
                in      a, (PORT_80)
                and     #1D ; keep errors only
                ret
; End of function _LOAD_SECTOR

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR attempt_to_boot

RUN_DISK:
                ld      a, e
                dec     a
                jr      nz, START_TRDOS ; if sector != 1, then boot via TR-DOS
                ld      de, #20 ; CP/M boot is in sector 1, starting from byte 20
                add     hl, de ; HL=8820, boot sector was loaded there
                ld      a, (hl)
                cp      #C3 ; double checking that this is JP instruction
                jr      z, START_CPM
                ; if not JP, then this might be TR-DOS disk
                ld      e, 9 ; Load sector #9
                jr      _TRY_LOAD_SECTOR
; ---------------------------------------------------------------------------

START_TRDOS:
                xor     a
                out     (PORT_85), a
                ld      bc, 7FFDh
                ld      a, 17h
                out     (c), a
                ; PREPARE HELPER IN RAM (we cannot switch ROM to TR-DOS from QUORUM ROM directly)
                ld      hl, OUT_0_A_JP_3D2F_PROC_BODY
                ld      de, OUT_0_A_JP_3D2F
                ld      bc, OUT_0_A_JP_3D2F_PROC_BODY_END - OUT_0_A_JP_3D2F_PROC_BODY
                ldir
                push    bc
                ld      a, 0E0h
                jp      OUT_0_A_JP_3D2F
; ---------------------------------------------------------------------------

START_CPM:                                ; CODE XREF: attempt_to_boot+6D↑j
                ld      bc, 7FFDh
                ld      a, 1Fh
                out     (c), a
                ld      e, 21h
                jp      (hl)
; END OF FUNCTION CHUNK FOR attempt_to_boot

READ_VG93_DATA:
                in      a, (PORT_80)
                rrca    ; is BUSY (bit0)?
                ret     nc ; return if not busy
                rrca    ; DRQ (data request)?
                jr      nc, READ_VG93_DATA ; repeat if not DRQ
                ini     ; read port C into (HL++)
                jr      READ_VG93_DATA
; End of function READ_VG93_DATA


pause_256:
                xor     a

_pause_256_loop:
                dec     a
                ret     z
                jr      _pause_256_loop
; End of function pause_256


TERMINATE_VG93:
                ld      a, #D8 ; TERMINATE immediately
RUN_VG93_COMMAND:
                out     (PORT_80), a
                call    pause_256

READ_VG93_STATUS:
                in      a, (PORT_80)
                rrca
                jr      c, READ_VG93_STATUS
                ret

; Memory Test (Menu Option 4)

                INCLUDE "memtest_proc.asm"
RUN_TEST_MEM:
                INCLUDE "memtest.asm"

; Common functions for text output

PRINT_HEX_NUMBER:                                ; CODE XREF: sub_28↑j
                push    af
                rrca
                rrca
                rrca
                rrca
                call    PRINT_HEX_DIGIT
                pop     af

PRINT_HEX_DIGIT:                         ; CODE XREF: sub_796+8↑p
                and     0Fh
                cp      0Ah
                jr      c, _PRINT_DEC_NUM
                add     a, 7

_PRINT_DEC_NUM:                         ; CODE XREF: PRINT_HEX_DIGIT+4↑j
                add     a, 30h ; '0'

_PRINT_CHAR:                            ; CODE XREF: PRINT_CHAR_A↑j
                push    bc
                push    de
                push    hl
                sub     20h ; ' '
                jr      nc, _DRAW_REGULAR_FONT_CHAR
                add     a, 10h
                ld      de, FONT_PSEUDOGRAPH
                jr      _DRAW_CHAR
; ---------------------------------------------------------------------------

_DRAW_REGULAR_FONT_CHAR:
                ld      de, FONT_8x8

_DRAW_CHAR:
                ld      l, a
                ld      h, 0
                add     hl, hl
                add     hl, hl
                add     hl, hl
                add     hl, de
                ex      de, hl          ; DE = FONT + 8 * A
                pop     hl
                push    hl
                ld      b, 8            ; 8 lines of char

_DRAW_CHAR_LOOP:                                ; CODE XREF: PRINT_HEX_DIGIT+2E↓j
                ld      a, (de)
                ld      (hl), a
                rra
                or      (hl)
                ld      (hl), a
                inc     h
                inc     de
                djnz    _DRAW_CHAR_LOOP
                pop     hl
                inc     hl
                pop     de
                pop     bc
                ret

; Data and code blobs

                ORG #07F0

aKarimovKamill: DEFB 'Karimov Kamill  '
aRomMenuQuorumV:DEFB 'ROM-MENU QUORUM V.4.2 27.06.1997'
IMG             INCBIN "bins/menu48.bin"

TURBO_LOADER_PATCH:
                INCBIN "generated/48_turbo_vs_48_patch.bin"
                db    0                 ; patch end

CODE_BLOCK_1:   db 0F3h,0AFh, 11h,0FFh,0FFh,0C3h,0CBh, 11h
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